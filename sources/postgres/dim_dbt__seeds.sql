select *
from public.dim_dbt__seeds
union all
select (null::public.dim_dbt__seeds).*
where not exists (select 1 from public.dim_dbt__seeds limit 1);


