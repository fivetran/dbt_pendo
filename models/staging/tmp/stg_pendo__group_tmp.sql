{{
    pendo.pendo_union_connections(
        connection_dictionary='pendo_sources',
        single_source_name='pendo',
        single_table_name='group',
        default_identifier='GROUP' if target.type == "snowflake" else 'group'
    )
}}
