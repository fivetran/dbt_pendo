{#-
    Compare the columns the package expects for a Pendo source table against the columns in the
    SOURCE table(s) the staging layer reads from. The source is what changes, so it is read
    directly, not through the built stg_pendo__<table>_tmp view (only a copy that goes stale).

    Everything is keyed by the source table name exactly as in src_pendo.yml (account_history,
    event, group, ...).

    get_column_diffs() is the package's entry point for the fivetran-source-config skill. It returns
    only the differences, as {source table: {missing, extra, source_missing, source_schemas}}:
      missing:        expected columns absent from the source (fill_staging_columns null-fills these)
      extra:          source columns the package doesn't model
      source_missing: true if no source table was found (then `missing` is every expected column)
      source_schemas: schema(s) the source was found in (more than one when connections are unioned)

    Run with `dbt run-operation pendo.get_column_diffs` it also logs the result as JSON, because
    run-operation discards return values. It has to be started that way (not from another package's
    macro or `dbt show`): only run-operation resolves var() in this package's scope.

    When several connections are unioned (pendo_sources), a column counts as present if any of them
    has it, matching how the union is built.

    At parse time (execute is false) the source can't be inspected, so empty results are returned.
-#}

{#- Expected columns per source table name. A static map, so adding a table is one edit here next to
    its get_<table>_columns() macro. Sibling macros are called as pendo.<macro>() so they resolve when
    this package is used as a dependency. -#}
{% macro pendo_expected_columns() %}
    {{ return({
        'account_history': pendo.get_account_history_columns(),
        'application_history': pendo.get_application_history_columns(),
        'event': pendo.get_event_columns(),
        'feature_event': pendo.get_feature_event_columns(),
        'feature_history': pendo.get_feature_history_columns(),
        'group': pendo.get_group_columns(),
        'guide_event': pendo.get_guide_event_columns(),
        'guide_history': pendo.get_guide_history_columns(),
        'guide_step_history': pendo.get_guide_step_history_columns(),
        'page_event': pendo.get_page_event_columns(),
        'page_history': pendo.get_page_history_columns(),
        'page_rule_history': pendo.get_page_rule_history_columns(),
        'poll': pendo.get_poll_columns(),
        'poll_event': pendo.get_poll_event_columns(),
        'user': pendo.get_user_columns(),
        'visitor_account_history': pendo.get_visitor_account_history_columns(),
        'visitor_history': pendo.get_visitor_history_columns()
    }) }}
{% endmacro %}

{#- Resolve the source relation(s) for a source table the same way stg_pendo__<table>_tmp does
    (fivetran_utils.union_connections): the pendo_sources connections if set, else the single source.
    The identifier comes from the pendo_<table>_identifier var, as in union_connections. -#}
{% macro pendo_source_relations(source_name) %}
    {% set relations = [] %}
    {% set connections = var('pendo_sources', []) %}
    {% set identifier = var('pendo_' ~ source_name ~ '_identifier', source_name) %}

    {% if connections | length > 0 %}
        {% for connection in connections %}
            {% if var('has_defined_sources', false) %}
                {% set src = source(connection.name, source_name) %}
                {% set rel = adapter.get_relation(database=src.database, schema=src.schema, identifier=src.identifier) %}
            {% else %}
                {% set rel = adapter.get_relation(
                    database=connection.database if connection.database else target.database,
                    schema=connection.schema if connection.schema else 'pendo',
                    identifier=identifier) %}
            {% endif %}
            {% if rel is not none %}{% do relations.append(rel) %}{% endif %}
        {% endfor %}

    {% else %}
        {% set src = source('pendo', source_name) %}
        {% set rel = adapter.get_relation(database=src.database, schema=src.schema, identifier=identifier) %}
        {% if rel is not none %}{% do relations.append(rel) %}{% endif %}
    {% endif %}

    {{ return(relations) }}
{% endmacro %}

{% macro get_column_diff(source_name) %}
    {% if not execute %}
        {{ return({'missing': [], 'extra': [], 'source_missing': false, 'source_schemas': []}) }}
    {% endif %}

    {% set expected_by_source = pendo.pendo_expected_columns() %}
    {% if source_name not in expected_by_source %}
        {{ exceptions.raise_compiler_error("get_column_diff: unknown source table '" ~ source_name ~ "'. Expected one of: " ~ expected_by_source.keys() | sort | join(', ')) }}
    {% endif %}

    {% set relations = pendo.pendo_source_relations(source_name) %}
    {% set actual = [] %}
    {% for relation in relations %}
        {% for column in adapter.get_columns_in_relation(relation) %}
            {% do actual.append(column.name | lower) %}
        {% endfor %}
    {% endfor %}
    {% set actual = actual | unique | list %}
    {% set expected = expected_by_source[source_name] | map(attribute='name') | map('lower') | list %}

    {{ return({
        'missing': expected | reject('in', actual) | list,
        'extra': actual | reject('in', expected) | list,
        'source_missing': relations | length == 0,
        'source_schemas': relations | map(attribute='schema') | unique | list
    }) }}
{% endmacro %}

{#- Source tables the package reads right now, from the staging models in the graph (so any disabled
    ones are skipped), keeping those with an expected-columns entry. -#}
{% macro pendo_source_tables() %}
    {% set expected_by_source = pendo.pendo_expected_columns() %}
    {% set tables = [] %}
    {% for node in graph.nodes.values() if node.resource_type == 'model' and node.package_name == 'pendo' and node.name.startswith('stg_pendo__') and node.name.endswith('_tmp') %}
        {% set source_name = node.name[11:-4] %}
        {% if source_name in expected_by_source %}
            {% do tables.append(source_name) %}
        {% endif %}
    {% endfor %}
    {{ return(tables | sort) }}
{% endmacro %}

{% macro get_column_diffs() %}
    {% set result = {} %}
    {% for source_name in pendo.pendo_source_tables() %}
        {% set diff = pendo.get_column_diff(source_name) %}
        {% if diff.missing or diff.extra %}
            {% do result.update({source_name: diff}) %}
        {% endif %}
    {% endfor %}
    {% if execute and flags.WHICH == 'run-operation' %}
        {{ log(tojson(result), info=True) }}
    {% endif %}
    {{ return(result) }}
{% endmacro %}
