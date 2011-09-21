# /packages/running-log/www/workout-ae.tcl
ad_page_contract {
     Add or edit a workout
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Thu Sep 18 21:16:26 2003
     @cvs-id $Id: workout-ae.tcl,v 1.3 2005/12/12 03:03:00 vinod Exp $
} {
    runner_id:integer
    workout_id:integer,optional
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set ip_addr [ad_conn peeraddr]

permission::require_permission -object_id $runner_id -privilege write

array set prefs [rl::runner::runner_prefs $runner_id]
set du $prefs(distance_units)
set wu $prefs(weight_units)

set shoe_options [rl::workout::shoe_options $runner_id]
set course_options [rl::workout::course_options $runner_id]
set type_options [rl::workout::type_options $runner_id]

if { [info exists workout_id] } {
    # If we are editing an old workout, show retired shoes and courses
    set shoe_options [rl::workout::shoe_options -all $runner_id]
    set course_options [rl::workout::course_options -all $runner_id]
}

ad_form -name create_workout -form {
    workout_id:key
    {workout_date:date,to_sql(sql_date),to_html(sql_date) 
        {format "MONTH DD YYYY"}
        {help}}
    {type_id:integer(select),optional
        {label "Workout Type"}
        {options $type_options
        }}
    {course_id:integer(select),optional
        {label "Course"}
        {options $course_options
        }
    }
    {distance:float(text),optional
        {label "Distance"}
        {html {size 4}}}
    {distance_units:text(select)
        {label ""}
        {options {
            {"Miles" m}
            {"Kilometers" km}
        }}
        {value $du}
    }
    {time_hr:integer(text),optional
        {html {size 2 maxlength 2}}
        {help_text "Hours"}}
    {time_min:integer(text),optional
        {html {size 2 maxlength 2}}
        {help_text "Minutes"}}
    {time_sec:integer(text),optional
        {html {size 2 maxlength 2}}
        {help_text "Seconds"}}
    {weight:float(text),optional
        {label "Weight"}
        {html {size 5 maxlength 5}}}
    {weight_units:text(select)
        {label ""}
        {options {
            {"Pounds" lb}
            {"Kilograms" kg}
        }}
        {value $wu}
    }
    {resting_hr:integer(text),optional
        {label "Resting HR"}
        {html {size 3 maxlength 3}}}
    {comments:text(textarea),optional
        {html {cols 50 rows 10}}
    }
    {shoe_id:integer(select),optional
        {label "Shoe"}
        {options $shoe_options
        }
    }
    runner_id:integer(hidden)
} -validate {
    {time_hr
        { [empty_string_p $time_hr] || $time_hr >= 0 }
        "Invalid value for Hours."
    }
    {time_min
        { [empty_string_p $time_min] || ($time_min >= 0 && $time_min < 60) }
        "Invalid value for Minutes."
    }
    {time_sec
        { [empty_string_p $time_sec] || ($time_sec >= 0 && $time_sec < 60) }
        "Invalid value for Seconds."
    }
    {resting_hr
        { [empty_string_p $resting_hr] || ($resting_hr > 30 && $resting_hr < 200)}
        "That's not an accurate resting heart rate."
    }
} -new_request {
    set workout_date [template::util::date::today]
} -select_query_name workout_info -new_data {
    # if time values are empty, set to zero
    set time_hr [ad_decode $time_hr "" 0 $time_hr]
    set time_min [ad_decode $time_min "" 0 $time_min]
    set time_sec [ad_decode $time_sec "" 0 $time_sec]

    rl::workout::new -runner_id $runner_id \
        -package_id $package_id \
        -workout_date $workout_date \
        -distance $distance \
        -distance_units $distance_units \
        -time "${time_hr}:${time_min}:${time_sec}" \
        -weight $weight \
        -weight_units $weight_units \
        -resting_hr $resting_hr \
        -type_id $type_id \
        -shoe_id $shoe_id \
        -course_id $course_id \
        -comments $comments \
        -creation_user $user_id \
        -creation_ip $ip_addr
    
} -edit_data {
    # if time values are empty, set to zero
    set time_hr [ad_decode $time_hr "" 0 $time_hr]
    set time_min [ad_decode $time_min "" 0 $time_min]
    set time_sec [ad_decode $time_sec "" 0 $time_sec]

    rl::workout::edit -workout_id $workout_id \
        -workout_date $workout_date \
        -distance $distance \
        -distance_units $distance_units \
        -time "${time_hr}:${time_min}:${time_sec}" \
        -weight $weight \
        -weight_units $weight_units \
        -resting_hr $resting_hr \
        -type_id $type_id \
        -shoe_id $shoe_id \
        -course_id $course_id \
        -comments $comments \
        -creation_user $user_id \
        -creation_ip $ip_addr

} -after_submit {
#    ad_returnredirect [export_vars -base workouts {runner_id}]
    ad_returnredirect ./
    ad_script_abort
}
