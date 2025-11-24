-- Equity cashflows only
select
    fund_id, 
    fund_name, 
    instrument_id, 
    instrument_name,
    company_id, 
    company_name, 
    cashflow_date, 
    cashflow_type,
    cashflow_amount, 
    direction, 
    signed_amount,
    currency_code, 
    fx_rate
from metrics_returns_cashflows
where 
    cashflow_type in ('INVESTMENT', 'EXIT_PROCEEDS', 'RETURN_OF_CAPITAL', 'DIVIDEND')
    and ('${inputs.fund_id.value}' = 'ALL' or fund_id = '${inputs.fund_id.value}')
    and (
        '${inputs.date_range}' is null 
        or cashflow_date between '${inputs.date_range.start}' and '${inputs.date_range.end}'
    )
order by cashflow_date desc
