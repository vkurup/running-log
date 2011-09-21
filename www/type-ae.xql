<?xml version="1.0"?>
<queryset>

<fullquery name="new_type">
      <querytext>

    insert into rl_types
    (type_id, runner_id, type)
    values
    (:type_id, :runner_id, :type)

      </querytext>
</fullquery>


<fullquery name="type_info">
      <querytext>

    select type_id, runner_id, type
      from rl_types
      where type_id = :type_id

      </querytext>
</fullquery>


<fullquery name="update_type">
      <querytext>

    update rl_types
    set type = :type
    where type_id = :type_id

      </querytext>
</fullquery>

</queryset>
