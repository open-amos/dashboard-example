-- Credit Exposure by Security Rank
-- Shows principal outstanding aggregated by security rank for credit instruments
-- Provides visibility into portfolio risk profile and seniority distribution

select
    security_rank,
    sum(principal_outstanding) as total_principal_outstanding,
    sum(undrawn_commitment) as total_undrawn_commitment,
    sum(principal_outstanding) + sum(undrawn_commitment) as total_exposure,
    count(distinct instrument_id) as number_of_loans,
    count(distinct company_id) as number_of_companies,
    count(distinct fund_id) as number_of_funds,
    -- Calculate percentage of total portfolio
    sum(principal_outstanding) / nullif(
        sum(sum(principal_outstanding)) over (), 0
    ) as pct_of_total_principal,
    -- Average metrics by rank
    avg(all_in_yield) as avg_yield,
    avg(spread_bps) as avg_spread_bps
from public_metrics.metrics_position_performance
where instrument_type = 'CREDIT'
    and security_rank is not null
    and period_end_date = (
        select max(period_end_date) 
        from public_metrics.metrics_position_performance
    )
group by security_rank
order by total_principal_outstanding desc
