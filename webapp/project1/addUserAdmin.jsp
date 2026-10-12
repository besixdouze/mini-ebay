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
	
	String newUserName = request.getParameter("newUserName");
	String message = "";
	
	if(newUserName != null){
		String newUserPass = request.getParameter("newUserPass");
		String completeName = request.getParameter("completeName");
		String telephone = request.getParameter("telephone");
		String roleId = request.getParameter("roleId");
		
		applicationAdminManager adminMgr = null;
		
		try{
			adminMgr = new applicationAdminManager();
			boolean success = adminMgr.addUser(newUserName, completeName, newUserPass, telephone, roleId);
			
			if(!success){
				message = "User added successfully!";
			} else {
				message = "Error: Failed to add user.";
			}
			
			adminMgr.close();
			
		} catch(Exception e){
			e.printStackTrace();
			message = "Error: " + e.getMessage();
		}
	}
%>

<html>
	<head>
		<title>Mini-ebay - Add User (Admin)</title>
	</head>
	<body>
		<h1>Add New User</h1>
		
		<%if(!message.isEmpty()){%>
			<p><b><%=message%></b></p>
			<hr>
		<%}%>
		
		<form action="addUserAdmin.jsp" method="post">
			<table border="0">
				<tr>
					<td>Username:</td>
					<td><input type="text" name="newUserName" required /></td>
				</tr>
				<tr>
					<td>Password:</td>
					<td><input type="password" name="newUserPass" required /></td>
				</tr>
				<tr>
					<td>Full Name:</td>
					<td><input type="text" name="completeName" required /></td>
				</tr>
				<tr>
					<td>Telephone:</td>
					<td><input type="text" name="telephone" required /></td>
				</tr>
				<tr>
					<td>Role:</td>
					<td>
						<select name="roleId" required>
							<option value="USER">User</option>
							<option value="ADMIN">Admin</option>
						</select>
					</td>
				</tr>
			</table>
			<br>
			<input type="submit" value="Add User" />
			<input type="reset" value="Reset" />
		</form>
		
		<hr>
		<p><a href="manageUsers.jsp">View All Users</a> | <a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
