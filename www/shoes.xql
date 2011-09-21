<?xml version="1.0"?>
<queryset>

<fullquery name="shoes_query">
      <querytext>

    select shoe_id, runner_id, name,
        start_date, comments, 
        case when deleted_p is true then 'Retired' else 'Active' end as active,
        rl_shoe__distance(shoe_id) as mileage,
        date_trunc('month',age(start_date)) as age
    from rl_shoes
    where runner_id = :runner_id
    [template::list::orderby_clause -name shoes -orderby]

      </querytext>
</fullquery>

</queryset>
