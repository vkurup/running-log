<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="rl::runner::new.new_runner">
      <querytext>
      
    select rl_runner__new(
        :runner_id,         -- runner_id
        :user_id,           -- user_id
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

</queryset>
