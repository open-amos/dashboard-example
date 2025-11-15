select *
from public.dim_dbt__sources
union all
select (null::public.dim_dbt__sources).*
where not exists (select 1 from public.dim_dbt__sources limit 1);


