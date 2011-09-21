# /packages/running-log/tcl/test/running-log-procs.tcl
ad_library {
     Test running log procs
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Sun Sep 21 12:56:29 2003
     @cvs-id $Id: running-log-procs.tcl,v 1.2 2004/02/16 21:19:28 vinod Exp $
}

# init class
aa_register_init_class mount_running_log {
    Mount and unmount a test running log.
    Need a mounted instance in order to add workouts.
} {
    # constructor

    # export these vars to the environment
    aa_export_vars {package_id node_name}

    # mount the blog
    set node_name [ad_generate_random_string]
    set package_id [site_node::instantiate_and_mount \
                     -node_name $node_name \
                     -package_key running-log]

} {
    # destructor

    apm_package_instance_delete $package_id
}


# Add shoe
# Edit shoe
# Delete shoe

# Add course
# Edit course
# Delete course

aa_register_case rl_time_str_fmt {
    Format a time string properly.
} {
    set time1 "00:09:40"
    aa_equals "$time1 correct" [rl::util::fmt_time $time1] "9:40"

    set time2 "01:09:40"
    aa_equals "$time2 correct" [rl::util::fmt_time $time2] "1:09:40"

    set time3 "00:11:47.633567"
    aa_equals "$time3 correct" [rl::util::fmt_time $time3] "11:47"

    set time4 "01:06:02.580656"
    aa_equals "$time4 correct" [rl::util::fmt_time $time4] "1:06:02"
}

aa_register_case rl_package_version {
    Test procs which get package version and date
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            set version [rl::version]
            set release_date [rl::release_date]

            aa_log $version
            aa_true version_valid [regexp {[0-9.]+[abd]*} $version]

            aa_log $release_date
            aa_true release_date_valid [expr [clock scan $release_date] > 0]
        }
}
