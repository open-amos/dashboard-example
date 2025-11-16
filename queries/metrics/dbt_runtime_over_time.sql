with base as (
  select
    date_trunc('day', run_started_at) as day,
    sum(coalesce(total_node_runtime, 0)) as total_runtime_seconds
  from fct_dbt__model_executions
  where run_started_at is not null
  group by 1
)
select
  strftime(day, '%Y-%m-%d') as day_label,
  total_runtime_seconds
from base
where total_runtime_seconds > 0
order by day asc;


