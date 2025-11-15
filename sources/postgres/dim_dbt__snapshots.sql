select *
from public.dim_dbt__snapshots
union all
select (null::public.dim_dbt__snapshots).*
where not exists (select 1 from public.dim_dbt__snapshots limit 1);


