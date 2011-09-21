# /packages/running-log/www/log-ae.tcl
ad_page_contract {
     Add a runner to the system
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Thu Sep 18 22:31:00 2003
     @cvs-id $Id: log-ae.tcl,v 1.2 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer,optional
}

auth::require_login
set user_id [ad_conn user_id]

permission::require_permission -object_id $user_id -privilege write

# since runner_id is optional, a user who already has a log 
# may somehow get to this page without runner_id set (url surgery)
# if user_id already has a runner_id, show edit, not add form
set runner_id [rl::runner::runner_id $user_id]
if { $runner_id == 0 } {
    unset runner_id
}

ad_form -name create_runner -form {
    runner_id:key
    {height:text(text),optional 
        {label "Height (in inches)"}
        {html {
            size 5
        }}
    }
    {start_week:integer(select) 
        {label "Start of week"} 
        {options {
            {"Sunday" 0} 
            {"Monday" 1}
        }}
        {value 1}
    }
    {distance_units:text(select) 
        {label "Default Distance Units"} 
        {options {
            {"Miles" m} 
            {"Kilometers" km}
        }}
    }
    {weight_units:text(select) 
        {label "Default Weight Units"} 
        {options {
            {"Pounds" lb} 
            {"Kilograms" kg}
        }}
    }
    {public_p:text(select)
        {label "Who can view your log?"}
        {options {
            {"Just me" f}
            {"Anyone" t}
        }}
    }
} -validate {
    {height
        {[string is double $height]}
        "Should be height in inches. You entered $height"
    }
} -select_query_name runner_info -new_data {
    rl::runner::new -user_id $user_id \
        -height $height \
        -start_week $start_week \
        -distance_units $distance_units \
        -weight_units $weight_units \
        -runner_id $runner_id

} -edit_data {
    rl::runner::edit -runner_id $runner_id \
        -height $height \
        -start_week $start_week \
        -distance_units $distance_units \
        -weight_units $weight_units
} -after_submit {
    if {$public_p eq "t"} {
        permission::grant -party_id -1 -object_id $runner_id -privilege read
    } else {
        permission::revoke -party_id -1 -object_id $runner_id -privilege read
    }

    ad_returnredirect "./"
    ad_script_abort
}
