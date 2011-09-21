<?xml version="1.0"?>
<queryset>

<fullquery name="new_shoe">
      <querytext>

    insert into rl_shoes
    (shoe_id, runner_id, name, 
     start_date, comments, deleted_p)
    values
    (:shoe_id, :runner_id, :name,
     $start_date, :comments, :deleted_p)

      </querytext>
</fullquery>


<fullquery name="shoe_info">
      <querytext>

    select shoe_id, runner_id, name,
           to_char(start_date,'YYYY MM DD') as start_date, comments, deleted_p
      from rl_shoes
      where shoe_id = :shoe_id

      </querytext>
</fullquery>


<fullquery name="update_shoe">
      <querytext>

    update rl_shoes
    set name = :name,
        start_date = $start_date, 
        comments = :comments, 
        deleted_p = :deleted_p
    where shoe_id = :shoe_id

      </querytext>
</fullquery>

</queryset>
