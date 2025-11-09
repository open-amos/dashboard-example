select
    fund_id, fund_name, instrument_id, instrument_name,
    company_id, company_name, cashflow_date, cashflow_type,
    cashflow_amount, direction, signed_amount,
    currency_code, fx_rate
from metrics_returns_cashflows
where '${inputs.fund_id.value}' = 'ALL' or fund_id = '${inputs.fund_id.value}'
order by cashflow_date
