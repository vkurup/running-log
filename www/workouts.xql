<?xml version="1.0"?>
<queryset>

<fullquery name="workouts_query">
      <querytext>

    select data as comments, mime_type, workout_id, w.runner_id,
           workout_date, 
           rl_workout__convert_distance(distance, :du) 
             as distance, 
           time,
           extract(epoch from w.time) as time_seconds, 
           rl_workout__convert_weight(weight, :wu) 
             as weight, 
           resting_hr, shoe_id, course_id, course_desc, t.type
    from rl_workoutsi w left join rl_types t 
      on w.type_id = t.type_id
    where w.runner_id=:runner_id 
    [template::list::orderby_clause -name workouts -orderby]

      </querytext>
</fullquery>

</queryset>
