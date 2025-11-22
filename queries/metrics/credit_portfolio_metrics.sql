-- Credit Portfolio Metrics
-- Aggregates fund-level performance metrics across all credit funds
-- Filters to fund_type='CREDIT' to show only credit fund metrics
-- Uses the latest period that has credit-specific data populated

with latest_period_with_data as (
    select max(period_end_date) as max_date
    from metrics_fund_performance
    where fund_type = 'CREDIT'
        and principal_outstanding is not null
)

select
    coalesce(sum(total_exposure), 0) as total_exposure,
    coalesce(sum(principal_outstanding), 0) as total_principal_outstanding,
    coalesce(sum(undrawn_commitment), 0) as total_undrawn_commitment,
    sum(total_commitments) as total_commitments,
    sum(total_called_capital) as total_called_capital,
    sum(unfunded_commitment) as unfunded_commitment,
    sum(total_distributions) as total_distributions,
    coalesce(sum(interest_income), 0) as total_interest_income,
    -- Portfolio statistics
    count(distinct fund_id) as number_of_credit_funds,
    sum(number_of_portfolio_companies) as total_portfolio_companies,
    sum(number_of_positions) as total_positions
from metrics_fund_performance
where fund_type = 'CREDIT'
    and period_end_date = (select max_date from latest_period_with_data)
