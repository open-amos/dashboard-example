-- All portfolio positions for scatter plot analysis
with latest_instrument_snapshots as (
    select
        instrument_id,
        max(period_end_date) as latest_period_end_date
    from metrics_position_performance
    group by instrument_id
)

select 
    mpp.instrument_id,
    mpp.instrument_name,
    mpp.company_name,
    mpp.fund_name,
    mpp.instrument_type,
    mpp.cumulative_invested,
    mpp.current_fair_value,
    mpp.total_value,
    mpp.gross_moic,
    mpp.gross_irr,
    mpp.holding_period_years
from metrics_position_performance mpp
inner join latest_instrument_snapshots lis
    on mpp.instrument_id = lis.instrument_id
    and mpp.period_end_date = lis.latest_period_end_date
where mpp.cumulative_invested > 0
order by mpp.gross_moic desc
