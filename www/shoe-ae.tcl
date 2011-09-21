# /packages/running-log/www/shoe-ae.tcl
ad_page_contract {
     Add a shoe.
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Tue Jan 27 20:32:18 2004
     @cvs-id $Id: shoe-ae.tcl,v 1.1 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer
    shoe_id:integer,optional
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set ip_addr [ad_conn peeraddr]

permission::require_permission -object_id $runner_id -privilege write

ad_form -name create_shoe -form {
    shoe_id:key(rl_shoe_id_sequence)
    runner_id:integer(hidden)
    {name:text(text)
        {label "Name"}}
    {start_date:date,to_sql(sql_date),to_html(sql_date)
        {label "Start Date"}
        {format "MONTH DD YYYY"}
        {help}}
    {comments:text(textarea),optional
        {label "Comments"}}
    {deleted_p:boolean(select)
        {label "Have you retired this shoe?"}
        {options {
            {"Yes" t}
            {"No" f}
        }}
        {values f}}
} -new_request {
    set start_date [template::util::date::today]
} -select_query_name shoe_info -new_data {
    db_dml new_shoe {}
} -edit_data {
    db_dml update_shoe {}
} -after_submit {
    ad_returnredirect [export_vars -base shoes {runner_id}]
    ad_script_abort
}
