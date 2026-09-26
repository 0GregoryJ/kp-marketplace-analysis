with service_areas as (

    select distinct
        year,
        county_fips,

        issuer_id,
        service_area_id,

        service_area_name

    from {{ ref("stg_cms_service_areas") }}

    where market_coverage = 'Individual'
      and is_dental_plan_only = false
),

plan_attributes as (

    select
        year,

        issuer_id,
        issuer_name,

        plan_id,
        standard_component_id,
        plan_marketing_name,
        hios_product_id,

        service_area_id,
        network_id,

        plan_status,
        plan_type,
        metal_level,
        csr_variation_type,
        issuer_actuarial_value

    from {{ ref("stg_cms_plan_attributes") }}

    where market_coverage = 'Individual'
      and is_dental_only = false
      and qhp_non_qhp_type_id = 'On the Exchange'
),

rates_ranked as (

    select
        year,

        issuer_id,
        plan_id,
        rating_area_id,

        individual_rate,
        rate_effective_date,
        rate_expiration_date,

        row_number() over (
            partition by
                year,
                issuer_id,
                plan_id,
                rating_area_id
            order by
                rate_effective_date nulls first
        ) as rate_rank

    from {{ ref("stg_cms_rates") }}

    where age = '40'
      and tobacco = 'No Preference'
      and individual_rate is not null
),

rates as (

    select
        year,

        issuer_id,
        plan_id,
        rating_area_id,

        individual_rate

    from rates_ranked

    where rate_rank = 1
),

joined as (

    select
        pa.year,

        dc.state_code,
        dc.state_fips,
        dc.county_name,
        dc.county_fips,

        pa.issuer_id,
        pa.issuer_name,

        pa.plan_id,
        pa.standard_component_id,
        pa.plan_marketing_name,
        pa.hios_product_id,

        pa.service_area_id,
        sa.service_area_name,
        pa.network_id,

        pa.plan_status,
        pa.plan_type,
        pa.metal_level,
        pa.csr_variation_type,
        pa.issuer_actuarial_value,

        cra.rating_area_id,

        r.individual_rate as individual_rate_age_40,

        case
            when pa.issuer_id = '40513' then true
            when lower(pa.issuer_name) like '%kaiser%' then true
            else false
        end as is_kp

    from plan_attributes pa

    inner join service_areas sa
        on pa.year = sa.year
        and pa.issuer_id = sa.issuer_id
        and pa.service_area_id = sa.service_area_id

    inner join {{ ref("dim_county") }} dc
        on sa.county_fips = dc.county_fips

    left join {{ ref("dim_county_rating_area") }} cra
        on dc.county_fips = cra.county_fips

    left join rates r
        on pa.year = r.year
        and pa.issuer_id = r.issuer_id
        and pa.standard_component_id = r.plan_id
        and cra.rating_area_id = r.rating_area_id
),

final as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'plan_id',
            'county_fips',
            'year'
        ]) }} as plan_county_year_sk,

        *

    from joined
)

select *
from final