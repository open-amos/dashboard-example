select
    fund_id, fund_name, instrument_id, instrument_name,
    company_id, company_name, cashflow_date, cashflow_type,
    cashflow_amount, direction, signed_amount,
    currency_code, fx_rate
from metrics_returns_cashflows
where (fund_id = '${inputs.fund_id.value}' 
       or '${inputs.fund_id.value}' = 'ALL' 
       or '${inputs.fund_id.value}' is null)
  and (cashflow_date >= '${inputs.start_date.value}' 
       or '${inputs.start_date.value}' is null)
  and (cashflow_date <= '${inputs.end_date.value}' 
       or '${inputs.end_date.value}' is null)
order by cashflow_date
