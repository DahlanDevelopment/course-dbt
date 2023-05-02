{% macro conversion_rate(input_table, groupby_col,numerator_col,denom_col ) %}
select {{groupby_col}}, sum({{numerator_col}}) as numerator, sum({{denom_col}}) as denom, numerator/denom as conversion from {{input_table}} group by {{groupby_col}}
{% endmacro %}