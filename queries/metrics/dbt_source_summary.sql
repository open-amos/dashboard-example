with base as (
  select
    node_id,
    source_name,
    name,
    -- Capitalize first letter of source_name
    case
      when source_name is null or source_name = '' then null
      else upper(substr(source_name, 1, 1)) || lower(substr(source_name, 2))
    end as source_display,
    -- Strip leading "<source_name>_" from name when present
    case
      when name like source_name || '_%' then substring(name from length(source_name) + 2)
      else name
    end as dataset_raw,
    database,
    schema,
    identifier,
    loaded_at_field,
    freshness
  from dim_dbt__sources
),
final as (
  select
    node_id,
    source_name,
    name,
    database,
    schema,
    identifier,
    loaded_at_field,
    freshness,
    source_display,
    -- Replace underscores with spaces and simple-capitalize first letter
    case
      when dataset_raw is null or dataset_raw = '' then null
      else
        upper(substr(replace(dataset_raw, '_', ' '), 1, 1)) ||
        lower(substr(replace(dataset_raw, '_', ' '), 2))
    end as dataset_display
  from base
)
select *
from final
order by source_display, dataset_display;



