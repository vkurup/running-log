<?xml version="1.0"?>
<queryset>

  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>
  
<fullquery name="rl::workout::new.new_workout">
      <querytext>
      
    select rl_workout__new(
        :runner_id,                                 -- runner_id
        $workout_date,                              -- workout_date
        :distance,                                  -- distance
        :time,                                      -- time
        :weight,                                    -- weight
        :resting_hr,                                -- resting_hr
        :type_id,                                   -- type_id
        :shoe_id,                                   -- shoe_id
        :course_id,                                 -- course_id
        :course_desc,                               -- course_desc
        :comments,                                  -- comments
        :creation_user,                             -- user_id
        :creation_ip,                               -- creation_ip
        :mime_type,                                 -- mime_type
        :folder_id                                  -- folder_id
    )

      </querytext>
</fullquery>
 
<fullquery name="rl::workout::edit.edit_workout">
      <querytext>
      
    select rl_workout__edit(
        :workout_id,                                -- workout_id
        $workout_date,                              -- workout_date
        :distance,                                  -- distance
        :time,                                      -- time
        :weight,                                    -- weight
        :resting_hr,                                -- resting_hr
        :type_id,                                   -- type_id
        :shoe_id,                                   -- shoe_id
        :course_id,                                 -- course_id
        :course_desc,                               -- course_desc
        :comments,                                  -- comments
        :creation_user,                             -- user_id
        :creation_ip,                               -- creation_ip
        :mime_type                                  -- mime_type
    )

      </querytext>
</fullquery>

<fullquery name="rl::workout::del.delete_workout">
      <querytext>

    select rl_workout__del(:workout_id)

      </querytext>
</fullquery>

<fullquery name="rl::workout::folder_id.get_folder_id">
      <querytext>

    select content_item__get_id(:path,null,'t')

      </querytext>
</fullquery>

  
</queryset>
