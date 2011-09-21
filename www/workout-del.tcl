# /packages/running-log/www/workout-del.tcl
ad_page_contract {
     Delete one or more workouts.
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Sun Jan 25 15:01:35 2004
     @cvs-id $Id: workout-del.tcl,v 1.2 2004/02/16 21:19:29 vinod Exp $
} {
    workout_id:integer,multiple
    {confirm_p:boolean 0}
}

if { !$confirm_p } {
    set num_entries [llength $workout_id]

    if { $num_entries == 0 } {
        ad_returnredirect .
        return
    }

    set page_title "Delete [ad_decode $num_entries 1 "Workout" "Workouts"]"
    set context [list $page_title]
    set yes_url "workout-del?[export_vars { workout_id:multiple { confirm_p 1 } }]"
    set no_url "."

    return
}

foreach workout_id $workout_id {
    permission::require_permission -object_id $workout_id -privilege write
    rl::workout::del $workout_id
}
    
ad_returnredirect .
ad_script_abort
