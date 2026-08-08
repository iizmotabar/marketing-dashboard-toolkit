-- Blends spend from Google Ads and Meta with revenue from the CRM into a single
-- channel and date level table. This is the join that normally lives in someone's
-- head instead of the warehouse, which is why every dashboard shows a different number.

with google_spend as (
  select
    date,
    'google_ads' as channel,
    campaign_name,
    sum(cost_micros) / 1e6 as spend
  from `project.ads.google_ads_campaign_stats`
  group by date, campaign_name
),

meta_spend as (
  select
    date_start as date,
    'meta_ads' as channel,
    campaign_name,
    sum(spend) as spend
  from `project.ads.meta_campaign_insights`
  group by date_start, campaign_name
),

all_spend as (
  select * from google_spend
  union all
  select * from meta_spend
),

crm_revenue as (
  select
    date(closed_at) as date,
    utm_source_channel as channel,
    utm_campaign as campaign_name,
    sum(deal_value) as revenue,
    count(*) as deals_closed
  from `project.crm.closed_deals`
  where utm_campaign is not null
  group by date, utm_source_channel, utm_campaign
)

select
  coalesce(s.date, r.date) as date,
  coalesce(s.channel, r.channel) as channel,
  coalesce(s.campaign_name, r.campaign_name) as campaign_name,
  coalesce(s.spend, 0) as spend,
  coalesce(r.revenue, 0) as revenue,
  coalesce(r.deals_closed, 0) as deals_closed,
  safe_divide(coalesce(r.revenue, 0), nullif(s.spend, 0)) as roas
from all_spend s
full outer join crm_revenue r
  on s.date = r.date
  and s.channel = r.channel
  and s.campaign_name = r.campaign_name
order by date desc, spend desc;
