<master>
<property name="google_ad_p">f</property>
<property name="title">@title@</property>
<property name="context">@context@</property>

<h3>Statistics:</h3>
<ul>
    <li>You've run @total_miles@ miles since @start_date@ (@dist_per_week_total@ miles/week).</li>
<multiple name="shoes">
    <li><if @shoes.deleted_p@ eq t>You ran</if><else>You've run</else> @shoes.distance@ miles in your @shoes.name@.</li>
</multiple>
</ul>

<h3>Actions:</h3>
<ul>

    <if @admin_p@><li><a href="admin">Admin</a></li></if>
    <if @write_p@><li><a href="log-ae?runner_id=@runner_id@">Preferences</a></li></if>
    <li>Workouts: <a href="workouts?runner_id=@runner_id@">View</a><if @write_p@> | <a href="workout-ae?runner_id=@runner_id@">Add</a></if></li>
    <li>Shoes: <a href="shoes?runner_id=@runner_id@">View</a><if @write_p@> | <a href="shoe-ae?runner_id=@runner_id@">Add</a></if></li>
    <li>Courses: <a href="courses?runner_id=@runner_id@">View</a><if @write_p@> | <a href="course-ae?runner_id=@runner_id@">Add</a></if></li>
    <li>Workout Types: <a href="types?runner_id=@runner_id@">View</a><if @write_p@> | <a href="type-ae?runner_id=@runner_id@">Add</a></if></li>
</ul>

<h3>Weekly Mileage:</h3>

<if @weekly_miles:rowcount@ gt 0>
<table>
<tr>
<th>Week</th>
<th>Weight</th>
<th colspan="2">Mileage</th>
</tr>

<multiple name="weekly_miles">

<tr>
<td>@weekly_miles.week_start_pretty@</td>
<td>@weekly_miles.weight@</td>
<td class="graph">
  <strong class="bar" style="width:
  @weekly_miles.distance@%;">@weekly_miles.distance@</strong>
</td>
</tr>

</multiple>
</table>
</if>

