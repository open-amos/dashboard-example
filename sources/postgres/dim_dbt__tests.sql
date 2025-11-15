select *
from public.dim_dbt__tests
union all
select (null::public.dim_dbt__tests).*
where not exists (select 1 from public.dim_dbt__tests limit 1);


