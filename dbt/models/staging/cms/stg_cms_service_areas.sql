with source as (
    select
        *
    from read_csv(
    '../data/raw/cms/service_areas/*.csv',
    union_by_name = true,
    filename = true,
    encoding = 'CP1252',
    all_varchar = true
    )
),

renamed as (
    select
        "BUSINESS YEAR"::integer as year,
        trim(split_part("COUNTY", ' - ', 1)) as county_name,
        trim(split_part("COUNTY", ' - ', 2)) as county_fips,
        TRIM("STATE CODE") as state_code,
        TRIM("ISSUER ID") as issuer_id,
        TRIM("SERVICE AREA ID") as service_area_id,
        "SERVICE AREA NAME" as service_area_name,
        case
            when lower(trim("COVER ENTIRE STATE")) in ('yes', 'true') then true
            when lower(trim("COVER ENTIRE STATE")) in ('no', 'false') then false
            else null
        end as covers_entire_state,
        case
            when lower(trim("PARTIAL COUNTY")) in ('yes', 'true') then true
            when lower(trim("PARTIAL COUNTY")) in ('no', 'false') then false
            else null
        end as is_partial_county,
        "ZIP CODE" as zip_codes,
        "MARKET COVERAGE" as market_coverage,
        case
            when trim("DENTAL PLAN ONLY") = 'Yes' then true
            when trim("DENTAL PLAN ONLY") = 'No' then false
            else null
        end as is_dental_plan_only
    from source
)

select * from renamed