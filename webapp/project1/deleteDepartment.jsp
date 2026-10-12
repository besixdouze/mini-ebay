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
	
	String deptIdStr = request.getParameter("deptId");
	String message = "";
	boolean success = false;
	
	if(deptIdStr != null){
		try{
			int deptId = Integer.parseInt(deptIdStr);
			
			applicationDepartmentManager deptMgr = new applicationDepartmentManager();
			int rowsDeleted = deptMgr.deleteDepartment(deptId);
			
			if(rowsDeleted > 0){
				message = "Department deleted successfully!";
				success = true;
			} else {
				message = "Error: Failed to delete department.";
			}
			
			deptMgr.close();
			
		} catch(Exception e){
			e.printStackTrace();
			message = "Error: " + e.getMessage() + " (Department may have products assigned to it)";
		}
	}
%>

<html>
	<head>
		<title>Mini-ebay - Delete Department</title>
	</head>
	<body>
		<h1>Delete Department</h1>
		
		<%if(!message.isEmpty()){%>
			<p><b><%=message%></b></p>
			
			<%if(success){%>
				<p><a href="manageDepartments.jsp">Back to Department Management</a></p>
			<%}%>
		<%} else {%>
			<p>Department not found or invalid request.</p>
		<%}%>
		
		<hr>
		<p><a href="manageDepartments.jsp">View All Departments</a> | <a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
