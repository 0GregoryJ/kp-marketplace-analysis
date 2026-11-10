with forecast as (

    select *
    from {{ ref("stg_forecast_cty_inputs") }}

),

enriched as (

    select
        f.forecast_year,
        f.scenario,
        f.measure,
        f.value,
        f.source,
        f.notes,

        dc.state_code,
        dc.state_fips,
        dc.county_name,
        dc.county_fips,

        {{ dbt_utils.generate_surrogate_key([
            "dc.county_fips",
            "f.forecast_year",
            "f.scenario",
            "f.measure",
        ]) }} as county_forecast_sk

    from forecast f

    inner join {{ ref("dim_county") }} dc
        on f.county_fips = dc.county_fips

)

select
    county_forecast_sk,
    forecast_year,
    state_code,
    state_fips,
    county_name,
    county_fips,
    scenario,
    measure,
    value,
    source,
    notes

from enriched
