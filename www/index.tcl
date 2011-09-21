# /packages/running-log/www/index.tcl
ad_page_contract {
     Front page
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Thu Sep 18 21:13:50 2003
     @cvs-id $Id: index.tcl,v 1.5 2005/12/12 03:02:15 vinod Exp $
} {
} 

set user_id [ad_conn user_id]

if { $user_id } {
    set runner_id [rl::runner::runner_id $user_id]
    if { $runner_id } {
        rp_form_put runner_id $runner_id
        rp_internal_redirect log
        ad_script_abort
    } else {
        ad_returnredirect log-ae
    }
} 

# tmp measure to redirect to demo log
ad_returnredirect "log?runner_id=63350"
