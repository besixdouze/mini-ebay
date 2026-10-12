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
	
	String targetUser = request.getParameter("userName");
%>

<html>
	<head>
		<title>Mini-ebay - View User Roles</title>
	</head>
	<body>
		<h1>User Roles for: <%=targetUser%></h1>
		
		<table border="1">
			<tr>
				<th>Role ID</th>
				<th>Role Name</th>
				<th>Date Assigned</th>
			</tr>
			
			<%
				applicationAdminManager adminMgr = null;
				ResultSet roleRes = null;
				int count = 0;
				
				try{
					adminMgr = new applicationAdminManager();
					roleRes = adminMgr.getUserRoles(targetUser);
					
					while(roleRes.next()){
						count++;
						String roleId = roleRes.getString("RoleId");
						String roleName = roleRes.getString("RoleName");
						String dateAssign = roleRes.getString("dateAssign");
			%>
			<tr>
				<td><%=roleId%></td>
				<td><%=roleName%></td>
				<td><%=dateAssign%></td>
			</tr>
			<%
					}
					
					if(count == 0){
			%>
			<tr>
				<td colspan="3">No roles assigned to this user</td>
			</tr>
			<%
					}
					
					roleRes.close();
					adminMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="3">Error loading roles</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<hr>
		<p><a href="manageUsers.jsp">Back to User Management</a> | <a href="adminMenu.jsp">Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
