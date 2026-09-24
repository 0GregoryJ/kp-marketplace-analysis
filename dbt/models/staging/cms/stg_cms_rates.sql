with source as (
    select *
    from read_csv(
        '../data/raw/cms/rates/*.csv',
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
        trim("ISSUER ID") as issuer_id,

        trim("PLAN ID") as plan_id,
        trim("RATING AREA ID") as rating_area_id,

        trim("TOBACCO") as tobacco,
        trim("AGE") as age,

        try_cast("INDIVIDUAL RATE" as decimal(12, 2)) as individual_rate,
        try_cast("INDIVIDUAL TOBACCO RATE" as decimal(12, 2)) as individual_tobacco_rate,

        try_cast("COUPLE" as decimal(12, 2)) as couple_rate,
        try_cast("PRIMARY SUBSCRIBER AND ONE DEPENDENT" as decimal(12, 2)) as primary_subscriber_one_dependent_rate,
        try_cast("PRIMARY SUBSCRIBER AND TWO DEPENDENTS" as decimal(12, 2)) as primary_subscriber_two_dependents_rate,
        try_cast("PRIMARY SUBSCRIBER AND THREE OR MORE DEPENDENTS" as decimal(12, 2)) as primary_subscriber_three_plus_dependents_rate,
        try_cast("COUPLE AND ONE DEPENDENT" as decimal(12, 2)) as couple_one_dependent_rate,
        try_cast("COUPLE AND TWO DEPENDENTS" as decimal(12, 2)) as couple_two_dependents_rate,
        try_cast("COUPLE AND THREE OR MORE DEPENDENTS" as decimal(12, 2)) as couple_three_plus_dependents_rate,

        trim("qhp_non_qhp_type_id") as qhp_non_qhp_type_id
    from source
)

select * from renamed