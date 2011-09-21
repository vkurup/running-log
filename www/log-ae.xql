<?xml version="1.0"?>
<queryset>

<fullquery name="runner_info">      
      <querytext>
      
    select runner_id, height, start_week, distance_units, weight_units
      from rl_runners where runner_id = :runner_id

      </querytext>
</fullquery>

<fullquery name="update_runner">      
      <querytext>

    update rl_runners
      set height = :height,
          start_week = :start_week, 
          distance_units = :distance_units, 
          weight_units = :weight_units
      where runner_id = :runner_id

      </querytext>
</fullquery>
 
</queryset>
