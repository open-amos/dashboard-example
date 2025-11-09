select
    fund_id, fund_name, period_end_date, fund_nav,
    total_commitments, total_called_capital, unfunded_commitment,
    total_distributions, dpi, rvpi, tvpi, expected_coc,
    number_of_portfolio_companies, number_of_positions,
    lines_of_credit_outstanding, peak_outstanding_credit,
    interest_income, as_of_date
from metrics_fund_performance
where (fund_id = '${inputs.fund_id.value}' 
       or '${inputs.fund_id.value}' = 'ALL' 
       or '${inputs.fund_id.value}' is null)
  and (period_end_date >= '${inputs.start_date.value}' 
       or '${inputs.start_date.value}' is null)
  and (period_end_date <= '${inputs.end_date.value}' 
       or '${inputs.end_date.value}' is null)
order by period_end_date desc
