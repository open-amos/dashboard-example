-- Purpose: List all companies with key attributes for the overview table
-- Returns all companies from dim_companies with fund and instrument counts

with all_companies as (
    select
        c.company_id,
        c.name as company_name,
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
),
company_metrics as (
    select
        company_id,
        count(distinct fund_id) as fund_count,
        count(distinct instrument_id) as instrument_count
    from dim_instruments
    where company_id is not null
    group by company_id
)
select
    ac.company_id,
    '/companies/' || ac.company_id as company_link,
    ac.company_name,
    ac.primary_country,
    ac.primary_industry,
    coalesce(cm.fund_count, 0) as funds,
    coalesce(cm.instrument_count, 0) as number_of_instruments
from all_companies ac
left join company_metrics cm on ac.company_id = cm.company_id
order by ac.company_name
