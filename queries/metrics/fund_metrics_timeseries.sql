select
    period_end_date,
    fund_type,
    fund_nav,
    tvpi,
    dpi,
    rvpi,
    total_distributions,
    total_called_capital,
    -- Credit-specific metrics
    total_exposure,
    principal_outstanding,
    undrawn_commitment,
    interest_income
from metrics_fund_performance
where fund_id = '${params.id}'
order by period_end_date asc
