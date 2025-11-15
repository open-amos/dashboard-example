select *
from public.fct_dbt__invocations
union all
select (null::public.fct_dbt__invocations).*
where not exists (select 1 from public.fct_dbt__invocations limit 1);


