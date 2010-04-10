<!doctype HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>EE Zone Advisor Admin Tools</title>
</head>
<body>

<h1>EE Zone Advisor Admin Tools</h1>
<h2>by <a target="_blank" style="text-decoration:none;color:black;" href="http://www.experts-exchange.com/M_2850883.html">evilrix</a></h2>

<div id="delete" style="display:none;">
<h2>Automatic Delete</h2>
<form action="http://www.experts-exchange.com/admin/xml/startAutoClose.jsp" method="post">
	<input type="hidden" value="delete" name="action" />
	<table border="0">
		<tr>
			<td>Question ID:</td><td colspan="3"><input type="text" name="qid" />
		</tr>
		<tr>
			<td>Refund:</td>
			<td>
				<select name="refund">
					<option value="true" selected="true">True</option>
					<option value="false">False</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Reason:</td><td colspan="3"><textarea rows="5" cols="80" name="reason" wrap="soft"></textarea></td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<input type="submit" value="Submit" />
				<input type="reset" value="Reset" />
			</td>
		</tr>
	</table>
</form>
</div>

<div id="close" style="display:none;">
<h2>Automatic Close</h2>
<form action="http://www.experts-exchange.com/admin/xml/startAutoClose.jsp" method="post">
	<input type="hidden" value="close" name="action" />
	<table border="0">
		<tr>
			<td>Question ID:</td><td colspan="3"><input type="text" name="qid" />
		</tr>
		<tr>
			<td>Refund:</td>
			<td>
				<select name="refund">
					<option value="true" selected="true">True</option>
					<option value="false">False</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Reason:</td><td colspan="3"><textarea rows="5" cols="80" name="reason" wrap="soft"></textarea></td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<input type="submit" value="Submit" />
				<input type="reset" value="Reset" />
			</td>
		</tr>
	</table>
</form>
</div>

<div id="accept" style="display:none;">
<h2>Automatic Accept</h2>
<form action="http://www.experts-exchange.com/admin/xml/startAutoClose.jsp" method="post">
	<input type="hidden" value="accept" name="action" />
	<table border="0">
		<tr>
			<td>Question ID:</td><td colspan="3"><input type="text" name="qid" />
		</tr>
		<tr>
			<td>Answer ID:</td><td colspan="3"><input type="text" name="aid" />
		</tr>
		<tr>
			<td>Points:</td><td colspan="3"><input type="text" name="points" />
		</tr>
		<tr>
			<td>Grade:</td>
			<td>
				<select name="grade">
					<option value="A" selected="true">A</option>
					<option value="B">B</option>
					<option value="C">C</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Refund:</td>
			<td>
				<select name="refund">
					<option value="true" selected="true">True</option>
					<option value="false">False</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Reason:</td><td colspan="3"><textarea rows="5" cols="80" name="reason" wrap="soft"></textarea></td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<input type="submit" value="Submit" />
				<input type="reset" value="Reset" />
			</td>
		</tr>
	</table>
</form>
</div>

<div id="split" style="display:none;">
<h2>Automatic Split</h2>
<form action="http://www.experts-exchange.com/admin/xml/startAutoClose.jsp" method="post">
	<input type="hidden" value="split" name="action" />
	<table border="0">
		<tr>
			<td>Question ID:</td><td colspan="3"><input type="text" name="qid" />
		</tr>
		<tr>
			<td>Answer IDs:</td><td colspan="3"><input type="text" name="aids" />
			&nbsp;&nbsp;<i>eg. 11111111,22222222,33333333</i>
		</tr>
		<tr>
			<td>Points:</td><td colspan="3"><input type="text" name="points" />
			&nbsp;&nbsp;<i>eg. 100,150,200</i>
		</tr>
		<tr>
			<td>Grade:</td>
			<td>
				<select name="grade">
					<option value="A" selected="true">A</option>
					<option value="B">B</option>
					<option value="C">C</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Refund:</td>
			<td>
				<select name="refund">
					<option value="true" selected="true">True</option>
					<option value="false">False</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Reason:</td><td colspan="3"><textarea rows="5" cols="80" name="reason" wrap="soft"></textarea></td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<input type="submit" value="Submit" />
				<input type="reset" value="Reset" />
			</td>
		</tr>
	</table>
</form>
</div>

<script type="text/javascript">
<!--
function set(idx)
{
	container = document.getElementById('container');

	if(idx > 0)
	{
		act = document.getElementById('opt').options[idx].value;
		html = document.getElementById(act).innerHTML;
	}
	
	container.innerHTML = html
}
-->
</script>

<form>
	<select id="opt" onchange="set(this.form.opt.selectedIndex);">
		<option>Choose an option</option>
		<option value="delete">Delete question</option>
		<option value="close">Close question</option>
		<option value="accept">Accept answer</option>
		<option value="split">Split answers</option>
	</select>
</form>

<div id="container"></div>

</body>
</html>
