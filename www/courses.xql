<?xml version="1.0"?>
<queryset>

<fullquery name="courses_query">
      <querytext>

    select course_id, runner_id, name,
           rl_workout__convert_distance(distance, :du) as distance, comments, 
        case when deleted_p is true then 'Retired' else 'Active' end as active
    from rl_courses
    where runner_id = :runner_id
    [template::list::orderby_clause -name courses -orderby]

      </querytext>
</fullquery>

</queryset>
