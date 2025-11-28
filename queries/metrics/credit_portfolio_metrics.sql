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
    -- Capital deployment metrics
    sum(total_commitments) as lp_commitments,
    sum(total_called_capital) as called_capital,
    coalesce(sum(total_exposure), 0) as facility_commitments,
    coalesce(sum(principal_outstanding), 0) as principal_outstanding,
    coalesce(sum(undrawn_commitment), 0) as undrawn_facilities,
    
    -- Calculated deployment metrics
    sum(total_called_capital) - coalesce(sum(total_exposure), 0) as cash_and_reserves,
    sum(unfunded_commitment) as unfunded_lp_commitment,
    
    -- Deployment rates
    case 
        when sum(total_commitments) > 0 
        then coalesce(sum(total_exposure), 0) / sum(total_commitments) 
        else 0 
    end as facility_deployment_rate,
    case 
        when coalesce(sum(total_exposure), 0) > 0 
        then coalesce(sum(principal_outstanding), 0) / coalesce(sum(total_exposure), 0)
        else 0 
    end as facility_utilization_rate,
    
    -- Legacy fields (for backward compatibility)
    sum(total_commitments) as total_commitments,
    coalesce(sum(total_exposure), 0) as total_exposure,
    coalesce(sum(principal_outstanding), 0) as total_principal_outstanding,
    coalesce(sum(undrawn_commitment), 0) as total_undrawn_commitment,
    
    -- Other metrics
    sum(total_distributions) as total_distributions,
    coalesce(sum(interest_income), 0) as total_interest_income,
    
    -- Portfolio statistics
    count(distinct fund_id) as number_of_credit_funds,
    sum(number_of_portfolio_companies) as total_portfolio_companies,
    sum(number_of_positions) as total_positions
from metrics_fund_performance
where fund_type = 'CREDIT'
    and period_end_date = (select max_date from latest_period_with_data)
