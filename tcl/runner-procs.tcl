# 

ad_library {
    
    Procs related to a runner
    
    @author Vinod Kurup (vinod@kurup.com)
    @creation-date 2006-05-17
}

# namespace runner

namespace eval rl::runner {}

ad_proc -public rl::runner::new {
    {-user_id:required}
    {-height ""}
    {-start_week 1}
    {-distance_units "m"}
    {-weight_units "lb"}
    {-runner_id ""}
} {
    Create a new log for user_id, and set some preferences (or use
    defaults). This proc simply calls the PL proc runner__new. If the
    user_id already has a log, then simply return the log's runner_id 

    If runner_id is provided, use that as the new value, otherwise generate
    the next sequence value.

    @param user_id Create a new log for this user_id
    @param height Runner's height in inches
    @param start_week Which day does our week start on? 0=Sunday, 1=Monday
    @param distance_units Default display of distances. m=miles,
           km=kilometers
    @param weight_units Default display of weight. lb=pounds, kg=kilograms
    @return runner_id of the newly created running log

    @author Vinod Kurup vinod@kurup.com
    @creation-date 2003-09-21
} {
    permission::require_permission -object_id $user_id -privilege write

    if { $runner_id eq ""} {
        set runner_id [db_nextval acs_object_id_seq]
    }

    if { [ad_conn isconnected] } {
        set creation_user [ad_conn user_id]
        set creation_ip [ad_conn peeraddr]
    } else {
        set creation_user ""
        set creation_ip ""
    }

    set runner_id [db_exec_plsql new_runner {}]

    permission::grant -party_id $user_id -object_id $runner_id -privilege admin
    permission::grant -party_id $user_id -object_id $runner_id -privilege write

    return $runner_id
}

ad_proc -public rl::runner::edit {
    {-runner_id:required}
    {-height ""}
    {-start_week 1}
    {-distance_units "m"}
    {-weight_units "lb"}
} {
    Edits the preferences of a runner's log

    @param runner_id Log id
    @param height Runner's height in inches
    @param start_week Which day does our week start on? 0=Sunday, 1=Monday
    @param distance_units Default display of distances. m=miles,
           km=kilometers
    @param weight_units Default display of weight. lb=pounds, kg=kilograms
    @return runner_id 

    @author Vinod Kurup vinod@kurup.com
    @creation-date 2003-09-21
} {
    permission::require_permission -object_id $runner_id -privilege write

    if { [ad_conn isconnected] } {
        set creation_user [ad_conn user_id]
        set creation_ip [ad_conn peeraddr]
    } else {
        set creation_user ""
        set creation_ip ""
    }

    return [db_exec_plsql update_runner {}]
}

ad_proc -public rl::runner::runner_prefs {
    runner_id
} {
    Get all the preferences of a runner's log in an array. Array contains
    height, start_week, distance_units and weight_units. If runner_id is
    invalid, returns array of 1 item (runner_id=0)
    
    @param runner_id ID of runner
    @return array(height, start_week, distance_units, weight_units)

    @author Vinod Kurup vinod@kurup.com
    @creation-date 2003-09-21
} {
    if { ![db_0or1row get_runner_prefs {} -column_array prefs] } {
        return {runner_id 0}
    }

    # do permission check (after making sure object exists)
    permission::require_permission -object_id $runner_id -privilege read
    return [array get prefs]
}

ad_proc -public rl::runner::runner_id {
    user_id
} {
    Return the runner_id of the log of a given user_id. Returns 0 if runner_id
    doesn't exist.

    @param user_id User whose log we want
    @return runner_id of the running log of this user_id
    @author Vinod Kurup vinod@kurup.com
    @creation-date 2003-09-21
} {
    permission::require_permission -object_id $user_id -privilege read
    return [db_string get_runner_id {} -default 0] 
}

ad_proc -public rl::runner::del {
    runner_id
} {
    Delete a running log
    
    @param runner_id id of the log to delete
    @return 0 if success
    @author Vinod Kurup vinod@kurup.com
    @creation-date 2003-09-21
} {
    permission::require_permission -object_id $runner_id -privilege delete
    db_1row delete_runner {}

    return 0
}

ad_proc -public rl::runner::get_name {
    runner_id
} {
    Return the full name of a runner.
    
    @param runner_id id of the runner
    @return full name of a runner
    @author Vinod Kurup vinod@kurup.com
    @creation-date 2006-03-05
} {
    return [db_string get_name {}]
}

ad_proc -public rl::runner::count {
    -user_id
} {
    Return the number of runners in the system. If user_id is supplied, return the number of runners 'readable' by that user. So, if you supply user_id of -1, it will return the number of publically viewable logs.
    
    @param user_id if supplied, will return number of runners viewable by that user
    @return number of runners
    @author Vinod Kurup vinod@kurup.com
    @creation-date 2006-04-19
} {
    if { ![info exists user_id] } {
        return [db_string count_all "select count(1) from rl_runners"]
    } else {
        return [db_string count_viewable "select count(1) from rl_runners r where exists (select 1 from acs_object_party_privilege_map m where m.object_id=r.runner_id and m.party_id=:user_id and m.privilege='read')"]
    }
}

ad_proc -public rl::runner::make_public {
    -runner_id:required
} {
    Make a runner's log publicly viewable.
    
    @param runner_id id of the the log
    @return 0 if success
    @author Vinod Kurup vinod@kurup.com
    @creation-date 2006-04-19
} {
    permission::require_permission -object_id $runner_id -privilege admin

    permission::grant -party_id -1 -object_id $runner_id -privilege read

    return 0
}


