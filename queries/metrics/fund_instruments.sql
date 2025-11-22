-- Get the latest snapshot for each instrument in the fund
with latest_instrument_snapshots as (
    select
        instrument_id,
        max(period_end_date) as latest_period_end_date
    from metrics_position_performance
    where fund_id = '${params.id}'
    group by instrument_id
)

select
    mpp.instrument_id,
    mpp.instrument_name,
    mpp.company_id,
    mpp.company_name,
    mpp.instrument_type,
    mpp.fund_type,
    mpp.initial_investment_date,
    mpp.exit_date,
    -- Equity-specific fields
    mpp.cumulative_invested,
    mpp.fair_value,
    mpp.cumulative_distributions,
    coalesce(mpp.cumulative_distributions, 0) + coalesce(mpp.fair_value, 0) as total_value,
    mpp.moic,
    mpp.equity_irr,
    mpp.ownership_pct_current,
    mpp.holding_period_years,
    -- Credit-specific fields
    mpp.principal_outstanding,
    mpp.undrawn_commitment,
    mpp.accrued_interest,
    mpp.commitment_amount,
    mpp.spread_bps,
    mpp.interest_index,
    mpp.all_in_yield,
    mpp.maturity_date,
    mpp.maturity_year,
    mpp.security_rank,
    mpp.days_to_maturity
from metrics_position_performance mpp
inner join latest_instrument_snapshots lis
    on mpp.instrument_id = lis.instrument_id
    and mpp.period_end_date = lis.latest_period_end_date
where mpp.fund_id = '${params.id}'
order by 
    case 
        when mpp.instrument_type = 'EQUITY' then mpp.moic
        when mpp.instrument_type = 'CREDIT' then mpp.principal_outstanding
    end desc nulls last
