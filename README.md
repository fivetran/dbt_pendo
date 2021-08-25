[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=0.20.x&color=orange)
# Pendo

This package models Pendo data from [Fivetran's connector](https://fivetran.com/docs/applications/pendo). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/pendo#schemainformation).

Tthis package does soime stuff. it does this by
-
-
-

## Models

This package contains transformation models, designed to work simultaneously with our [Pendo source package](https://github.com/fivetran/dbt_pendo_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [pendo__account](models/pendo__account.sql)             | beep beep. |
| [pendo__feature](models/pendo__feature.sql)             | beep beep. |
| [pendo__page](models/pendo__page.sql)             | beep beep. |
| [pendo__visitor](models/pendo__visitor.sql)             | beep beep. |
| [pendo_guide](models/pendo__guide.sql)             | beep beep. |
| [pendo__account_daily_metrics](models/pendo__account_daily_metrics.sql)             | beep beep. |
| [pendo__feature_daily_metrics](models/pendo__feature_daily_metrics.sql)             | beep beep. |
| [pendo__page_daily_metrics](models/pendo__page_daily_metrics.sql)             | beep beep. |
| [pendo__visitor_daily_metrics](models/pendo__visitor_daily_metrics.sql)             | beep beep. |
| [pendo__guide_daily_metrics](models/pendo__guide_daily_metrics.sql)             | beep beep. |
| [pendo__visitor_feature](models/pendo__visitor_feature.sql)             | beep beep. |

## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yml
# packages.yml
packages:
  - package: fivetran/pendo
    version: [">=0.1.0", "<0.2.0"]
```

## Configuration

By default, this package looks for your Pendo data in the `pendo` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Pendo data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  pendo_database: your_database_name
  pendo_schema: your_schema_name 
```

### Passthrough Columns

Additionally, the Pendo package includes all source columns defined in the [macros folder](https://github.com/fivetran/dbt_pendo_source/tree/main/macros) of the source package. We highly recommend including custom fields in this package as models now only bring in the standard fields for the `EVENT` and `PERSON` tables.

You can add more columns using our passthrough column variables. These variables allow for the passthrough fields to be aliased (`alias`) and casted (`transform_sql`) if desired, although it is not required. Datatype casting is configured via a SQL snippet within the `transform_sql` key. You may add the desired SQL snippet while omitting the `as field_name` part of the casting statement - this will be dealt with by the alias attribute - and your custom passthrough fields will be casted accordingly.

Use the following format for declaring the respective passthrough variables:

```yml
# dbt_project.yml

vars:
  pendo__feature_event_pass_through_columns: # will be passed to pendo__feature_event and stg_pendo__feature_event
    - name:           "custom_crazy_field_name"
      alias:          "normal_field_name"
  pendo__page_event_pass_through_columns: # will be passed to pendo__page_event and stg_pendo__page_event
    - name:           "property_field_id"
      alias:          "new_name_for_this_field_id"
      transform_sql:  "cast(new_name_for_this_field as int64)"
    - name:           "this_other_field"
      transform_sql:  "cast(this_other_field as string)"
  pendo__account_history_pass_through_columns: # will be passed to pendo__account, pendo__feature_event, and pendo__page_event
    - name:           "well_named_field_1"
  pendo__visitor_history_pass_through_columns: # will be passed to pendo__visitor, pendo__feature_event, and pendo__page_event 
    - name:           "well_named_field_2"
  pendo__event_pass_through_columns: # will be passed to stg_pendo__event (in source package only)
    - name:           "well_named_field_3"
```

### Changing the Build Schema

By default, this package will build the Pendo final models within a schema titled (`<target_schema>` + `_pendo`), intermediate models in (`<target_schema>` + `_int_pendo`), and staging models within a schema titled (`<target_schema>` + `_stg_pendo`) in your target database. If this is not where you would like your modeled Pendo data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  pendo:
    +schema: my_new_schema_name # leave blank for just the target_schema
    intermediate:
      +schema: my_new_schema_name # leave blank for just the target_schema
  pendo_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```

> Note that if your profile does not have permissions to create schemas in your warehouse, you can set each `+schema` to blank. The package will then write all tables to your pre-existing target schema.

## Contributions

Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing and running the package? If so, we highly encourage and welcome contributions to this package!
Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Databricks.

## Resources:

- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
