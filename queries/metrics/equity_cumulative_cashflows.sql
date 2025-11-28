select
    cashflow_date,
    sum(case when direction = 'outflow' then cashflow_amount else 0 end) 
      over (order by cashflow_date rows between unbounded preceding and current row) as cumulative_contributions,
    sum(case when direction = 'inflow' then cashflow_amount else 0 end) 
      over (order by cashflow_date rows between unbounded preceding and current row) as cumulative_distributions
  from ${equity_cashflows}
  order by cashflow_date