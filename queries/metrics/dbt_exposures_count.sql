select count(*) as exposures
from dim_dbt__exposures
where exposure_execution_id is not null;


