<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="rl::apm::after_instantiate.get_folder">
      <querytext>

    select content_item__get_id('/running-log',null,'f')

      </querytext>
</fullquery>
 
<fullquery name="rl::apm::after_instantiate.create_folder">
      <querytext>

    select content_folder__new (
        :package_id,                -- name
        'Running Log $package_id',  -- label
        'Running Log $package_id',  -- description
        :parent_id                  -- parent_id
    )

      </querytext>
</fullquery>

<fullquery name="rl::apm::before_uninstantiate.delete_folder">
      <querytext>

    select content_folder__delete ( :folder_id )

      </querytext>
</fullquery>

</queryset>
