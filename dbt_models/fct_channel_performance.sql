-- Mart model: the single table every dashboard page should query. Computes CAC and
-- ROAS once, here, so no two pages of the dashboard can ever disagree on the number.

with unified as (

    select *
    from {{ ref('stg_unified_spend_revenue') }}

),

aggregated as (

    select
        date,
        channel,
        sum(spend) as total_spend,
        sum(revenue) as total_revenue,
        sum(deals_closed) as total_deals

    from unified
    group by date, channel

)

select
    date,
    channel,
    total_spend,
    total_revenue,
    total_deals,
    safe_divide(total_spend, nullif(total_deals, 0)) as cac,
    safe_divide(total_revenue, nullif(total_spend, 0)) as roas

from aggregated
