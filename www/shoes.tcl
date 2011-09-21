# /packages/running-log/www/shoes.tcl
ad_page_contract {
     List of shoes
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Tue Jan 27 21:09:35 2004
     @cvs-id $Id: shoes.tcl,v 1.1 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer
    orderby:optional
}

template::list::create \
    -name shoes \
    -multirow shoes \
    -key shoe_id \
    -elements {
        start_date {
            label "Start Date"
            link_url_col edit_url
            display_eval {[lc_time_fmt $start_date "%x"]}
        }
        name {
            label "Name"
        }
        mileage {
            label "Mileage"
        }
        age {
            label "Age"
        }
        comments {
            label "Comments"
        }
        active {
            label "Active"
        }
    } \
    -actions [list "Add a new shoe" [export_vars -base shoe-ae {runner_id}] "Add a new shoe"] \
    -bulk_actions {
        "Delete checked shoes" shoe-del "Delete checked shoes"
    } -bulk_action_export_vars {
        runner_id
    } -orderby {
        start_date {
            orderby start_date
        }
        default_value start_date,desc
    } -filters {
        runner_id {}
    }


db_multirow -extend {edit_url} shoes shoes_query {} {
    set edit_url [export_vars -base "shoe-ae" {shoe_id runner_id}]
}
