-- Aggregate fund performance metrics across all funds
-- Returns a single row with totals for the latest period

with latest_fund_metrics as (
    select
        fund_id,
        fund_name,
        period_end_date,
        total_commitments,
        unfunded_commitment,
        total_distributions,
        row_number() over (partition by fund_id order by period_end_date desc) as rn
    from metrics_fund_performance
)
select
    sum(total_commitments) as total_commitments,
    sum(unfunded_commitment) as unfunded_commitment,
    sum(total_distributions) as total_distributions
from latest_fund_metrics
where rn = 1
