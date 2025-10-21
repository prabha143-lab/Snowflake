-- macros/add_numbers.sql

{% macro add_numbers(a, b) %}
  {{ a + b }}
{% endmacro %}


**********************************************


-- models/add_two_numbers.sql

{#-- Get values from CLI using var() --#}
{% set a = var('a', 0) %}
{% set b = var('b', 0) %}


SELECT {{ add_numbers(a, b) }} AS total_sum

*********************************************

dbt run --select add_two_numbers12 --vars '{a: 1000, b: 1125}'


***********Please execute this SELECT statement in Snowflake ***************************

SELECT * FROM MYSNOW.dbt_pk.add_two_numbers12

TOTAL_SUM
2125
