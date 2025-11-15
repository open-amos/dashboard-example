select *
from public.dim_dbt__current_models
union all
select (null::public.dim_dbt__current_models).*
where not exists (select 1 from public.dim_dbt__current_models limit 1);


