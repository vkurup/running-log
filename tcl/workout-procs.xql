<?xml version="1.0"?>

<queryset>

<fullquery name="rl::workout::get.get_workout">
      <querytext>
      
    select creation_user, creation_date, creation_ip, last_modified, 
           modifying_user, modifying_ip, data as comments, mime_type, 
           workout_id, runner_id, distance, time, weight, 
           to_char(workout_date, 'YYYY MM DD') as workout_date, 
           resting_hr, shoe_id, course_id, course_desc
      from rl_workoutsi
      where workout_id = :workout_id

      </querytext>
</fullquery>
  
</queryset>