{#-
    Compare the columns the package expects for a Pendo source table against the columns in the
    SOURCE table(s) the staging layer reads from. The source is what changes, so it is read
    directly, not through the built stg_pendo__<table>_tmp view (only a copy that goes stale).

    Every source table in the expected-columns map is diffed; tables that don't exist are reported as
    source_missing. Keys are source table names exactly as in src_pendo.yml (account_history, event, ...).

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

{#- The relation(s) holding a source table, found as stg_pendo__<table>_tmp finds them: one per pendo_sources
    connection, else the single `pendo` source. Where sources are declared in dbt (has_defined_sources, or
    the single source) source() gives the location; otherwise the connection's own database and schema do.
    The table is named by its pendo_<table>_identifier var, as in fivetran_utils.union_connections.
    Tables that aren't there are skipped. -#}
{% macro pendo_source_relations(table) %}
    {% set identifier = var('pendo_' ~ table ~ '_identifier', table) %}
    {% set places = [] %}
    {% for c in var('pendo_sources', []) %}
        {% if var('has_defined_sources', false) %}
            {% set src = source(c.name, table) %}
            {% do places.append({'database': src.database, 'schema': src.schema}) %}
        {% else %}
            {% do places.append({'database': c.database or target.database, 'schema': c.schema or 'pendo'}) %}
        {% endif %}
    {% else %}
        {% set src = source('pendo', table) %}
        {% do places.append({'database': src.database, 'schema': src.schema}) %}
    {% endfor %}

    {% set relations = [] %}
    {% for p in places %}
        {% set relation = adapter.get_relation(database=p.database, schema=p.schema, identifier=identifier) %}
        {% if relation is not none %}{% do relations.append(relation) %}{% endif %}
    {% endfor %}
    {{ return(relations) }}
{% endmacro %}

{% macro get_column_diffs() %}
    {% set result = {} %}
    {% if execute %}
        {% set expected_by_source = pendo.pendo_expected_columns() %}
        {% for source_name in expected_by_source.keys() | sort %}
            {% set relations = pendo.pendo_source_relations(source_name) %}
            {% set actual = [] %}
            {% for relation in relations %}
                {% for column in adapter.get_columns_in_relation(relation) %}
                    {% do actual.append(column.name | lower) %}
                {% endfor %}
            {% endfor %}
            {% set expected = expected_by_source[source_name] | map(attribute='name') | map('lower') | list %}
            {% set missing = expected | reject('in', actual) | list %}
            {% set extra = actual | unique | reject('in', expected) | list %}
            {% if missing or extra %}
                {% do result.update({source_name: {
                    'missing': missing,
                    'extra': extra,
                    'source_missing': relations | length == 0,
                    'source_schemas': relations | map(attribute='schema') | unique | list
                }}) %}
            {% endif %}
        {% endfor %}
        {% if flags.WHICH == 'run-operation' %}
            {{ log(tojson(result), info=True) }}
        {% endif %}
    {% endif %}
    {{ return(result) }}
{% endmacro %}
