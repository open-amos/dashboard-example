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
    mpp.initial_investment_date,
    mpp.exit_date,
    mpp.cumulative_invested,
    mpp.current_fair_value,
    mpp.total_value,
    mpp.gross_moic,
    mpp.gross_irr,
    mpp.ownership_pct_current,
    mpp.holding_period_years
from metrics_position_performance mpp
inner join latest_instrument_snapshots lis
    on mpp.instrument_id = lis.instrument_id
    and mpp.period_end_date = lis.latest_period_end_date
where mpp.fund_id = '${params.id}'
order by mpp.gross_moic desc
