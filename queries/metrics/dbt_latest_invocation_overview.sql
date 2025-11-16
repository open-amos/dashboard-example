-- For each artifact type, find the latest invocation that touched it,
-- then compute counts scoped to that invocation. This avoids showing
-- "no models" just because the very latest invocation was a seed-only run.

with model_latest as (
  select command_invocation_id, run_started_at
  from fct_dbt__model_executions
  where run_started_at is not null
  order by run_started_at desc
  limit 1
),
model_latest_or_default as (
  select * from model_latest
  union all
  select
    cast(null as varchar) as command_invocation_id,
    cast(null as timestamp) as run_started_at
  where not exists (select 1 from model_latest)
),
model_counts as (
  select
    m.run_started_at as models_run_started_at,
    (select count(*) from fct_dbt__model_executions where command_invocation_id = m.command_invocation_id) as models_total,
    (select count(*) from fct_dbt__model_executions where command_invocation_id = m.command_invocation_id and status = 'success') as models_success,
    (select count(*) from fct_dbt__model_executions where command_invocation_id = m.command_invocation_id and status != 'success') as models_error
  from model_latest_or_default m
),

seed_latest as (
  select command_invocation_id, run_started_at
  from fct_dbt__seed_executions
  where run_started_at is not null
  order by run_started_at desc
  limit 1
),
seed_latest_or_default as (
  select * from seed_latest
  union all
  select
    cast(null as varchar) as command_invocation_id,
    cast(null as timestamp) as run_started_at
  where not exists (select 1 from seed_latest)
),
seed_counts as (
  select
    s.run_started_at as seeds_run_started_at,
    (select count(*) from fct_dbt__seed_executions where command_invocation_id = s.command_invocation_id) as seeds_total,
    (select count(*) from fct_dbt__seed_executions where command_invocation_id = s.command_invocation_id and status != 'success') as seeds_error
  from seed_latest_or_default s
),

snapshot_latest as (
  select command_invocation_id, run_started_at
  from fct_dbt__snapshot_executions
  where run_started_at is not null
  order by run_started_at desc
  limit 1
),
snapshot_latest_or_default as (
  select * from snapshot_latest
  union all
  select
    cast(null as varchar) as command_invocation_id,
    cast(null as timestamp) as run_started_at
  where not exists (select 1 from snapshot_latest)
),
snapshot_counts as (
  select
    sp.run_started_at as snapshots_run_started_at,
    (select count(*) from fct_dbt__snapshot_executions where command_invocation_id = sp.command_invocation_id) as snapshots_total,
    (select count(*) from fct_dbt__snapshot_executions where command_invocation_id = sp.command_invocation_id and status != 'success') as snapshots_error
  from snapshot_latest_or_default sp
),

test_latest as (
  select command_invocation_id, run_started_at
  from fct_dbt__test_executions
  where run_started_at is not null
  order by run_started_at desc
  limit 1
),
test_latest_or_default as (
  select * from test_latest
  union all
  select
    cast(null as varchar) as command_invocation_id,
    cast(null as timestamp) as run_started_at
  where not exists (select 1 from test_latest)
),
test_counts as (
  select
    t.run_started_at as tests_run_started_at,
    (select count(*) from fct_dbt__test_executions where command_invocation_id = t.command_invocation_id) as tests_total,
    (select count(*)
       from fct_dbt__test_executions
      where command_invocation_id = t.command_invocation_id
        and (status in ('fail','error','warn') or coalesce(failures,0) > 0)
    ) as tests_failed
  from test_latest_or_default t
)

select
  -- per-artifact latest run timestamps
  mc.models_run_started_at,
  sc.seeds_run_started_at,
  spc.snapshots_run_started_at,
  tc.tests_run_started_at,
  -- human-readable labels for timestamps (null-safe)
  case
    when mc.models_run_started_at is null then 'Never run'
    else strftime(mc.models_run_started_at, '%b %d, %Y, %H:%M') || ' CET'
  end as models_run_started_at_label,
  case
    when sc.seeds_run_started_at is null then 'Never run'
    else strftime(sc.seeds_run_started_at, '%b %d, %Y, %H:%M') || ' CET'
  end as seeds_run_started_at_label,
  case
    when spc.snapshots_run_started_at is null then 'Never run'
    else strftime(spc.snapshots_run_started_at, '%b %d, %Y, %H:%M') || ' CET'
  end as snapshots_run_started_at_label,
  case
    when tc.tests_run_started_at is null then 'Never run'
    else strftime(tc.tests_run_started_at, '%b %d, %Y, %H:%M') || ' CET'
  end as tests_run_started_at_label,
  -- counts for latest relevant runs
  mc.models_total,
  mc.models_success,
  mc.models_error,
  tc.tests_total,
  tc.tests_failed,
  sc.seeds_total,
  sc.seeds_error,
  spc.snapshots_total,
  spc.snapshots_error
from model_counts mc
cross join seed_counts sc
cross join snapshot_counts spc
cross join test_counts tc;



