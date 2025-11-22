-- Credit maturity ladder for a specific fund
select
    maturity_year::integer::text as maturity_year,
    sum(principal_outstanding) as principal_maturing,
    count(distinct instrument_id) as number_of_loans
from metrics_position_performance
where fund_id = '${params.id}'
  and instrument_type = 'CREDIT'
  and maturity_year is not null
  and period_end_date = (
      select max(period_end_date) 
      from metrics_position_performance 
      where fund_id = '${params.id}'
  )
group by maturity_year::integer
order by maturity_year::integer
