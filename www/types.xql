<?xml version="1.0"?>
<queryset>

<fullquery name="types_query">
      <querytext>

    select type_id, runner_id, type,
           case when runner_id is null then 'Built-in' else 'Custom' end as custom
    from rl_types
    where runner_id = :runner_id or runner_id is null
    [template::list::orderby_clause -name types -orderby]

      </querytext>
</fullquery>

</queryset>
