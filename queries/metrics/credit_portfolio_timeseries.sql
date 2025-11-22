-- Credit Portfolio Time Series
-- Shows principal outstanding, total exposure, and cashflows over time for credit funds
-- Filters to fund_type='CREDIT' to show only credit fund trends

select
    period_end_date,
    sum(principal_outstanding) as total_principal_outstanding,
    sum(total_exposure) as total_exposure,
    sum(undrawn_commitment) as total_undrawn_commitment,
    sum(interest_income) as total_interest_income,
    sum(period_net_flows) as net_cash_contributions_period,
    sum(total_commitments) as total_commitments,
    sum(total_called_capital) as total_called_capital
from metrics_fund_performance
where fund_type = 'CREDIT'
group by period_end_date
order by period_end_date
