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
	
	String deleteUserName = request.getParameter("userName");
	String message = "";
	boolean success = false;
	
	if(deleteUserName != null){
		if(deleteUserName.equals(userName)){
			message = "Error: You cannot delete your own account!";
		} else {
			applicationAdminManager adminMgr = null;
			
			try{
				adminMgr = new applicationAdminManager();
				int rowsDeleted = adminMgr.deleteUser(deleteUserName);
				
				if(rowsDeleted > 0){
					message = "User '" + deleteUserName + "' deleted successfully!";
					success = true;
				} else {
					message = "Error: Failed to delete user.";
				}
				
				adminMgr.close();
				
			} catch(Exception e){
				e.printStackTrace();
				message = "Error: " + e.getMessage();
			}
		}
	}
%>

<html>
	<head>
		<title>Mini-ebay - Delete User</title>
	</head>
	<body>
		<h1>Delete User</h1>
		
		<%if(!message.isEmpty()){%>
			<p><b><%=message%></b></p>
			
			<%if(success){%>
				<p><a href="manageUsers.jsp">Back to User Management</a></p>
			<%}%>
		<%} else {%>
			<p>User not found or invalid request.</p>
		<%}%>
		
		<hr>
		<p><a href="manageUsers.jsp">View All Users</a> | <a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
