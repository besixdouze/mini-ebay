<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<%
	String userName = (String)session.getAttribute("userName");
	
	if(userName == null || userName.equals("null")){
		response.sendRedirect("loginHashing.html");
		return;
	}
%>

<html>
	<head>
		<title>Mini-ebay - Sell Product</title>
	</head>
	<body>
		<h1>Sell a Product</h1>
		<p>Welcome, <b><%=userName%></b>! Register a new product for auction.</p>
		
		<form action="sellProduct_action.jsp" method="post" enctype="multipart/form-data">
			<table border="0">
				<tr>
					<td>Product Name:</td>
					<td><input type="text" name="productName" size="50" required /></td>
				</tr>
				<tr>
					<td>Description:</td>
					<td><textarea name="description" rows="5" cols="50" required></textarea></td>
				</tr>
				<tr>
					<td>Department:</td>
					<td>
						<select name="deptId" required>
							<option value="">Select Department</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Starting Bid ($):</td>
					<td><input type="number" name="startingBid" step="0.01" min="0.01" required /></td>
				</tr>
				<tr>
					<td>Due Date:</td>
					<td><input type="date" name="dueDate" required /></td>
				</tr>
				<tr>
					<td>Product Image:</td>
					<td><input type="file" name="file" accept="image/*" /></td>
				</tr>
			</table>
			<br>
			<input type="submit" value="List Product" />
			<input type="reset" value="Reset" />
		</form>
		
		<hr>
		<p><a href="welcomeMenu.jsp">Back to Main Menu</a> | <a href="signout.jsp">Logout</a></p>
		
		<script>
			window.onload = function() {
				fetch('getDepartments.jsp')
					.then(response => response.text())
					.then(html => {
						const select = document.querySelector('select[name="deptId"]');
						select.innerHTML = '<option value="">Select Department</option>' + html;
					})
					.catch(error => console.error('Error loading departments:', error));
			};
		</script>
	</body>
</html>
