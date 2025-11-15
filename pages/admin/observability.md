---
title: Data pipelines
queries:
  - latest: metrics/dbt_latest_invocation_overview.sql
  - runs_over_time: metrics/dbt_runs_over_time.sql
  - model_status_counts: metrics/dbt_model_status_counts.sql
  - top_model_durations: metrics/dbt_top_model_durations.sql
  - test_failures: metrics/dbt_test_failures.sql
  - exposures_count: metrics/dbt_exposures_count.sql
  - sources_count: metrics/dbt_sources_count.sql
  - models_by_materialization: metrics/dbt_models_by_materialization.sql
  - runtime_over_time: metrics/dbt_runtime_over_time.sql
---

<Alert status="info">
  This dashboard summarizes dbt runs from dbt_artifacts models materialized under the <code>public</code> schema.
  It shows recent run health, failures, and performance characteristics.
  Latest run: {latest?.[0]?.run_started_at}
</Alert>

<Grid cols=4>
  <BigValue title="Models (Latest Run)" value={latest?.[0]?.models_total} />
  <BigValue title="Model Errors (Latest Run)" value={latest?.[0]?.models_error} />
  <BigValue title="Test Failures (Latest Run)" value={latest?.[0]?.tests_failed} />
  <BigValue title="Exposures" value={exposures_count?.[0]?.exposures} />
</Grid>

<Grid cols=4>
  <BigValue title="Seeds (Latest Run)" value={latest?.[0]?.seeds_total} />
  <BigValue title="Seed Errors (Latest Run)" value={latest?.[0]?.seeds_error} />
  <BigValue title="Snapshots (Latest Run)" value={latest?.[0]?.snapshots_total} />
  <BigValue title="Snapshot Errors (Latest Run)" value={latest?.[0]?.snapshots_error} />
</Grid>

<hr class="my-4" />

### Run Activity

<Grid cols=2>
  <AreaChart
    data={runs_over_time}
    title="Runs per Day"
    x=day
    y=runs
  />

  <ECharts config={
    {
      title: { text: 'Run Outcomes per Day' },
      tooltip: { trigger: 'axis' },
      legend: { data: ['Successful', 'Failed'] },
      xAxis: {
        type: 'category',
        data: runs_over_time?.map(d => d.day) || []
      },
      yAxis: { type: 'value' },
      series: [
        {
          name: 'Successful',
          type: 'bar',
          stack: 'total',
          data: runs_over_time?.map(d => d.successful_runs) || []
        },
        {
          name: 'Failed',
          type: 'bar',
          stack: 'total',
          data: runs_over_time?.map(d => d.failed_runs) || []
        }
      ]
    }
  } />
</Grid>

<AreaChart
  data={runtime_over_time}
  title="Total Model Runtime per Day (seconds)"
  x=day
  y=total_runtime_seconds
/>

<hr class="my-4" />

### Latest Run Details

<Grid cols=2>
  <BarChart
    data={model_status_counts}
    title="Model Status Counts (Latest Run)"
    x=status
    y=count
  />

  <ECharts config={
    {
      title: { text: 'Models by Materialization' },
      tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
      series: [
        {
          type: 'pie',
          radius: '70%',
          data: (models_by_materialization || []).map(d => ({ name: d.materialization, value: d.num_models }))
        }
      ]
    }
  } />
</Grid>

<hr class="my-4" />

### Slowest Models (Latest Run)
<DataTable data={top_model_durations} />

### Failing Tests (Latest Run)
<DataTable data={test_failures} />


