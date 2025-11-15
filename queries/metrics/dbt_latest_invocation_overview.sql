with latest as (
  select command_invocation_id, run_started_at
  from fct_dbt__invocations
  order by run_started_at desc
  limit 1
)
select
  l.command_invocation_id,
  l.run_started_at,
  (select count(*) from fct_dbt__model_executions where command_invocation_id = l.command_invocation_id) as models_total,
  (select count(*) from fct_dbt__model_executions where command_invocation_id = l.command_invocation_id and status = 'success') as models_success,
  (select count(*) from fct_dbt__model_executions where command_invocation_id = l.command_invocation_id and status != 'success') as models_error,
  (select count(*) from fct_dbt__test_executions where command_invocation_id = l.command_invocation_id) as tests_total,
  (select count(*) from fct_dbt__test_executions where command_invocation_id = l.command_invocation_id and (status != 'success' or coalesce(failures,0) > 0)) as tests_failed,
  (select count(*) from fct_dbt__seed_executions where command_invocation_id = l.command_invocation_id) as seeds_total,
  (select count(*) from fct_dbt__seed_executions where command_invocation_id = l.command_invocation_id and status != 'success') as seeds_error,
  (select count(*) from fct_dbt__snapshot_executions where command_invocation_id = l.command_invocation_id) as snapshots_total,
  (select count(*) from fct_dbt__snapshot_executions where command_invocation_id = l.command_invocation_id and status != 'success') as snapshots_error
from latest l;


