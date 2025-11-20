select * 
from metrics_portfolio_overview 
where period_end_date = (
  select max(period_end_date) 
  from metrics_portfolio_overview
)
