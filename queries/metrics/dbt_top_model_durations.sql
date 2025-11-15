with latest as (
  select command_invocation_id
  from fct_dbt__invocations
  order by run_started_at desc
  limit 1
)
select
  name,
  schema,
  total_node_runtime as runtime_seconds,
  status
from fct_dbt__model_executions
where command_invocation_id = (select command_invocation_id from latest)
order by total_node_runtime desc nulls last
limit 15;


