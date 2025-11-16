with latest_test as (
  select command_invocation_id, run_started_at
  from fct_dbt__test_executions
  where run_started_at is not null
  order by run_started_at desc
  limit 1
)
select
  dt.name as test_name,
  te.failures,
  te.status,
  te.message
from fct_dbt__test_executions te
left join dim_dbt__tests dt using (node_id)
where te.command_invocation_id = (select command_invocation_id from latest_test)
  and (te.status = 'pass' and coalesce(te.failures,0) = 0)
order by dt.name;


