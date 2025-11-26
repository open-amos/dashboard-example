select
    fund_id,
    'funds/' || fund_id as fund_link,
    'download/funds/' || fund_id as report_link,
    fund_name,
    fund_type,
    fund_nav,
    total_commitments,
    unfunded_commitment,
    total_distributions,
    dpi,
    rvpi,
    tvpi,
    number_of_portfolio_companies,
    number_of_positions,
    -- Credit-specific metrics
    total_exposure,
    principal_outstanding,
    undrawn_commitment,
    interest_income,
    period_end_date
from metrics_fund_performance
where period_end_date = (
    select max(period_end_date)
    from metrics_fund_performance mfp
    where mfp.fund_id = metrics_fund_performance.fund_id
)
order by fund_name
