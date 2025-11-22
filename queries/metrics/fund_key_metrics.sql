select
    fund_id,
    fund_name,
    fund_type,
    period_end_date,
    fund_nav,
    total_commitments,
    total_called_capital,
    unfunded_commitment,
    total_distributions,
    dpi,
    rvpi,
    tvpi,
    expected_coc,
    number_of_portfolio_companies,
    number_of_positions,
    as_of_date,
    -- Credit-specific metrics
    total_exposure,
    principal_outstanding,
    undrawn_commitment,
    interest_income
from metrics_fund_performance
where fund_id = '${params.id}'
order by period_end_date desc
limit 1
