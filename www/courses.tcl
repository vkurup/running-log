# /packages/running-log/www/courses.tcl
ad_page_contract {
     List of courses
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Tue Jan 27 21:09:35 2004
     @cvs-id $Id: courses.tcl,v 1.1 2004/02/16 21:19:28 vinod Exp $
} {
    runner_id:integer
    orderby:optional
}

array set prefs [rl::runner::runner_prefs $runner_id]
set du $prefs(distance_units)

template::list::create \
    -name courses \
    -multirow courses \
    -key course_id \
    -elements {
        name {
            label "Name"
            link_url_col edit_url
        }
        distance {
            label "Distance ($du)"
        }
        comments {
            label "Comments"
        }
        active {
            label "Active"
        }
    } \
    -actions [list "Add a new course" [export_vars -base course-ae {runner_id}] "Add a new course"] \
    -bulk_actions {
        "Delete checked courses" course-del "Delete checked courses"
    } -bulk_action_export_vars {
        runner_id
    } -orderby {
        name {
            orderby name
        }
        default_value name,asc
    } -filters {
        runner_id {}
    }


db_multirow -extend {edit_url} courses courses_query {} {
    set edit_url [export_vars -base "course-ae" {course_id runner_id}]
}
