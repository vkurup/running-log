# /packages/running-log/www/type-ae.tcl
ad_page_contract {
     Add a workout type.
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Tue Jan 27 20:32:18 2004
     @cvs-id $Id: type-ae.tcl,v 1.1 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer
    type_id:integer,optional
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set ip_addr [ad_conn peeraddr]

permission::require_permission -object_id $runner_id -privilege write

ad_form -name create_type -form {
    type_id:key(rl_type_id_sequence)
    runner_id:integer(hidden)
    {type:text(text)
        {label "Workout Type"}}
} -new_request {
} -select_query_name type_info -new_data {
    db_dml new_type {}
} -edit_data {
    db_dml update_type {}
} -after_submit {
    ad_returnredirect [export_vars -base types {runner_id}]
    ad_script_abort
}
