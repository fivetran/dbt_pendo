<!--section="pendo_transformation_model"-->
# Pendo dbt Package

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
        href="https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

This dbt package transforms data from Fivetran's Pendo connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 68
- Connector documentation
  - [Pendo connector documentation](https://fivetran.com/docs/connectors/applications/pendo)
  - [Pendo ERD](https://fivetran.com/docs/connectors/applications/pendo#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_pendo)
  - [dbt Docs](https://fivetran.github.io/dbt_pendo/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_pendo/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_pendo/blob/main/CHANGELOG.md)

## What does this dbt package do?
This package enables you to understand how users are experiencing and adopting your product. It creates enriched models with metrics focused on feature usage, page activity, and guide interactions.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_pendo
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [pendo__account](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__account) | Consolidates account profiles with visitor counts, aggregated NPS ratings (min, max, avg), activity metrics (events, minutes, active days/months), feature and page interaction counts, and daily averages to measure account engagement and product adoption. <br></br>**Example Analytics Questions:**<ul><li>Which accounts have the highest count_associated_visitors and avg_nps_rating with the most active engagement (sum_events, sum_minutes)?</li><li>How do average_daily_minutes and average_daily_events vary by count_active_months and count_feature_clicking_visitors?</li><li>What is the time between first_event_on and last_event_on for accounts with different count_page_viewing_visitors levels?</li></ul>|
| [pendo__feature](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__feature) | Provides comprehensive feature profiles with page and product area associations, creator/updater details, core event tagging, and engagement metrics (clicks, visitors, accounts, time spent) to identify high-value features and optimize feature placement. <br></br>**Example Analytics Questions:**<ul><li>Which features have the highest sum_clicks and count_visitors relative to their product_area_name and page_name?</li><li>How do features marked is_core_event = true compare in avg_visitor_minutes and avg_visitor_events versus non-core features?</li><li>What is the time between created_at and first_click_at for features by app_platform and created_by_user_username?</li></ul>|
| [pendo__page](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__page) | Consolidates page profiles with URL rules, product area associations, active feature counts, creator/updater details, and pageview metrics (visitors, accounts, time spent) to analyze page performance and optimize page structure. <br></br>**Example Analytics Questions:**<ul><li>Which pages have the highest sum_pageviews and count_visitors by product_area_name and app_platform?</li><li>How does count_active_features correlate with avg_visitor_minutes and avg_visitor_pageviews by page?</li><li>What is the time between created_at and first_pageview_at for pages with different app_display_name values?</li></ul>|
| [pendo__visitor](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__visitor) | Provides individual visitor profiles with account associations, latest NPS rating, browser/OS details, activity metrics (events, minutes, active days/months), and daily averages to segment users and analyze engagement patterns. <br></br>**Example Analytics Questions:**<ul><li>Which visitors have the highest sum_events and sum_minutes with the best latest_nps_rating scores?</li><li>How do average_daily_minutes and average_daily_events vary by last_browser_name, last_operating_system, and count_associated_accounts?</li><li>What is the distribution of count_active_days and count_active_months by visitor cohorts based on first_event_on?</li></ul>|
| [pendo_guide](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide) | Each record represents a unique guide presented to visitors via Pendo. Includes metrics about the number of visitors and accounts performing various activities upon guides, such as completing or dismissing them. |
| [pendo__account_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__account_daily_metrics) | Chronicles daily account activity timelines with visitor counts (active, page viewing, feature clicking), event metrics (minutes, events, records), and distinct page/feature interaction counts to track account engagement trends and identify usage patterns. <br></br>**Example Analytics Questions:**<ul><li>How do sum_minutes and sum_events trend over time (date_day) by account_id?</li><li>Which accounts have the highest count_active_visitors and count_features_clicked on specific days?</li><li>What is the ratio of count_page_viewing_visitors to count_feature_clicking_visitors by account and date?</li></ul>|
| [pendo__feature_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__feature_daily_metrics) | Tracks daily feature engagement from creation with visitor/account counts (total, first-time, returning), click metrics, time spent, and relative share percentages to measure feature adoption velocity and compare feature popularity. <br></br>**Example Analytics Questions:**<ul><li>How do sum_clicks and count_visitors trend over time by feature_name and product_area_name?</li><li>What is the ratio of count_first_time_visitors to count_return_visitors by feature over time?</li><li>Which features have the highest percent_of_daily_feature_clicks and percent_of_daily_feature_visitors on specific days?</li></ul>|
| [pendo__page_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__page_daily_metrics) | Chronicles daily page views from creation with visitor/account counts (total, first-time, returning), pageview metrics, time spent, and relative share percentages to measure page adoption and compare page traffic patterns. <br></br>**Example Analytics Questions:**<ul><li>How do sum_pageviews and count_visitors trend over time by page_name and product_area_name?</li><li>What is the ratio of count_first_time_visitors to count_return_visitors for pages over time?</li><li>Which pages have the highest percent_of_daily_pageviews and avg_daily_minutes_per_visitor on specific days?</li></ul>|
| [pendo__visitor_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__visitor_daily_metrics) | Tracks daily visitor activity timelines with event metrics (minutes, events, records) and distinct page/feature interaction counts to monitor individual engagement patterns and identify power users. <br></br>**Example Analytics Questions:**<ul><li>How do sum_minutes and sum_events trend over time by visitor_id?</li><li>Which visitors have the highest count_pages_viewed and count_features_clicked on specific days?</li><li>What is the average daily breadth of engagement (count_pages_viewed + count_features_clicked) per visitor?</li></ul>|
| [pendo__guide_daily_metrics](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics) | Chronicles daily guide interactions with visitor/account counts (total, first-time), event counts, and action-specific metrics (guideSeen, guideDismissed, guideActivity, guideAdvanced, guideTimeout, guideSnoozed) to measure guide effectiveness and completion rates. <br></br>**Example Analytics Questions:**<ul><li>How do count_visitors_guideSeen versus count_visitors_guideAdvanced trend over time by guide_name?</li><li>What is the dismissal rate (count_visitors_guideDismissed / count_visitors_guideSeen) by guide and date?</li><li>Which guides have the highest count_first_time_visitors and lowest count_visitors_guideDismissed ratios?</li></ul>|
| [pendo__feature_event](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics) | Streams individual feature click events with visitor/account IDs, timing, event/minute counts, previous feature context, IP/user agent details, and feature/page/product area associations to enable granular clickstream analysis and user journey mapping. <br></br>**Example Analytics Questions:**<ul><li>What are the most common feature navigation paths (previous_feature_name to feature_name) by product_area_name?</li><li>How does num_events and num_minutes vary by feature_name, app_platform, and occurred_at hour?</li><li>Which visitors have the longest feature engagement sessions (num_minutes) and highest click rates (num_events)?</li></ul>|
| [pendo__page_event](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics) | Streams individual page view events with visitor/account IDs, timing, event/minute counts, previous page context, IP/user agent details, and page/product area associations to enable page flow analysis and session path tracking. <br></br>**Example Analytics Questions:**<ul><li>What are the most common page navigation paths (previous_page_name to page_name) by product_area_name?</li><li>How does num_events and num_minutes vary by page_name, app_platform, and occurred_at hour?</li><li>Which pages serve as the most common entry points (previous_page_id is null) and exit points?</li></ul>|
| [pendo__guide_event](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__guide_daily_metrics) | Streams individual guide interaction events with visitor/account IDs, event type (guideSeen, guideDismissed, guideActivity, guideAdvanced, guideTimeout, guideSnoozed), step details, timing, location data, and app/platform context to analyze guide completion funnels and identify friction points. <br></br>**Example Analytics Questions:**<ul><li>What is the distribution of guide event types by guide_name and guide_step_id?</li><li>How do guide completion rates vary by app_platform, country, and region?</li><li>Which guide steps have the highest dismissal rates (type = guideDismissed) versus advancement rates (type = guideAdvanced)?</li></ul>|
| [pendo__visitor_feature](https://fivetran.github.io/dbt_pendo/#!/model/model.pendo.pendo__visitor_feature) | Maps visitor-feature relationships with first/last click timing, total clicks, time spent, active days, and daily averages to identify feature power users, analyze feature stickiness, and segment users by feature engagement depth. <br></br>**Example Analytics Questions:**<ul><li>Which visitor-feature combinations have the highest sum_clicks and sum_minutes by product_area_name?</li><li>How do count_active_days and avg_daily_minutes correlate with feature adoption (first_click_at to last_click_at span)?</li><li>Who are the top power users (highest sum_clicks per feature) for each feature_name?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Pendo connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_pendo/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following pendo package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yml
# packages.yml
packages:
  - package: fivetran/pendo
    version: [">=1.3.0", "<1.4.0"] # we recommend using ranges to capture non-breaking changes automatically
```

> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/pendo_source` in your `packages.yml` since this package has been deprecated.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Define database and schema variables

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

### (Optional) Additional configurations
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

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt/setup-guide#transformationsfordbtcoresetupguide).
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

<!--section="pendo_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/pendo/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_pendo/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_pendo/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).