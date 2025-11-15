with latest as (
  select command_invocation_id
  from fct_dbt__invocations
  order by run_started_at desc
  limit 1
)
select
  status,
  count(*) as count
from fct_dbt__model_executions
where command_invocation_id = (select command_invocation_id from latest)
group by status
order by count desc;


