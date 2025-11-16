---
title: Data Management
queries:
  - latest: metrics/dbt_latest_invocation_overview.sql
  - source_summary: metrics/dbt_source_summary.sql
  - runs_over_time: metrics/dbt_runs_over_time.sql
  - model_status_counts: metrics/dbt_model_status_counts.sql
  - top_model_durations: metrics/dbt_top_model_durations.sql
  - test_failures: metrics/dbt_test_failures.sql
  - test_passes: metrics/dbt_test_passes.sql
  - exposures_count: metrics/dbt_exposures_count.sql
  - sources_count: metrics/dbt_sources_count.sql
  - models_by_materialization: metrics/dbt_models_by_materialization.sql
  - runtime_over_time: metrics/dbt_runtime_over_time.sql
---

<Alert status="info">
  This dashboard shows recent pipeline run health, failures, and performance characteristics.
</Alert>

<Grid cols=4>
  <BigValue 
    data={latest}
    value=models_run_started_at_label
    title="Latest model run"
  />
  <BigValue 
    data={latest}
    value=seeds_run_started_at_label
    title="Latest seed run"
  />
  <BigValue 
    data={latest}
    value=snapshots_run_started_at_label
    title="Latest snapshot run"
  />
  <BigValue 
    data={latest}
    value=tests_run_started_at_label
    title="Latest test run"
  />
</Grid>

### Sources feeding this environment

<DataTable data={source_summary}>
  <Column id=source_display title="Source" />
  <Column id=dataset_display title="Dataset" />
  <Column id=loader title="Loader" />
  <Column id=schema title="Schema" />
  <Column id=identifier title="Table / Identifier" />
</DataTable>

<hr class="my-4" />

<Grid cols=4>
  <BigValue 
    data={latest}
    value=models_total
    title="Models (Latest Run)"
  />
  <BigValue 
    data={latest}
    value=models_error
    title="Model Errors (Latest Run)"
  />
  <BigValue 
    data={latest}
    value=tests_failed
    title="Test Failures (Latest Run)"
  />
  <BigValue 
    data={exposures_count}
    value=exposures
    title="Exposures"
  />
</Grid>

<Grid cols=4>
  <BigValue 
    data={latest}
    value=seeds_total
    title="Seeds (Latest Run)"
  />
  <BigValue 
    data={latest}
    value=seeds_error
    title="Seed Errors (Latest Run)"
  />
  <BigValue 
    data={latest}
    value=snapshots_total
    title="Snapshots (Latest Run)"
  />
  <BigValue 
    data={latest}
    value=snapshots_error
    title="Snapshot Errors (Latest Run)"
  />
</Grid>

<hr class="my-4" />

### Run Activity
<AreaChart
  data={runs_over_time}
  title="Runs per Day"
  x=day_label
  y=runs
/>

<ECharts config={
  {
    title: { text: 'Run Outcomes per Day' },
    tooltip: { trigger: 'axis' },
    legend: { data: ['Successful', 'Failed'] },
    xAxis: {
      type: 'category',
      data: runs_over_time?.map(d => d.day_label) || []
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

<AreaChart
  data={runtime_over_time}
  title="Total Model Runtime per Day (seconds)"
  x=day_label
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
{#if test_failures.length}
  <DataTable data={test_failures} />
{:else}
  No failing tests on the latest run.
{/if}

### Passing Tests (Latest Run)
{#if test_passes.length}
  <DataTable data={test_passes} />
{:else}
  No passing tests found for the latest test run.
{/if}


