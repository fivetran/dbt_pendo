{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'pendo') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('pendo_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("pendo_database", target.database) }}' || '.'|| '{{ var("pendo_schema", "pendo") }}' as source_relation
{% endif %}

{%- endmacro %}