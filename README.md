# Pendo Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_pendo/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_pendo/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0,_<3.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that pendoage Pendo data from [Fivetran's connector](https://fivetran.com/docs/applications/pendo) in the format described by [this ERD](https://fivetran.com/docs/applications/pendo#schemainformation).

- Enables you to understand how users are experiencing and adopting your product. It achieves thi by:
  - Calculating usage of features, pages, guides, and the overall product at the account and individual visitor level
  - Enhancing event stream tables with visitor and product information, referring pages, and features to track the customer journey through the application
  - Creating daily activity timelines for features, pages, and guides that reflect their adoption rates, discoverability, and usage promotion efficacy
  - Directly tying visitors and features together to determine activation rates, power-usage, and churn risk

<!--section=“pendo_transformation_model"-->

The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_pendo/#!/overview?g_v=1).

| **Table**                | **Description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [pendo__account](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__account)             | Each record represents a unique account in Pendo, enriched with metrics regarding associated visitors and their feature, page, and overall product activity (total and daily averages). Also includes their aggregated NPS ratings and the frequency and longevity of their product usage. |
| [pendo__feature](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__feature)             | Each record represents a unique tagged feature in Pendo, enriched with information about the page it lives on, the application and product area it is a part of, and the internal users who created and/or updated it last. Also includes metrics regarding the visitors' time spent using the feature and click-interactions with individual visitors and accounts. |
| [pendo__page](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__page)             | Each record represents a unique tagged page in Pendo, enriched with information about its URL rules, the application and product area it is a part of, the internal users who created and/or updated it last, and the features that are currently live on it. Also includes metrics regarding the visitors' time spent on the page and pageview-interactions with individual visitors and accounts. |
| [pendo__visitor](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__visitor)             | Each record represents a unique visitor in Pendo, enriched with metrics regarding associated accounts and the visitor's latest NPS rating, as well as the frequency, longevity, and average length of their daily product usage.  |
| [pendo_guide](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide)             | Each record represents a unique guide presented to visitors via Pendo. Includes metrics about the number of visitors and accounts performing various activities upon guides, such as completing or dismissing them. |
| [pendo__account_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__account_daily_metrics)             | A daily historical timeline of the overall product, feature, and page activity associated with each account, along with the number of associated users performing each kind of interaction. |
| [pendo__feature_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__feature_daily_metrics)             | A daily historical timeline, beginning at the creation of each feature, of the accounts and visitors clicking on each feature, the average daily time spent using the feature, and the percent share of total daily feature activity pertaining to this particular feature. |
| [pendo__page_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__page_daily_metrics)             | A daily historical timeline, beginning at the creation of each page, of the accounts and visitors loading on each page, the average daily time spent on the page, and the percent share of total daily pageview activity pertaining to this particular page. |
| [pendo__visitor_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__visitor_daily_metrics)             | A daily historical timeline of the overall product, feature, and page activity tracked for an individual visitor. Includes the daily number of different pages and features interacted with. |
| [pendo__guide_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics)             | A daily historical timeline of the accounts and individual visitors interacting with guides via different types of actions. |
| [pendo__feature_event](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics)             | The event stream of clicks on tagged features in Pendo. Enriched with any visitor and/or account passthrough columns, the previous feature and page that the visitor interacted with, the application and platform the event occurred on, and information on the feature and its product area. |
| [pendo__page_event](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics)             | The event stream of views of tagged pages in Pendo. Enriched with any visitor and/or account passthrough columns, the previous page that the visitor interacted with, the application and platform the event occurred on, and information on the page and its product area. |
| [pendo__guide_event](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics)             | The event stream of different kinds of interactions visitors have with guides. Enriched with any visitor and/or account passthrough columns, as well as the application and platform that the event occurred on. |
| [pendo__visitor_feature](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__visitor_feature)             | Each record represents a unique combination of visitors and features, aimed at making "power-users" of particular features easy to find. Includes metrics reflecting the longevity and frequency of feature usage. |

### Materialized Models
Each Quickstart transformation job run materializes 68 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Pendo connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package
Include the following pendo package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yml
# packages.yml
packages:
  - package: fivetran/pendo
    version: [">=1.2.0", "<1.3.0"] # we recommend using ranges to capture non-breaking changes automatically
```

> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/pendo_source` in your `packages.yml` since this package has been deprecated.

### Step 3: Define database and schema variables

#### Option A: Single connection
By default, this package runs using your [destination](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile) and the `pendo` schema. If this is not where your Pendo data is (for example, if your Pendo schema is named `pendo_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  pendo:
    pendo_database: your_database_name
    pendo_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple Pendo connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the `pendo_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  pendo:
    pendo_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

##### Recommended: Incorporate unioned sources into DAG
> *If you are running the package through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore), the below step is necessary in order to synchronize model runs with your Pendo connections. Alternatively, you may choose to run the package through Fivetran [Quickstart](https://fivetran.com/docs/transformations/quickstart), which would create separate sets of models for each Pendo source rather than one set of unioned models.*

By default, this package defines one single-connection source, called `pendo`, which will be disabled if you are unioning multiple connections. This means that your DAG will not include your Pendo sources, though the package will run successfully.

To properly incorporate all of your Pendo connections into your project's DAG:
1. Define each of your sources in a `.yml` file in your project. Utilize the following template for the `source`-level configurations, and, **most importantly**, copy and paste the table and column-level definitions from the package's `src_pendo.yml` [file](https://github.com/fivetran/dbt_pendo/blob/main/models/staging/src_pendo.yml).

```yml
# a .yml file in your root project

version: 2

sources:
  - name: <name> # ex: Should match name in pendo_sources
    schema: <schema_name>
    database: <database_name>
    loader: fivetran
    config:
      loaded_at_field: _fivetran_synced
      freshness: # feel free to adjust to your liking
        warn_after: {count: 72, period: hour}
        error_after: {count: 168, period: hour}

    tables: # copy and paste from pendo/models/staging/src_pendo.yml - see https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/ for how to use anchors to only do so once
```

> **Note**: If there are source tables you do not have (see [Step 4](https://github.com/fivetran/dbt_pendo?tab=readme-ov-file#step-4-disable-models-for-non-existent-sources)), you may still include them, as long as you have set the right variables to `False`.

2. Set the `has_defined_sources` variable (scoped to the `pendo` package) to `True`, like such:
```yml
# dbt_project.yml
vars:
  pendo:
    has_defined_sources: true
```

### (Optional) Step 4: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Passthrough Columns

This package includes all of the source columns that are defined in the macros folder. We recommend including custom columns in this package because the transformation models only bring in the standard columns for the `EVENT`, `FEATURE_EVENT`, `PAGE_EVENT`, `ACCOUNT_HISTORY`, and `VISITOR_HISTORY` tables.

You can add more columns using our passthrough column variables. These variables allow the passthrough columns to be aliased (`alias`) and casted (`transform_sql`) if you want, although it is not required. You can configure the datatype casting using a SQL snippet within the `transform_sql` key. You may add the desired SQL snippet while omitting the `as field_name` part of the casting statement - we rename this column with the alias attribute - and your custom passthrough columns will be casted accordingly.

Use the following format for declaring the respective passthrough variables:

```yml
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
  pendo__event_pass_through_columns: # will be passed to stg_pendo__event only
    - name:           "well_named_field_3"
```

#### Changing the Build Schema

By default, this package builds the Pendo final models within a schema titled (`<target_schema>` + `_pendo`), intermediate models in (`<target_schema>` + `_int_pendo`), and staging models within a schema titled (`<target_schema>` + `_stg_pendo`) in your target database. If this is not where you would like your modeled Pendo data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
...
models:
    pendo:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

> NOTE: If your profile does not have permissions to create schemas in your destination, you can set each `+schema` to blank. The package will then write all tables to your pre-existing target schema.

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_pendo/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
  pendo:
    pendo_<default_source_table_name>_identifier: your_table_name 
```

##### Snowflake Users
You may need to provide the case-sensitive spelling of your source tables that are also Snowflake reserved words.

In this package, this would apply to the `GROUP` source. If you are receiving errors for this source, include the following in your `dbt_project.yml` file:
```yml
vars:
  pendo_group_identifier: '"Group"' # as an example, must include this quoting pattern and adjust for your exact casing
```

**Note:** if you have sources defined in one of your project's yml files, for example if you have a yml file with a `sources` level like in the following example, the prior code will not work.

Instead you will need to add the following where your group source table is defined in your yml:
```yml
sources:
  tables:
    - name: group 
      # Add the below
      identifier: GROUP # Or what your group table is named, being mindful of casing
      quoting:
        identifier: true
```
</details>

### (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]


    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/pendo/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_pendo/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_pendo/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
