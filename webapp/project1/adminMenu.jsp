<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<%
	String userName = (String)session.getAttribute("userName");
	String userFullName = (String)session.getAttribute("userFullName");
	
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
%>

<html>
	<head>
		<title>Mini-ebay - Admin Dashboard</title>
	</head>
	<body>
		<h1>Administrator Dashboard</h1>
		<p>Welcome, Admin <%=userFullName%></p>
		
		<h3>User Management</h3>
		<ul>
			<li><a href="manageUsers.jsp">View All Users</a></li>
			<li><a href="addUserAdmin.jsp">Add New User</a></li>
		</ul>
		
		<h3>Department Management</h3>
		<ul>
			<li><a href="manageDepartments.jsp">View All Departments</a></li>
			<li><a href="addDepartment.jsp">Add New Department</a></li>
		</ul>
		
		<h3>Product Management</h3>
		<ul>
			<li><a href="manageProducts.jsp">View All Products</a></li>
		</ul>
		
		<hr>
		<p><a href="welcomeMenu.jsp">Back to Main Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
