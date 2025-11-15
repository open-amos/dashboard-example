select *
from public.fct_dbt__snapshot_executions
union all
select (null::public.fct_dbt__snapshot_executions).*
where not exists (select 1 from public.fct_dbt__snapshot_executions limit 1);


