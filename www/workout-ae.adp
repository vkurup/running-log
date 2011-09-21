<master>
<property name="context">Workout</property>

<formtemplate id="create_workout">
<table>

<tr>
  <th>Workout Date: </th>
  <td>
    <formwidget id="workout_date"> 
    <formerror id="workout_date">
        <br /><font color="red">@formerror.workout_date@</font>
    </formerror>
  </td>
</tr>

<tr>
  <th>Type: </th>
  <td>
    <formwidget id="type_id"> 
    <formerror id="type_id">
        <br /><font color="red">@formerror.type_id@</font>
    </formerror>
  </td>
</tr>

<tr>
  <th>Courses: </th>
  <td>
    <formwidget id="course_id">
    <formerror id="course_id">
        <br /><font color="red">@formerror.course_id@</font>
    </formerror>
  </td>
</tr>

<tr>
  <th>Distance: </th>
  <td>
    <formwidget id="distance">
    <formwidget id="distance_units">
    <formerror id="distance">
        <br /><font color="red">@formerror.distance@</font>
    </formerror>
  </td>
</tr>

<tr>
  <th>Time: </th>
  <td>
    <table>
    <tr>
      <td><formwidget id="time_hr"> : </td>
      <td><formwidget id="time_min"> : </td>
      <td><formwidget id="time_sec"> </td>
    </tr>
    <tr>
      <td><font size="-2"><formhelp id="time_hr"></font></td>
      <td><font size="-2"><formhelp id="time_min"></font></td>
      <td><font size="-2"><formhelp id="time_sec"></font></td>
    </tr>
    <tr>
      <td colspan="3">
        <font color="red">
        <formerror id="time_hr"></formerror>
        <formerror id="time_min"></formerror>
        <formerror id="time_sec"></formerror>
        </font>
      </td>
    </tr>
    </table>
  </td>
</tr>

<tr>
  <th>Weight: </th>
  <td>
    <formwidget id="weight">
    <formwidget id="weight_units">
    <formerror id="weight">
        <br /><font color="red">@formerror.weight@</font>
    </formerror>
  </td>
</tr>

<tr>
  <th>Resting HR: </th>
  <td>
    <formwidget id="resting_hr">
    <formerror id="resting_hr">
        <br /><font color="red">@formerror.resting_hr@</font>
    </formerror>
  </td>
</tr>

<tr>
  <th>Comments: </th>
  <td>
    <formwidget id="comments"> 
    <formerror id="comments">
        <br /><font color="red">@formerror.comments@</font>
    </formerror>
  </td>
</tr>

<tr>
  <th>Shoes: </th>
  <td>
    <formwidget id="shoe_id">
    <formerror id="shoe_id">
        <br /><font color="red">@formerror.shoe_id@</font>
    </formerror>
  </td>
</tr>

<tr>
  <td colspan="2" align="center"><formwidget id="formbutton:ok"></td>
</tr>

</table>
</formtemplate>
