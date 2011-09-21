<?xml version="1.0"?>
<queryset>

<fullquery name="new_course">
      <querytext>

    insert into rl_courses
    (course_id, runner_id, name, 
     distance, comments, deleted_p)
    select :course_id, :runner_id, :name,
           rl_workout__convert_distance(:distance, :du), :comments, :deleted_p

      </querytext>
</fullquery>


<fullquery name="course_info">
      <querytext>

    select course_id, runner_id, name,
           rl_workout__convert_distance(distance, :du) as distance, 
           :du as distance_units, comments, deleted_p
      from rl_courses
      where course_id = :course_id

      </querytext>
</fullquery>


<fullquery name="update_course">
      <querytext>

    update rl_courses
    set name = :name,
        distance = rl_workout__convert_distance(distance, :du), 
        comments = :comments, 
        deleted_p = :deleted_p
    where course_id = :course_id

      </querytext>
</fullquery>

</queryset>
