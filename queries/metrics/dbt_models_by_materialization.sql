select
  materialization,
  count(*) as num_models
from dim_dbt__current_models
where materialization is not null
group by materialization
order by num_models desc;


