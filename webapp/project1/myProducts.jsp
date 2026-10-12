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
		<title>Mini-ebay - My Products</title>
	</head>
	<body>
		<h1>My Products</h1>
		<p>Viewing products listed by: <b><%=userName%></b></p>
		
		<table border="1">
			<tr>
				<th>Product Name</th>
				<th>Department</th>
				<th>Starting Bid</th>
				<th>Current Bid</th>
				<th>Due Date</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			
			<%
				applicationProductManager prodMgr = null;
				ResultSet prodRes = null;
				int count = 0;
				
				try{
					prodMgr = new applicationProductManager();
					prodRes = prodMgr.getProductsByUser(userName);
					
					while(prodRes.next()){
						count++;
						int productId = prodRes.getInt("ProductId");
						String productName = prodRes.getString("ProductName");
						String deptName = prodRes.getString("DeptName");
						double startingBid = prodRes.getDouble("StartingBid");
						double currentBid = prodRes.getDouble("CurrentBid");
						String dueDate = prodRes.getString("DueDate");
						boolean isActive = prodRes.getBoolean("IsActive");
			%>
			<tr>
				<td><%=productName%></td>
				<td><%=deptName%></td>
				<td>$<%=String.format("%.2f", startingBid)%></td>
				<td>$<%=String.format("%.2f", currentBid)%></td>
				<td><%=dueDate%></td>
				<td><%=isActive ? "Active" : "Closed"%></td>
				<td><a href="productDetail.jsp?productId=<%=productId%>">View Details</a></td>
			</tr>
			<%
					}
					
					if(count == 0){
			%>
			<tr>
				<td colspan="7">You have not listed any products yet</td>
			</tr>
			<%
					}
					
					prodRes.close();
					prodMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="7">Error loading products</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<p>Total products: <%=count%></p>
		
		<hr>
		<p><a href="sellProduct.jsp">Sell New Product</a> | <a href="welcomeMenu.jsp">Main Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
