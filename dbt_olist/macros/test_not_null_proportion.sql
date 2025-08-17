{% test not_null_proportion(model, column_name, at_least) %}

with validation as (
    select
        count(*) as total_rows,
        count({{ column_name }}) as non_null_rows
    from {{ model }}
),

validation_errors as (
    select
        total_rows,
        non_null_rows,
        round(non_null_rows * 1.0 / total_rows, 4) as proportion
    from validation
    where round(non_null_rows * 1.0 / total_rows, 4) < {{ at_least }}
)

select *
from validation_errors

{% endtest %}
