# /packages/running-log/www/type-del.tcl
ad_page_contract {
     Delete one or more workout type.
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Sun Jan 25 15:01:35 2004
     @cvs-id $Id: type-del.tcl,v 1.1 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer
    type_id:integer,multiple
    {confirm_p:boolean 0}
}

if { !$confirm_p } {
    set num_entries [llength $type_id]

    if { $num_entries == 0 } {
        ad_returnredirect .
        return
    }

    set page_title "Delete [ad_decode $num_entries 1 "Type" "Types"]"
    set context [list $page_title]
    set yes_url "type-del?[export_vars { type_id:multiple { confirm_p 1 } runner_id }]"
    set no_url "."

    return
}

foreach type_id $type_id {
    permission::require_permission -object_id $runner_id -privilege write
    db_dml delete_type {}
}
    
ad_returnredirect .
ad_script_abort
