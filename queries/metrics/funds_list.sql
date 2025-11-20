select
    fund_id,
    '/funds/' || fund_id as fund_link,
    fund_name,
    fund_nav,
    total_commitments,
    unfunded_commitment,
    total_distributions,
    dpi,
    rvpi,
    tvpi,
    number_of_portfolio_companies,
    period_end_date
from metrics_fund_performance
where period_end_date = (
    select max(period_end_date)
    from metrics_fund_performance mfp
    where mfp.fund_id = metrics_fund_performance.fund_id
)
order by fund_name
