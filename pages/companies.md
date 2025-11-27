---
title: Companies
sidebar_position: 2
queries:
  - companies_list: dimensions/companies_list.sql
  - companies_breakdown: metrics/companies_breakdown.sql
  - company_performance_overview: metrics/company_performance_overview.sql
---

<Tabs>
  <Tab label="Portfolio ({companies_list.filter(d => d.number_of_instruments > 0).length})">

    ## Portfolio Companies  

    Active investments across our funds.

    <DataTable 
      data={companies_list.filter(d => d.number_of_instruments > 0)}
      link=company_link
      rows=20
    >
      <Column id=company_name title="Company Name" />
      <Column id=primary_country title="Country" />
      <Column id=primary_industry title="Industry" />
      <Column id=funds title="Funds" fmt="num0" />
      <Column id=number_of_instruments title="Instruments" fmt="num0" />
    </DataTable>

  </Tab>
  <Tab label="Pipeline ({companies_list.filter(d => d.number_of_instruments === 0).length})">

    ## Pipeline Companies  

    Companies being tracked in CRM without active investments.

    <DataTable 
      data={companies_list.filter(d => d.number_of_instruments === 0)}
      link=company_link
      rows=20
    >
      <Column id=company_name title="Company Name" />
      <Column id=primary_country title="Country" />
      <Column id=primary_industry title="Industry" />
    </DataTable>

  </Tab>
  <Tab label="All ({companies_list.length})">

    ## All Companies 

    Complete view of portfolio and pipeline companies.

    <DataTable 
      data={companies_list}
      link=company_link
      rows=20
    >
      <Column id=company_name title="Company Name" />
      <Column id=primary_country title="Country" />
      <Column id=primary_industry title="Industry" />
      <Column id=funds title="Funds" fmt="num0" />
      <Column id=number_of_instruments title="Instruments" fmt="num0" />
    </DataTable>

  </Tab>
</Tabs>

<div class="section-highlight">

## Portfolio Company Composition

<Grid cols=2>

<div class="section-highlight-chart">
  <ECharts config={{
    title: { text: 'Portfolio Companies by Country' },
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    series: [{
      type: 'pie',
      radius: '70%',
      data: (companies_breakdown || [])
        .filter(d => d.dimension_type === 'country' && d.is_portfolio)
        .map(d => ({ name: d.dimension, value: d.company_count }))
    }]
  }} />
</div>

<div class="section-highlight-chart">
  <ECharts config={{
    title: { text: 'Portfolio Companies by Industry' },
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    series: [{
      type: 'pie',
      radius: '70%',
      data: (companies_breakdown || [])
        .filter(d => d.dimension_type === 'industry' && d.is_portfolio)
        .map(d => ({ name: d.dimension, value: d.company_count }))
    }]
  }} />
</div>

</Grid>

<div class="section-highlight-chart">
  <BarChart 
    data={company_performance_overview}
    x=company_name
    y=revenue
    yFmt="usd0"
    title="Revenue by Company"
    swapXY=true
  />
</div>

</div>