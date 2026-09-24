with source as (
    select *
    from read_csv(
        '../data/raw/cms/plan_attributes/*.csv',
        union_by_name = true,
        filename = true,
        encoding = 'CP1252',
        all_varchar = true
    )
),

renamed as (
    select
        "BUSINESS YEAR"::integer as year,
        trim("STATE CODE") as state_code,
        '06' as state_fips,

        trim("ISSUER NAME") as issuer_name,
        trim("ISSUER ID") as issuer_id,

        trim("MARKET COVERAGE") as market_coverage,

        case
            when lower(trim("DENTAL ONLY PLAN")) in ('yes', 'true') then true
            when lower(trim("DENTAL ONLY PLAN")) in ('no', 'false') then false
            else null
        end as is_dental_only,

        trim("STANDARD COMPONENT ID") as standard_component_id,
        trim("PLAN ID") as plan_id,
        trim("PLAN MARKETING NAME") as plan_marketing_name,
        trim("HIOS PRODUCT ID") as hios_product_id,

        trim("SERVICE AREA ID") as service_area_id,
        trim("NETWORK ID") as network_id,

        trim("IS IT A NEW PLAN") as plan_status,
        trim("PLAN TYPE") as plan_type,
        trim("METAL LEVEL") as metal_level,

        trim("QHP NONQHP TYPE ID") as qhp_non_qhp_type_id,

        trim("PLAN EFFECTIVE DATE") as plan_effective_date,
        trim("PLAN EXPIRATION DATE") as plan_expiration_date,

        case
            when lower(trim("IS HSA ELIGIBLE")) in ('yes', 'true') then true
            when lower(trim("IS HSA ELIGIBLE")) in ('no', 'false') then false
            else null
        end as is_hsa_eligible,

        trim("CSR VARIATION TYPE") as csr_variation_type,
        trim("ISSUER ACTUARIAL VALUE") as issuer_actuarial_value,

        trim("PLAN DESIGN TYPE") as plan_design_type
    from source
)

select * from renamed