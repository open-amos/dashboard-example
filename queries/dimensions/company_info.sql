-- Get company info from dim_companies with industry and country from bridge tables
select
    c.company_id,
    c.name as company_name,
    case
        when lower(coalesce(c.website, '')) like 'http%' then c.website
        when coalesce(c.website, '') <> '' then 'https://' || c.website
        else null
    end as website,
    c.description,
    co.name as primary_country,
    i.name as primary_industry
from dim_companies c
left join (
    select company_id, country_code
    from br_company_countries
    where primary_flag = true
    limit 1
) bcc on c.company_id = bcc.company_id
left join dim_countries co on bcc.country_code = co.country_iso2_code
left join (
    select company_id, industry_id
    from br_company_industries
    where primary_flag = true
    limit 1
) bci on c.company_id = bci.company_id
left join dim_industries i on bci.industry_id = i.industry_id
where c.company_id = '${params.id}'
