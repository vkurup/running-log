# 

ad_library {
    
    Tests for the workout controller.
    
    @author Vinod Kurup (vinod@kurup.com)
    @creation-date 2006-05-16
    @arch-tag: 84AEE763-E504-11DA-A810-000393D14D28
    @cvs-id $Id$
}

# Add workout
aa_register_case -init_classes {
    mount_running_log
} rl_add_workout {
    Add a workout.
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            array set user_info [twt::user::create]            
            set user_id $user_info(user_id)

            # create a log
            set runner_id [rl::runner::new -user_id $user_id]

            # add a workout
            set workout_id [rl::workout::new -runner_id $runner_id \
                                -package_id $package_id]
            aa_true "Workout created" $workout_id
        }
}

# Edit workout
aa_register_case -init_classes {
    mount_running_log
} rl_edit_workout {
    Edit a workout.
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            array set user_info [twt::user::create]            
            set user_id $user_info(user_id)

            # create a log
            set runner_id [rl::runner::new -user_id $user_id]
            
            # add a workout
            set workout_id [rl::workout::new -runner_id $runner_id \
                               -package_id $package_id \
                               -distance 0]
            array set workout [rl::workout::get $workout_id]
            aa_equals "Initial value" $workout(distance) 0

            # edit a workout
            set edited_workout_id [rl::workout::edit -workout_id $workout_id \
                                       -distance 3.1]
            array set edited_workout [rl::workout::get $workout_id]
            aa_equals "Edited value" $edited_workout(distance) 3.1
        }
}

# Delete workout
aa_register_case -init_classes {
    mount_running_log
} rl_del_workout {
    Delete a workout.
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            array set user_info [twt::user::create]            
            set user_id $user_info(user_id)

            # create a log
            set runner_id [rl::runner::new -user_id $user_id]
            
            # add a workout
            set workout_id [rl::workout::new -runner_id $runner_id \
                               -package_id $package_id]
            aa_true "Workout created" $workout_id

            # delete it
            rl::workout::del $workout_id
            array set workout [rl::workout::get $workout_id]

            # if returned workout_id is 0, then no workout exist
            aa_false "Workout gone" $workout(workout_id)
        }
}

aa_register_case -init_classes {
    mount_running_log
} rl_zero_distance {
    Creating a workout with a time but zero distance was causing divide by zero error.
} {

    aa_run_with_teardown \
        -test_code {
            array set user_info [twt::user::create]

            # create a log
            set runner_id [rl::runner::new -user_id $user_info(user_id)]

            # add a workout
            set workout_id [rl::workout::new -runner_id $runner_id \
                                -package_id $package_id \
                                -distance 0 \
                                -time "00:23:13" \
                                -type_id 1]

            # Login
            twt::user::login $user_info(email) $user_info(password)

            twt::do_request "[twt::server_url]/${node_name}/workouts?runner_id=$runner_id"
            tclwebtest::assert text {N/A}
            aa_true "Assertions passed." 1
            
        } -teardown_code {
            rl::workout::del $workout_id
            twt::user::delete -user_id $user_info(user_id)
        }
   
}