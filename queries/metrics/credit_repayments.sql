select
  cashflow_date,
  sum(case when cashflow_type = 'DRAW' then cashflow_amount else 0 end) as draws,
  sum(case when cashflow_type = 'PRINCIPAL' then cashflow_amount else 0 end) as principal_repayments,
  sum(case when cashflow_type = 'PREPAYMENT' then cashflow_amount else 0 end) as prepayments,
  sum(case when cashflow_type = 'INTEREST' then cashflow_amount else 0 end) as interest_income
from ${credit_cashflows}
group by cashflow_date
order by cashflow_date