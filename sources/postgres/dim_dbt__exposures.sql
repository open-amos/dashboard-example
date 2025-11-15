select *
from public.dim_dbt__exposures
union all
select (null::public.dim_dbt__exposures).*
where not exists (select 1 from public.dim_dbt__exposures limit 1);


