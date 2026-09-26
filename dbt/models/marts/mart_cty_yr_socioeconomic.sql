with acs as (

    select
        year,
        county_fips,

        population_total,
        median_household_income,
        poverty_rate,
        uninsured_rate

    from {{ ref("stg_census_acs") }}

),

laus as (

    select
        year,
        county_fips,

        labor_force_total,
        employed_total,
        unemployed_total,
        unemployment_rate

    from {{ ref("stg_bls_laus") }}

),

qcew as (

    select
        year,
        county_fips,

        establishment_count,
        employment_total,
        avg_annual_pay,

        establishment_yoy_pct_change,
        employment_yoy_pct_change,
        avg_annual_pay_yoy_pct_change

    from {{ ref("stg_bls_qcew") }}

),

combined as (

    select
        a.year,

        dc.state_code,
        dc.state_fips,
        dc.county_name,
        dc.county_fips,

        a.population_total,
        a.median_household_income,
        a.poverty_rate,
        a.uninsured_rate,

        l.labor_force_total,
        l.employed_total,
        l.unemployed_total,
        l.unemployment_rate,

        q.establishment_count,
        q.employment_total,
        q.avg_annual_pay,

        q.establishment_yoy_pct_change,
        q.employment_yoy_pct_change,
        q.avg_annual_pay_yoy_pct_change

    from acs a

    inner join {{ ref("dim_county") }} dc
        on a.county_fips = dc.county_fips

    left join laus l
        on a.year = l.year
        and a.county_fips = l.county_fips

    left join qcew q
        on a.year = q.year
        and a.county_fips = q.county_fips

),

with_population_growth as (

    select
        *,

        lag(population_total) over (
            partition by county_fips
            order by year
        ) as prior_population_total

    from combined

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'county_fips',
            'year'
        ]) }} as county_year_sk,

        year,

        state_code,
        state_fips,
        county_name,
        county_fips,

        population_total,

        case
            when prior_population_total > 0
                then (
                    population_total - prior_population_total
                ) / prior_population_total::decimal
        end as population_growth_yoy_pct,

        median_household_income,
        poverty_rate,
        uninsured_rate,

        labor_force_total,
        employed_total,
        unemployed_total,
        unemployment_rate,

        establishment_count,
        employment_total,
        avg_annual_pay,

        establishment_yoy_pct_change,
        employment_yoy_pct_change,
        avg_annual_pay_yoy_pct_change

    from with_population_growth

)

select *
from final