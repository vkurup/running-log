# /packages/running-log/www/admin/index.tcl
ad_page_contract {
     Front admin page
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Mon Jan 29 12:02:21 2007
     @cvs-id $Id:$
} {
}

permission::require_permission -object_id [ad_conn package_id] -privilege admin

set runner_count [db_string runner_count "select count(1) from rl_runners"]
