with inv as (
  select
    command_invocation_id,
    date_trunc('day', run_started_at) as day
  from fct_dbt__model_executions
  where run_started_at is not null
  group by 1,2
),
fail_models as (
  select command_invocation_id, count(*) as failed_models
  from fct_dbt__model_executions
  where status != 'success'
  group by 1
),
fail_tests as (
  select command_invocation_id, count(*) as failed_tests
  from fct_dbt__test_executions
  where status != 'success' or coalesce(failures,0) > 0
  group by 1
),
base as (
  select
    i.day,
    count(distinct i.command_invocation_id) as runs,
    sum(case when coalesce(fm.failed_models,0) + coalesce(ft.failed_tests,0) = 0 then 1 else 0 end) as successful_runs,
    sum(case when coalesce(fm.failed_models,0) + coalesce(ft.failed_tests,0) > 0 then 1 else 0 end) as failed_runs
  from inv i
  left join fail_models fm using (command_invocation_id)
  left join fail_tests ft using (command_invocation_id)
  group by 1
)
select
  strftime(day, '%Y-%m-%d') as day_label,
  runs,
  successful_runs,
  failed_runs
from base
where runs > 0
order by day asc;


