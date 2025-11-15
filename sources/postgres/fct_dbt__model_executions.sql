select *
from public.fct_dbt__model_executions
union all
select (null::public.fct_dbt__model_executions).*
where not exists (select 1 from public.fct_dbt__model_executions limit 1);


