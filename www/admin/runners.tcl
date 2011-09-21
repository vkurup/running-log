# /packages/running-log/www/admin/runners.tcl
ad_page_contract {
     List of all runners
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Mon Jan 29 12:04:06 2007
     @cvs-id $Id:$
} {
}

template::list::create \
    -name runners \
    -multirow runners \
    -key runner_id \
    -elements {
        name {
            label "Name"
            link_url_col runner_url
            aggregate count
            aggregate_label "Total"
        }
        creation_date {
            label "Start Date"
            display_eval {[lc_time_fmt $creation_date "%x"]}
        }
        last_workout_date {
            label "Last Workout"
            display_eval {[lc_time_fmt $last_workout_date "%x"]}            
        }
        entries {
            label "Entries"
        }
        shoes {
            label "Shoes"
        }
        courses {
            label "Courses"
        }
    }

db_multirow -extend {name runner_url} runners runners_query {
    select r.runner_id, r.user_id, o.creation_date,
    (select count(1) from rl_workouts w where w.runner_id=r.runner_id) as entries,
    (select count(1) from rl_shoes s where s.runner_id=r.runner_id) as shoes,
    (select count(1) from rl_courses c where c.runner_id=r.runner_id) as courses,
    (select max(workout_date) from rl_workouts w where w.runner_id=r.runner_id) as last_workout_date
    from rl_runners r, acs_objects o
    where r.runner_id=o.object_id
} {
    set name [person::name -person_id $user_id]
    set runner_url [export_vars -base "../log" {runner_id}]
}
