ad_library {
    Test procs related to runner model

    @author Vinod Kurup (vinod@kurup.com)
    @creation-date 2006-04-19
}


aa_register_case rl_create_log {
    Test running log creation
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            array set user_info [twt::user::create]
            set user_id $user_info(user_id)

            # now create a log
            set runner_id [rl::runner::new -user_id $user_id]
            aa_true "Runner created for user $user_id" \
                [rl::runner::runner_id $user_id]

            array set prefs [rl::runner::runner_prefs $runner_id]
            # defaults set appropriately
            aa_equals "Height blank" $prefs(height) ""
            aa_equals "Start on Sunday" $prefs(start_week) 1
            aa_equals "Use miles" $prefs(distance_units) m
            aa_equals "Use lbs" $prefs(weight_units) lb

            # try to create another one and make sure it returns the
            # one already created
            set runner_id2 [rl::runner::new -user_id $user_id]
            aa_equals "rl::runner::new returns already created log" \
                $runner_id $runner_id2
            
        }
}

aa_register_case rl_delete_log {
    Test deletion of a running log
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            array set user_info [twt::user::create]            
            set user_id $user_info(user_id)

            aa_false "Log doesn't exist yet" [rl::runner::runner_id $user_id]
            
            # create a log
            set runner_id [rl::runner::new -user_id $user_id]
            aa_true "Runner created for user $user_id" \
                [rl::runner::runner_id $user_id]

            # delete it
            rl::runner::del $runner_id
            aa_false "Log no longer exists" [rl::runner::runner_id $user_id]
        }    
}

aa_register_case rl_edit_log {
    Test editing of log prefs
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            array set user_info [twt::user::create]            
            set user_id $user_info(user_id)

            # create a log with default params
            set runner_id [rl::runner::new -user_id $user_id -height 69.3]
            aa_true "Runner created for user $user_id" \
                [rl::runner::runner_id $user_id]

            array set prefs [rl::runner::runner_prefs $runner_id]
            aa_equals "Before: height is 69.3" $prefs(height) 69.3
            aa_equals "Before: start_week is 1" $prefs(start_week) 1
            aa_equals "Before: distance_units is m" $prefs(distance_units) m
            aa_equals "Before: weight_units is lb" $prefs(weight_units) lb

            # edit it
            rl::runner::edit -runner_id $runner_id \
                -height 70.2 \
                -start_week 0 \
                -distance_units km \
                -weight_units kg
            
            # After
            array set prefs [rl::runner::runner_prefs $runner_id]
            aa_equals "After: height is 70.2" $prefs(height) 70.2
            aa_equals "After: start_week is 0" $prefs(start_week) 0
            aa_equals "After: distance_units is km" $prefs(distance_units) km
            aa_equals "After: weight_units is kg" $prefs(weight_units) kg
        }    
}

aa_register_case rl_count_runners {
    Test runner counting procedure
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            array set user_info [twt::user::create]            
            set user_id $user_info(user_id)
 
            set pre [rl::runner::count]
            set pre_public [rl::runner::count -user_id -1]

            # add a runner
            set runner_id [rl::runner::new -user_id $user_id]

            set post [rl::runner::count]
            set total_diff [expr $post - $pre]

            aa_equals "One runner counted" $total_diff 1

            # Now do the same for to count public logs
            set post_public [rl::runner::count -user_id -1]
            set public_diff [expr $post_public - $pre_public]
            aa_equals "No new public runners" $public_diff 0

            # Make new runner public and count again
            rl::runner::make_public -runner_id $runner_id
            set post_public [rl::runner::count -user_id -1]
            set public_diff [expr $post_public - $pre_public]
            aa_equals "One public runner counted" $public_diff 1
        }
}
