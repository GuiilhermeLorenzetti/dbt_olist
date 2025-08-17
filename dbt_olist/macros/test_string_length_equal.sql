{% test string_length_equal(model, column_name, length) %}

with validation as (
    select
        {{ column_name }} as value_field,
        length({{ column_name }}) as actual_length
    from {{ model }}
),

validation_errors as (
    select
        value_field,
        actual_length
    from validation
    where actual_length != {{ length }}
)

select *
from validation_errors

{% endtest %}
