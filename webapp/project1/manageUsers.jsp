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
%>

<html>
	<head>
		<title>Mini-ebay - Manage Users</title>
	</head>
	<body>
		<h1>Manage Users</h1>
		
		<table border="1">
			<tr>
				<th>Username</th>
				<th>Name</th>
				<th>Telephone</th>
				<th>Actions</th>
			</tr>
			
			<%
				applicationAdminManager adminMgr = null;
				ResultSet userRes = null;
				
				try{
					adminMgr = new applicationAdminManager();
					userRes = adminMgr.listAllUsers();
					
					while(userRes.next()){
						String uname = userRes.getString("UserName");
						String name = userRes.getString("Name");
						String telephone = userRes.getString("Telephone");
			%>
			<tr>
				<td><%=uname%></td>
				<td><%=name%></td>
				<td><%=telephone%></td>
				<td>
					<a href="viewUserRoles.jsp?userName=<%=uname%>">View Roles</a> | 
					<a href="deleteUser.jsp?userName=<%=uname%>" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
				</td>
			</tr>
			<%
					}
					
					userRes.close();
					adminMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="4">Error loading users</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<hr>
		<p><a href="addUserAdmin.jsp">Add New User</a> | <a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
