# /packages/running-log/www/workouts.tcl
ad_page_contract {
     List workouts
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Sun Jan 25 02:36:44 2004
     @cvs-id $Id: workouts.tcl,v 1.2 2004/02/16 21:19:29 vinod Exp $
} {
    runner_id:integer
    orderby:optional
}

array set prefs [rl::runner::runner_prefs $runner_id]
set du $prefs(distance_units)
set wu $prefs(weight_units)

template::list::create \
    -name workouts \
    -multirow workouts \
    -key workout_id \
    -elements {
        workout_date {
            label "Date"
            link_url_col edit_url
            display_eval {[lc_time_fmt $workout_date "%a %x"]}
            aggregate count
            aggregate_label "Count"
        }
        type {
            label "Type"
        }
        distance {
            label "Distance ($du)"
            aggregate sum
            aggregate_label "Total"
        }
        time {
            label "Time"
            display_eval {[rl::util::fmt_time $time]}
        }
        pace {
            label "Pace"
        }
        comments {
            label "Comments"
            display_col comments;noquote
        }
    } \
    -actions [list "Add a workout" [export_vars -base workout-ae {runner_id}] "Add a new workout"] \
    -bulk_actions {
        "Delete checked workouts" workout-del "Delete checked items"
    } -orderby {
        workout_date {
            orderby workout_date
        }
        default_value workout_date,desc
    } -filters {
        runner_id {}
    }


db_multirow -extend {edit_url pace} workouts workouts_query {} {
    set edit_url [export_vars -base "workout-ae" {runner_id workout_id}]
    if {$distance > 0 } {
        set pace [expr $time_seconds / $distance]
        set pace_min [expr int($pace / 60)]
        set pace_sec [expr int($pace - ($pace_min * 60))]

        set pace [format {%2d:%02d} $pace_min $pace_sec]
    } else {
        set pace "N/A"
    }
}
