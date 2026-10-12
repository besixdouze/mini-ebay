<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<%
	String userName = (String)session.getAttribute("userName");
	
	if(userName == null || userName.equals("null")){
		response.sendRedirect("loginHashing.html");
		return;
	}
	
	applicationDBAuthenticationGood appDBAuth = null;
	ResultSet res = null;
	boolean isAdmin = false;
	
	try{
		appDBAuth = new applicationDBAuthenticationGood();
		res = appDBAuth.verifyUser(userName, "adminMenu.jsp", "welcomeMenu.jsp");
		
		if(res.next()){
			isAdmin = true;
		}
		
		if(res != null) res.close();
		appDBAuth.close();
		
	} catch(Exception e){
		e.printStackTrace();
	}
	
	if(!isAdmin){
		response.sendRedirect("welcomeMenu.jsp");
		return;
	}
	
	String deptName = request.getParameter("deptName");
	String message = "";
	
	if(deptName != null){
		String description = request.getParameter("description");
		
		applicationDepartmentManager deptMgr = null;
		
		try{
			deptMgr = new applicationDepartmentManager();
			boolean success = deptMgr.addDepartment(deptName, description);
			
			if(!success){
				message = "Department added successfully!";
			} else {
				message = "Error: Failed to add department.";
			}
			
			deptMgr.close();
			
		} catch(Exception e){
			e.printStackTrace();
			message = "Error: " + e.getMessage();
		}
	}
%>

<html>
	<head>
		<title>Mini-ebay - Add Department</title>
	</head>
	<body>
		<h1>Add New Department</h1>
		
		<%if(!message.isEmpty()){%>
			<p><b><%=message%></b></p>
			<hr>
		<%}%>
		
		<form action="addDepartment.jsp" method="post">
			<table border="0">
				<tr>
					<td>Department Name:</td>
					<td><input type="text" name="deptName" size="50" required /></td>
				</tr>
				<tr>
					<td>Description:</td>
					<td><textarea name="description" rows="3" cols="50"></textarea></td>
				</tr>
			</table>
			<br>
			<input type="submit" value="Add Department" />
			<input type="reset" value="Reset" />
		</form>
		
		<hr>
		<p><a href="manageDepartments.jsp">View All Departments</a> | <a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
