select
  date_trunc('day', run_started_at) as day,
  sum(coalesce(total_node_runtime, 0)) as total_runtime_seconds
from fct_dbt__model_executions
where run_started_at is not null
group by 1
order by 1 asc;


