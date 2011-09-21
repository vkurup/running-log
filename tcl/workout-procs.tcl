# 

ad_library {
    
    Procs related to a workout
    
    @author Vinod Kurup (vinod@kurup.com)
    @creation-date 2006-05-17
}

namespace eval rl::workout {}

ad_proc -public rl::workout::new {
    -runner_id:required
    -package_id:required
    {-workout_date "to_timestamp(null,'YYYY MM DD')"}
    {-distance 0}
    {-distance_units m}
    {-time ""}
    {-weight ""}
    {-weight_units lb}
    {-resting_hr ""}
    {-type_id ""}
    {-shoe_id ""}
    {-course_id ""}
    {-course_desc ""}
    {-comments ""}
    {-mime_type "text/plain"}
    {-creation_user ""}
    {-creation_ip ""}
} {
    Add a new workout. Distance and weight values should be in units of 
    user's preference.

    @param workout_date as outputted by ad_form
    @param distance 
    @param distance_units m = miles, km = kilometers
    @param time
    @param weight
    @param weight_units lb = pounds, kg = kilograms
    @param resting_hr Resting Heart Rate
    @param shoe_id Which shoe?
    @param course_id Which course?
    @param course_desc Only used if course_id null. Used to describe a course
                       that you don't want to store in rl_courses table
    @param comments Journal entry for this run.
    @param mime_type MIME type of comments

    @return workout_id A unique id for the workout
} {
    permission::require_permission -object_id $runner_id -privilege write

    # get content_folder from package_id
    set folder_id [rl::workout::folder_id $package_id]

    # all values are stored in db as english units
    if { [string equal $distance_units km] } {
        set distance [rl::util::km_to_mi $distance]
    }
    
    if { [string equal $weight_units kg] } {
        set weight [rl::util::kg_to_lb $weight]
    }

    if { ![empty_string_p $course_id] } {
        set course_desc ""
    }

    # make sure distance is an integer so we can aggregate in list-builder
    if { [empty_string_p $distance] } {
        set distance 0
    }

    return [db_exec_plsql new_workout {}]
}

ad_proc -public rl::workout::edit {
    -workout_id:required
    {-workout_date "to_timestamp(null,'YYYY MM DD')"}
    {-distance 0}
    {-distance_units m}
    {-time ""}
    {-weight ""}
    {-weight_units lb}
    {-resting_hr ""}
    {-type_id ""}
    {-shoe_id ""}
    {-course_id ""}
    {-course_desc ""}
    {-comments ""}
    {-mime_type "text/plain"}
    {-creation_user ""}
    {-creation_ip ""}
} {
    Edit a workout.
} {
    permission::require_permission -object_id $workout_id -privilege write

    # all values are stored in db as english units
    if { [string equal $distance_units km] } {
        set distance [rl::util::km_to_mi $distance]
    }
    
    if { [string equal $weight_units kg] } {
        set weight [rl::util::kg_to_lb $weight]
    }

    if { ![empty_string_p $course_id] } {
        set course_desc ""
    }

    # make sure distance is an integer so we can aggregate in list-builder
    if { [empty_string_p $distance] } {
        set distance 0
    }

    return [db_exec_plsql edit_workout {}]
}

ad_proc -public rl::workout::del {
    workout_id
} {
    Delete a workout.
} {
    permission::require_permission -object_id $workout_id -privilege delete
    db_exec_plsql delete_workout {}
}

ad_proc -public rl::workout::get {
    workout_id
} {
    Get details of a workout as an array.

    @param workout_id the workout
    @return array of values
} {
    if { ![db_0or1row get_workout {} -column_array workout] } {
        return {workout_id 0}
    }

    # do permission check (after making sure object exists)
    permission::require_permission -object_id $workout_id -privilege read
    return [array get workout]
}

ad_proc -public rl::workout::folder_id {
    package_id
} {
    Given a package_id, return the content folder (folder_id) that 
    workouts are stored in.

    @return folder_id content folder
} {
    set path "/running-log/${package_id}"
    return [db_string get_folder_id {}]
}

ad_proc -public rl::workout::shoe_options {
    {-all:boolean}
    runner_id
} {
    Return a listing of this runner's shoes. The returned list is in a format
    that can be given to ad_form's 'options' value. 
    <pre>
    set shoe_options [rl::workout::shoe_spec $runner_id]
    ad_form ... -form \{
        \{shoe_id:integer(select),optional
            \{options $shoe_options\}\} ...
    </pre>

    @param runner_id The runner
    @param all if -all flag is provided, then show retired shoes as well
} {
    if { $all_p } {
        set query "select * from rl_shoes where runner_id = :runner_id order by start_date desc"
    } else {
        set query "select * from rl_shoes where runner_id = :runner_id and deleted_p is false order by start_date desc"
    }

    set spec [list]
    db_foreach get_shoes $query {
        lappend spec [list $name $shoe_id]
    }

    # add a blank line and then 
    lappend spec {"" ""} {"Don't record a shoe" ""}
    return $spec
}

ad_proc -public rl::workout::course_options {
    {-all:boolean}
    runner_id
} {
    Return a listing of this runner's courses. The returned list is in a format
    that can be given to ad_form's 'options' value. 

    @see rl::workout::shoe_options

    @param runner_id The runner
    @param all if -all flag is provided, then show retired courses as well
} {
    if { $all_p } {
        set query "select * from rl_courses where runner_id = :runner_id order by name"
    } else {
        set query "select * from rl_courses where runner_id = :runner_id and deleted_p is false order by name"
    }

    set spec [list]
    db_foreach get_courses $query {
        lappend spec [list "$name - $distance" $course_id]
    }

    # add a blank line and then 
    lappend spec {"" ""} {"Don't record a course" ""}
    return $spec
}

ad_proc -public rl::workout::type_options {
    runner_id
} {
    Return a listing of this runner's workout types. The returned list is 
    in a format that can be given to ad_form's 'options' value. In addition
    to any runner-specific types, there are a few default types, characterized
    by having runner_id of NULL.

    @see rl::workout::shoe_options
} {
    set spec [list]
    db_foreach get_types {select type_id, type from rl_types where runner_id = :runner_id or runner_id is null order by type} {
        lappend spec [list $type $type_id]
    }

    # add a blank line and then 
    lappend spec {"" ""} {"Don't record a workout type" ""}
    return $spec
}

