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
		<title>Mini-ebay - Manage Products</title>
	</head>
	<body>
		<h1>Manage Products</h1>
		
		<table border="1">
			<tr>
				<th>ID</th>
				<th>Product Name</th>
				<th>Seller</th>
				<th>Department</th>
				<th>Current Bid</th>
				<th>Due Date</th>
				<th>Status</th>
				<th>Actions</th>
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
						String sellerUserName = prodRes.getString("SellerUserName");
						String deptName = prodRes.getString("DeptName");
						double currentBid = prodRes.getDouble("CurrentBid");
						String dueDate = prodRes.getString("DueDate");
			%>
			<tr>
				<td><%=productId%></td>
				<td><%=productName%></td>
				<td><%=sellerUserName%></td>
				<td><%=deptName%></td>
				<td>$<%=String.format("%.2f", currentBid)%></td>
				<td><%=dueDate%></td>
				<td>Active</td>
				<td>
					<a href="productDetail.jsp?productId=<%=productId%>">View</a> | 
					<a href="deleteProduct.jsp?productId=<%=productId%>" onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
				</td>
			</tr>
			<%
					}
					
					prodRes.close();
					prodMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="8">Error loading products</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<hr>
		<p><a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
