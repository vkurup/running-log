# /packages/running-log/tcl/apm-procs.tcl
ad_library {
     APM callback procs
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Wed Jan 21 23:46:41 2004
     @cvs-id $Id: apm-procs.tcl,v 1.1 2004/01/27 05:40:25 vinod Exp $
}

namespace eval rl {}
namespace eval rl::apm {}

ad_proc -public rl::apm::after_instantiate {
    -package_id
} {
    After instantiating the package, create a cr_folder at
    '/running-log/${package_id}'
} {
    set parent_id [db_string get_folder {}]
    db_exec_plsql create_folder {}
}

ad_proc -public rl::apm::before_uninstantiate {
    -package_id
} {
    Delete the cr_folder for this package.
} {
    set folder_id [rl::workout::folder_id $package_id]
    db_exec_plsql delete_folder {}
}
