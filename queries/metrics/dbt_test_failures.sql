with latest as (
  select command_invocation_id
  from fct_dbt__invocations
  order by run_started_at desc
  limit 1
)
select
  te.node_id,
  dt.name as test_name,
  te.failures,
  te.status,
  te.message
from fct_dbt__test_executions te
left join dim_dbt__tests dt using (node_id)
where te.command_invocation_id = (select command_invocation_id from latest)
  and (te.status != 'success' or coalesce(te.failures,0) > 0)
order by coalesce(te.failures,0) desc nulls last;


