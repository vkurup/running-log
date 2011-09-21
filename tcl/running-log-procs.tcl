# /packages/running-log/tcl/running-log-procs.tcl
ad_library {
     Running log procs
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Sun Sep 21 21:17:35 2003
     @cvs-id $Id: running-log-procs.tcl,v 1.3 2005/12/12 02:59:26 vinod Exp $
}

namespace eval rl {}

# Procs for the running-log as a whole

ad_proc -public rl::total_miles {
} {
    Return the total miles run by all runners in the system
} {
    return [db_string total_miles "select sum(distance) from rl_workouts"]
}

ad_proc -public rl::version {
} {
    Return the package version.
} {
    apm_version_get -package_key running-log -array a
    return $a(version_name)
}

ad_proc -public rl::release_date {
} {
    Return the package version.
} {
    apm_version_get -package_key running-log -array a
    return $a(release_date)
}

