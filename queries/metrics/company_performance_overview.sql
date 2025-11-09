select
    company_id, company_name, period_end_date,
    revenue, ebitda, ebitda_margin,
    cash, total_assets, total_liabilities, equity,
    net_debt, enterprise_value,
    ev_to_ebitda, ev_to_revenue,
    primary_country, primary_industry,
    reporting_currency
from metrics_company_performance
where (company_id = '${inputs.company_id.value}' 
       or '${inputs.company_id.value}' = 'ALL' 
       or '${inputs.company_id.value}' is null)
order by period_end_date desc, company_name
