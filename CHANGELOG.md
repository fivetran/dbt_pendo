# dbt_pendo v0.UPDATE.UPDATE

 ## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_pendo v0.5.0
PR [#21](https://github.com/fivetran/dbt_pendo/pull/21) includes the following updates:
## 🚨 Breaking Changes 🚨:
- This is a breaking change due to changes made in the source package. (See [Source CHANGELOG](https://github.com/fivetran/dbt_pendo_source/blob/main/CHANGELOG.md)).
- Due to changes made in this release and v0.4.0, `_fivetran_id` has been added to the following models:
	  - `pendo__feature_event`
	  - `pendo__guide_event`
	  - `pendo__page_event`

- `_fivetran_id` has also been added to the hashing formula used in the following fields:
  - `feature_event_key` in `pendo__feature_event`
  - `guide_event_key` in `pendo__guide_event`
  - `page_event_key` in `pendo__page_event`

## ✨ Features
- Updated documentation for new `_fivetran_id` field.
- Updated documentation and packages to reference the latest version of the source package.

# dbt_pendo v0.4.0
## 🚨 Breaking Changes 🚨:
- This is a breaking change due to changes made in the source package. (See [Source CHANGELOG](https://github.com/fivetran/dbt_pendo_source/blob/main/CHANGELOG.md)). 
## ✨ Features
- Updated documentation and packages to reference the latest version of the source package. ([#20](https://github.com/fivetran/dbt_pendo/pull/20))
- Revised readme instructions for successfully setting up the `GROUP` table with Snowflake. ([#20](https://github.com/fivetran/dbt_pendo/pull/20))

# dbt_pendo v0.3.1
## Bug Fixes
- Updated readme for workaround if the pendo_<default_source_table_name>_identifer is having trouble with Snowflake reserved words. ([#19](https://github.com/fivetran/dbt_pendo/pull/19))
# dbt_pendo v0.3.0
[PR #17](https://github.com/fivetran/dbt_pendo/pull/17) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `dbt_utils.surrogate_key` has also been updated to `dbt_utils.generate_surrogate_key`. Since the method for creating surrogate keys differ, we suggest all users do a `full-refresh` for the most accurate data. For more information, please refer to dbt-utils [release notes](https://github.com/dbt-labs/dbt-utils/releases) for this update.
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
- Incremental strategy within the `int_pendo__calendar_spine` model has been adjusted to use the `delete+insert` strategy for Postgres and Redshift adapters.
## 🎉 Documentation and Feature Updates 🎉:
- Updated README documentation for easier navigation and dbt package setup.

# dbt_pendo v0.2.1
## 🐞 Bugfix 
- Include `nullif` to all division fields to prevent divide by zero. ([#16](https://github.com/fivetran/dbt_pendo/pull/16))
## Contributors
[@darreldonnelly](https://github.com/darreldonnelly) ([[#15](https://github.com/fivetran/dbt_pendo/issues/15)])

# dbt_pendo v0.2.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_pendo_source`. Additionally, the latest `dbt_pendo_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_pendo_source v0.1.0 -> v0.1.1
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
