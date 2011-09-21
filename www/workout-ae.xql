<?xml version="1.0"?>
<queryset>

<fullquery name="workout_info">      
      <querytext>

    select creation_user, creation_date, creation_ip, last_modified, 
           modifying_user, modifying_ip, data as comments, mime_type, 
           workout_id, runner_id, 
           rl_workout__convert_distance(distance, :du) as distance, 
           :du as distance_units, 
           extract (hour from time) as time_hr, 
           extract (minute from time) as time_min, 
           extract (second from time) as time_sec, 
           rl_workout__convert_weight(weight, :wu) as weight,
           :wu as weight_units,
           to_char(workout_date, 'YYYY MM DD') as workout_date, 
           resting_hr, type_id, shoe_id, course_id, course_desc
      from rl_workoutsi
      where workout_id = :workout_id

      </querytext>
</fullquery>


</queryset>
