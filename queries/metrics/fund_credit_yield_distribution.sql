-- Credit yield distribution for a specific fund
select
    instrument_id,
    instrument_name,
    company_name,
    all_in_yield,
    spread_bps,
    interest_index,
    principal_outstanding,
    security_rank
from metrics_position_performance
where fund_id = '${params.id}'
  and instrument_type = 'CREDIT'
  and period_end_date = (
      select max(period_end_date) 
      from metrics_position_performance 
      where fund_id = '${params.id}'
  )
order by all_in_yield desc
