with source as (

    select *
    from {{ ref("forecast_cty_inputs") }}

),

renamed as (

    select
        lpad(cast(county_fips as varchar), 5, '0') as county_fips,
        cast(forecast_year as integer) as forecast_year,
        trim(cast(scenario as varchar)) as scenario,
        trim(cast(measure as varchar)) as measure,
        cast(value as double) as value,
        trim(cast(source as varchar)) as source,
        nullif(trim(cast(notes as varchar)), '') as notes

    from source

)

select * from renamed
