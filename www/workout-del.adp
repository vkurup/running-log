<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

<p>
  Are you sure you want to delete <if @num_entries@ eq 1>this workout</if><else>these @num_entries@ workouts</else>?
</p>

<p>
  <a href="@yes_url@">Delete</a> - <a href="@no_url@">Cancel, do not delete</a>
</p>
