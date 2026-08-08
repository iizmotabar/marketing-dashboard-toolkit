# Dashboard Spec

The page by page structure I build on top of `fct_channel_performance`.

## Page 1: Overview

* Scorecards: total spend, total revenue, blended ROAS, blended CAC, all with period over period comparison
* Time series: spend vs revenue by day
* Channel breakdown table: spend, revenue, CAC, ROAS per channel, sortable

## Page 2: Channel Deep Dive

* Filter control by channel
* Campaign level table within the selected channel
* Trend line for CAC and ROAS over the selected date range, to catch a channel drifting before it becomes a problem

## Page 3: Funnel

* Sessions to leads to closed deals, by channel
* Conversion rate at each stage, so a channel with cheap traffic but a weak funnel doesn't get mistaken for a winning channel

## Filters available on every page

* Date range
* Channel
* Campaign

## Refresh cadence

Connected directly to `fct_channel_performance` in BigQuery, which refreshes daily through the pipeline in `automated-reporting-pipeline`. Looker Studio's own cache is set to refresh every 12 hours.
