with latest_model_run as (
  select command_invocation_id
  from fct_dbt__model_executions
  where run_started_at is not null
  order by run_started_at desc
  limit 1
)
select
  name,
  schema,
  total_node_runtime as runtime_seconds,
  status
from fct_dbt__model_executions
where command_invocation_id = (select command_invocation_id from latest_model_run)
order by total_node_runtime desc nulls last
limit 15;



