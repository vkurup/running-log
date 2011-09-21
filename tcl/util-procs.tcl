# 

ad_library {
    
    Utility procs
    
    @author Vinod Kurup (vinod@kurup.com)
    @creation-date 2006-05-17
}

namespace eval rl::util {}

ad_proc -public rl::util::fmt_time {
    time_str
} {

    Takes a time string and properly formats it. Workout times are recorded
    in the database as type interval (Postgresql). The interval format looks 
    like '00:13:23' signifying 0 hours, 13 minutes and 23 seconds. If the 
    workout was less than 1 hour I don't want to show the 0 hours, but 
    instead show '13:23'. So, this proc basically strips the 00 if the 
    workout time was less than an hour.

    It also strips the decimal portion off of pace calculations, so 
    00:09:18.726273 will be converted to 9:18

    @param time_str time string from PG interval type
    @return time string without leading zeros
} {
    # get rid of decimal part
    set pt [string first . $time_str]
    if {$pt > 0} {
        set time_str [string replace $time_str [string first . $time_str] end]
    }

    # trim zeros
    return [string trimleft $time_str "0:"]
}

ad_proc -public rl::util::km_to_mi {
    distance
} {
    Converts a distance from kilometers to miles.

    @param distance distance in kilometers
    @return distance in miles
} {
    return [dt_round_to_precision [expr $distance / 1.609] 0.1]
}

ad_proc -public rl::util::kg_to_lb {
    weight
} {
    Converts a weight from kilograms to pounds.

    @param weight weight in kilograms
    @return weight in pounds
} {
    return [dt_round_to_precision [expr $weight * 2.2] 0.1]
}
