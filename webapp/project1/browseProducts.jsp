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
		<title>Mini-ebay - Browse Products</title>
	</head>
	<body>
		<h1>Browse Products</h1>
		
		<form action="searchProducts.jsp" method="get">
			<table border="0">
				<tr>
					<td>Search:</td>
					<td><input type="text" name="searchTerm" size="40" /></td>
				</tr>
				<tr>
					<td>Department:</td>
					<td>
						<select name="deptId">
							<option value="0">All Departments</option>
							<%
								applicationDepartmentManager deptMgr = null;
								ResultSet deptRes = null;
								
								try{
									deptMgr = new applicationDepartmentManager();
									deptRes = deptMgr.listAllDepartments();
									
									while(deptRes.next()){
										int deptId = deptRes.getInt("DeptId");
										String deptName = deptRes.getString("DeptName");
							%>
							<option value="<%=deptId%>"><%=deptName%></option>
							<%
									}
									
									deptRes.close();
									deptMgr.close();
									
								} catch(Exception e){
									e.printStackTrace();
								}
							%>
						</select>
					</td>
				</tr>
			</table>
			<input type="submit" value="Search" />
		</form>
		
		<hr>
		<h2>All Active Products</h2>
		
		<table border="1">
			<tr>
				<th>Image</th>
				<th>Product Name</th>
				<th>Department</th>
				<th>Current Bid</th>
				<th>Due Date</th>
				<th>Action</th>
			</tr>
			
			<%
				applicationProductManager prodMgr = null;
				ResultSet prodRes = null;
				
				try{
					prodMgr = new applicationProductManager();
					prodRes = prodMgr.listAllProducts();
					
					while(prodRes.next()){
						int productId = prodRes.getInt("ProductId");
						String productName = prodRes.getString("ProductName");
						String deptName = prodRes.getString("DeptName");
						double currentBid = prodRes.getDouble("CurrentBid");
						String dueDate = prodRes.getString("DueDate");
						String imagePath = prodRes.getString("ImagePath");
			%>
			<tr>
				<td>
					<%if(imagePath != null && !imagePath.isEmpty()){%>
						<img src="<%=imagePath%>" width="100" height="100" alt="<%=productName%>">
					<%} else {%>
						No image
					<%}%>
				</td>
				<td><%=productName%></td>
				<td><%=deptName%></td>
				<td>$<%=String.format("%.2f", currentBid)%></td>
				<td><%=dueDate%></td>
				<td><a href="productDetail.jsp?productId=<%=productId%>">View Details</a></td>
			</tr>
			<%
					}
					
					prodRes.close();
					prodMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="6">Error loading products</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<hr>
		<p><a href="welcomeMenu.jsp">Back to Main Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
