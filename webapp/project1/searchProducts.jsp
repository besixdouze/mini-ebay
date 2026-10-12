<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<%
	String userName = (String)session.getAttribute("userName");
	
	if(userName == null || userName.equals("null")){
		response.sendRedirect("loginHashing.html");
		return;
	}
	
	String searchTerm = request.getParameter("searchTerm");
	String deptIdStr = request.getParameter("deptId");
	int deptId = 0;
	
	if(deptIdStr != null && !deptIdStr.isEmpty()){
		try{
			deptId = Integer.parseInt(deptIdStr);
		} catch(NumberFormatException e){
			deptId = 0;
		}
	}
%>

<html>
	<head>
		<title>Mini-ebay - Search Results</title>
	</head>
	<body>
		<h1>Search Results</h1>
		
		<p>Search term: <b><%=searchTerm != null && !searchTerm.isEmpty() ? searchTerm : "All"%></b></p>
		<p>Department: <b><%=deptId > 0 ? deptId : "All"%></b></p>
		
		<hr>
		
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
				int count = 0;
				
				try{
					prodMgr = new applicationProductManager();
					prodRes = prodMgr.searchProducts(searchTerm, deptId);
					
					while(prodRes.next()){
						count++;
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
					
					if(count == 0){
			%>
			<tr>
				<td colspan="6">No products found matching your search criteria</td>
			</tr>
			<%
					}
					
					prodRes.close();
					prodMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="6">Error searching products</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<p>Total results: <%=count%></p>
		
		<hr>
		<p><a href="browseProducts.jsp">Back to Browse</a> | <a href="welcomeMenu.jsp">Main Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
