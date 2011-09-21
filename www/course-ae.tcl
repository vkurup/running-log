# /packages/running-log/www/course-ae.tcl
ad_page_contract {
     Add a course.
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Tue Jan 27 20:32:18 2004
     @cvs-id $Id: course-ae.tcl,v 1.1 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer
    course_id:integer,optional
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set ip_addr [ad_conn peeraddr]

permission::require_permission -object_id $runner_id -privilege write

array set prefs [rl::runner::runner_prefs $runner_id]
set du $prefs(distance_units)

ad_form -name create_course -form {
    course_id:key(rl_course_id_sequence)
    runner_id:integer(hidden)
    {name:text(text)
        {label "Name"}}
    {distance:float(text)
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
    {comments:text(textarea),optional
        {label "Comments"}}
    {deleted_p:boolean(select)
        {label "Retire this course?"}
        {options {
            {"Yes" t}
            {"No" f}
        }}
        {values f}}
} -new_request {
} -select_query_name course_info -new_data {
    db_dml new_course {}
} -edit_data {
    db_dml update_course {}
} -after_submit {
    ad_returnredirect [export_vars -base courses {runner_id}]
    ad_script_abort
}
