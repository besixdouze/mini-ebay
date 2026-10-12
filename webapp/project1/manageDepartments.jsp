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
		<title>Mini-ebay - Manage Departments</title>
	</head>
	<body>
		<h1>Manage Departments</h1>
		
		<table border="1">
			<tr>
				<th>ID</th>
				<th>Department Name</th>
				<th>Description</th>
				<th>Actions</th>
			</tr>
			
			<%
				applicationDepartmentManager deptMgr = null;
				ResultSet deptRes = null;
				
				try{
					deptMgr = new applicationDepartmentManager();
					deptRes = deptMgr.listAllDepartments();
					
					while(deptRes.next()){
						int deptId = deptRes.getInt("DeptId");
						String deptName = deptRes.getString("DeptName");
						String description = deptRes.getString("Description");
			%>
			<tr>
				<td><%=deptId%></td>
				<td><%=deptName%></td>
				<td><%=description%></td>
				<td>
					<a href="deleteDepartment.jsp?deptId=<%=deptId%>" onclick="return confirm('Are you sure you want to delete this department?')">Delete</a>
				</td>
			</tr>
			<%
					}
					
					deptRes.close();
					deptMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="4">Error loading departments</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<hr>
		<p><a href="addDepartment.jsp">Add New Department</a> | <a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
