with membership as (

    select
        year,
        county_name,
        issuer,
        enrollees_total,
        enrollees_pct

    from {{ ref("stg_cc_membership_profile") }}

),

county_totals as (

    select
        year,
        county_name,

        sum(enrollees_total) as total_marketplace_enrollment,

        sum(
            case
                when lower(issuer) like '%kaiser%'
                    then enrollees_total
                else 0
            end
        ) as kp_enrollment

    from membership

    group by
        year,
        county_name
),

with_geography as (

    select
        ct.year,

        dc.state_code,
        dc.state_fips,
        dc.county_name,
        dc.county_fips,

        ct.kp_enrollment,
        ct.total_marketplace_enrollment,

        case
            when ct.total_marketplace_enrollment > 0
                then ct.kp_enrollment / ct.total_marketplace_enrollment
        end as kp_market_share

    from county_totals ct

    inner join {{ ref("dim_county") }} dc
        on ct.county_name = dc.county_name
),

with_lags as (

    select
        *,

        lag(kp_enrollment) over (
            partition by county_fips
            order by year
        ) as prior_kp_enrollment,

        lag(total_marketplace_enrollment) over (
            partition by county_fips
            order by year
        ) as prior_total_marketplace_enrollment,

        lag(kp_market_share) over (
            partition by county_fips
            order by year
        ) as prior_kp_market_share

    from with_geography
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

        kp_enrollment,
        total_marketplace_enrollment,
        kp_market_share,

        case
            when prior_kp_enrollment > 0
                then (kp_enrollment - prior_kp_enrollment)
                     / prior_kp_enrollment
        end as kp_enrollment_growth_yoy_pct,

        case
            when prior_total_marketplace_enrollment > 0
                then (
                    total_marketplace_enrollment
                    - prior_total_marketplace_enrollment
                )
                / prior_total_marketplace_enrollment
        end as marketplace_enrollment_growth_yoy_pct,

        case
            when prior_kp_market_share is not null
                then kp_market_share - prior_kp_market_share
        end as kp_market_share_change_yoy_pp

    from with_lags
)

select *
from final