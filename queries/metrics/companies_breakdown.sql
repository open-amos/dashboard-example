-- Purpose: Aggregate company counts by country and industry for pie charts
-- Returns combined breakdown data with dimension type indicator

with all_companies as (
    select
        c.company_id,
        co.name as primary_country,
        i.name as primary_industry
    from dim_companies c
    left join (
        select distinct on (company_id) 
            company_id, 
            country_code
        from br_company_countries
        where primary_flag = true
        order by company_id, valid_from desc
    ) bcc on c.company_id = bcc.company_id
    left join dim_countries co on bcc.country_code = co.country_iso2_code
    left join (
        select distinct on (company_id)
            company_id, 
            industry_id
        from br_company_industries
        where primary_flag = true
        order by company_id, valid_from desc
    ) bci on c.company_id = bci.company_id
    left join dim_industries i on bci.industry_id = i.industry_id
)
select
    primary_country as dimension,
    'country' as dimension_type,
    count(*) as company_count
from all_companies
where primary_country is not null
group by primary_country

union all

select
    primary_industry as dimension,
    'industry' as dimension_type,
    count(*) as company_count
from all_companies
where primary_industry is not null
group by primary_industry
