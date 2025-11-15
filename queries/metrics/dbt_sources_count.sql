select count(*) as sources
from dim_dbt__sources
where source_execution_id is not null;


