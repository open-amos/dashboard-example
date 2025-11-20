with latest as (
  select max(period_end_date) as max_date 
  from metrics_position_performance
)
select 
  mp.company_id,
  '/companies/' || mp.company_id as company_link,
  mp.company_name,
  mp.fund_name,
  mp.instrument_name,
  mp.current_fair_value,
  mp.cumulative_invested,
  (mp.current_fair_value + coalesce(mp.realized_proceeds, 0) - mp.cumulative_invested) as total_return,
  mp.gross_moic as moic,
  mp.gross_irr as irr
from metrics_position_performance mp
join latest on mp.period_end_date = latest.max_date
where mp.cumulative_invested > 0
order by total_return asc nulls last
limit 10
