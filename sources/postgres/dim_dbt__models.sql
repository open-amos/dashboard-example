select *
from public.dim_dbt__models
union all
select (null::public.dim_dbt__models).*
where not exists (select 1 from public.dim_dbt__models limit 1);


