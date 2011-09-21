<?xml version="1.0"?>
<queryset>

<fullquery name="rl::runner::edit.update_runner">
      <querytext>
      
    select rl_runner__edit(
        :runner_id,         -- runner_id
        :height,            -- height
        :start_week,        -- start_week
        :distance_units,    -- distance_units
        :weight_units,      -- weight_units
        null,               -- object_type default rl_runner
        null,               -- creation_date default current_timestamp
        :creation_user,     -- creation_user
        :creation_ip,       -- creation_ip
        null                -- context_id
    )

      </querytext>
</fullquery>


<fullquery name="rl::runner::runner_prefs.get_runner_prefs">
      <querytext>
      
    select runner_id, height, start_week, distance_units, weight_units
      from rl_runners where runner_id = :runner_id

      </querytext>
</fullquery>


<fullquery name="rl::runner::runner_id.get_runner_id">
      <querytext>
      
    select runner_id from rl_runners where user_id = :user_id

      </querytext>
</fullquery>

 
<fullquery name="rl::runner::del.delete_runner">
      <querytext>
      
    select rl_runner__del(:runner_id)

      </querytext>
</fullquery>

<fullquery name="rl::runner::get_name.get_name">
      <querytext>
      
    select p.first_names || ' ' || p.last_name as fullname
      from persons p, rl_runners r
     where p.person_id = r.user_id
       and r.runner_id = :runner_id;

      </querytext>
</fullquery>

</queryset>
