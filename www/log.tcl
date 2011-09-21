# /packages/running-log/www/log.tcl
ad_page_contract {
    Show one users log
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Thu Sep 18 21:13:50 2003
     @cvs-id $Id: index.tcl,v 1.5 2005/12/12 03:02:15 vinod Exp $
} {
    runner_id:integer
} -properties {
    runner_id:onevalue
}

set user_id [ad_conn user_id]

permission::require_permission -object_id $runner_id -privilege read
set write_p [permission::permission_p -object_id $runner_id -privilege write]
set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]

set name [rl::runner::get_name $runner_id]
set title "${name}'s Log"
set context [list $title]

set start_date [db_string start_date "select coalesce(to_char(min(workout_date),'Month FMDD, YYYY'), to_char(current_date,'Month FMDD, YYYY')) from rl_workouts where runner_id=:runner_id"]
set dist_per_week_total [db_string dist_per_week_total "select coalesce(to_number((7 * sum(distance) / (now()::date + 1 - min(workout_date)::date))::text, '999.9'), 0) from rl_workouts where runner_id=:runner_id"]
set total_miles [db_string total_miles "select coalesce (sum(distance),0) from rl_workouts where runner_id=:runner_id"]

# This is a convoluted query. We want to get weekly mileage. Our weeks
# start on Monday. Luckily Postgresql has a 'week' function which also
# changes on Monday. The problem is that it seems inconsistent at the
# beginning of years. 2005-01-01 is week 53 and 2004-01-01 is week 1
# so I calculate the starting date of each week (week_start) and use that 
# to sort properly. I use the week function of PG to group (year_week)
db_multirow weekly_miles weekly_miles "
      select 
        extract (year from workout_date) || to_char(extract (week from workout_date),'09') as year_week, 
        to_char(min(workout_date)::date - extract(dow from min(workout_date))::int4 + 1, 'DD Mon YYYY') as week_start_pretty,
        min(workout_date)::date - extract(dow from min(workout_date))::int4 + 1 as week_start,
        round(sum(distance)) as distance, 
        max(weight) as weight
      from rl_workouts 
      where runner_id = :runner_id
      group by year_week
      order by week_start desc" 
    
db_multirow shoes shoes "select max(s.name) as name, sum(distance) as distance, max(case when s.deleted_p then 't' else 'f' end) as deleted_p from rl_workouts w, rl_shoes s where w.shoe_id is not null and w.shoe_id = s.shoe_id and w.runner_id=:runner_id group by w.shoe_id order by max(s.start_date) desc"
