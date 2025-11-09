select
    instrument_id, period_end_date, fund_id, fund_name,
    company_id, company_name, instrument_type,
    initial_investment_date, exit_date, initial_cost,
    cumulative_invested, realized_proceeds, current_fair_value,
    total_value, gross_moic, gross_irr,
    ownership_pct_initial, ownership_pct_current, holding_period_years
from metrics_position_performance
where (fund_id = '${inputs.fund_id.value}' 
       or '${inputs.fund_id.value}' = 'ALL' 
       or '${inputs.fund_id.value}' is null)
  and (instrument_type = '${inputs.instrument_type.value}' 
       or '${inputs.instrument_type.value}' = 'ALL' 
       or '${inputs.instrument_type.value}' is null)
order by gross_moic desc
