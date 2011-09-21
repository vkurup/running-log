# /packages/running-log/www/types.tcl
ad_page_contract {
     List of workout types
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Tue Jan 27 21:09:35 2004
     @cvs-id $Id: types.tcl,v 1.1 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer
    orderby:optional
}

template::list::create \
    -name types \
    -multirow types \
    -key type_id \
    -elements {
        type {
            label "Workout Type"
            link_url_col edit_url
        }
        custom {
            label "Custom?"
        }
    } \
    -actions [list "Add a new type" [export_vars -base type-ae {runner_id}] "Add a new type"] \
    -bulk_actions {
        "Delete checked types" type-del "Delete checked types"
    } -bulk_action_export_vars {
        runner_id
    } -orderby {
        type {
            orderby type
        }
        default_value type,asc
    } -filters {
        runner_id {}
    }


db_multirow -extend {edit_url} types types_query {} {
    set edit_url [export_vars -base "type-ae" {type_id runner_id}]
}
