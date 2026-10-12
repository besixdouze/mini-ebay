<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<%
	String userName = (String)session.getAttribute("userName");
	
	if(userName == null || userName.equals("null")){
		response.sendRedirect("loginHashing.html");
		return;
	}
	
	String productIdStr = request.getParameter("productId");
	int productId = 0;
	
	if(productIdStr != null){
		try{
			productId = Integer.parseInt(productIdStr);
		} catch(NumberFormatException e){
			response.sendRedirect("browseProducts.jsp");
			return;
		}
	} else {
		response.sendRedirect("browseProducts.jsp");
		return;
	}
%>

<html>
	<head>
		<title>Mini-ebay - Product Details</title>
	</head>
	<body>
		<%
			applicationProductManager prodMgr = null;
			applicationBidManager bidMgr = null;
			ResultSet prodRes = null;
			ResultSet bidRes = null;
			
			try{
				prodMgr = new applicationProductManager();
				prodRes = prodMgr.getProductById(productId);
				
				if(prodRes.next()){
					String productName = prodRes.getString("ProductName");
					String description = prodRes.getString("Description");
					double currentBid = prodRes.getDouble("CurrentBid");
					double startingBid = prodRes.getDouble("StartingBid");
					String dueDate = prodRes.getString("DueDate");
					String imagePath = prodRes.getString("ImagePath");
					String deptName = prodRes.getString("DeptName");
					String sellerUserName = prodRes.getString("SellerUserName");
					String dateCreated = prodRes.getString("DateCreated");
					boolean isActive = prodRes.getBoolean("IsActive");
		%>
		
		<h1><%=productName%></h1>
		
		<table border="0">
			<tr>
				<td rowspan="8">
					<%if(imagePath != null && !imagePath.isEmpty()){%>
						<img src="<%=imagePath%>" width="300" height="300" alt="<%=productName%>">
					<%} else {%>
						<p>No image available</p>
					<%}%>
				</td>
				<td><b>Department:</b></td>
				<td><%=deptName%></td>
			</tr>
			<tr>
				<td><b>Seller:</b></td>
				<td><%=sellerUserName%></td>
			</tr>
			<tr>
				<td><b>Starting Bid:</b></td>
				<td>$<%=String.format("%.2f", startingBid)%></td>
			</tr>
			<tr>
				<td><b>Current Bid:</b></td>
				<td><font size="+2" color="red">$<%=String.format("%.2f", currentBid)%></font></td>
			</tr>
			<tr>
				<td><b>Due Date:</b></td>
				<td><%=dueDate%></td>
			</tr>
			<tr>
				<td><b>Listed Date:</b></td>
				<td><%=dateCreated%></td>
			</tr>
			<tr>
				<td><b>Status:</b></td>
				<td><%=isActive ? "Active" : "Closed"%></td>
			</tr>
			<tr>
				<td colspan="2">
					<%if(isActive){%>
						<form action="placeBid.jsp" method="post">
							<input type="hidden" name="productId" value="<%=productId%>" />
							<input type="hidden" name="currentBid" value="<%=currentBid%>" />
							<b>Your Bid: $</b>
							<input type="text" name="bidAmount" size="10" />
							<input type="submit" value="Place Bid" />
						</form>
					<%} else {%>
						<p>This auction has ended</p>
					<%}%>
				</td>
			</tr>
		</table>
		
		<h3>Description</h3>
		<p><%=description%></p>
		
		<hr>
		<h3>Bid History</h3>
		<table border="1">
			<tr>
				<th>Bidder</th>
				<th>Bid Amount</th>
				<th>Date</th>
			</tr>
			
			<%
				bidMgr = new applicationBidManager();
				bidRes = bidMgr.getBidsByProduct(productId);
				int bidCount = 0;
				
				while(bidRes.next()){
					bidCount++;
					String bidder = bidRes.getString("UserName");
					String bidderName = bidRes.getString("Name");
					double bidAmount = bidRes.getDouble("BidAmount");
					String bidDate = bidRes.getString("BidDate");
			%>
			<tr>
				<td><%=bidderName%> (<%=bidder%>)</td>
				<td>$<%=String.format("%.2f", bidAmount)%></td>
				<td><%=bidDate%></td>
			</tr>
			<%
				}
				
				if(bidCount == 0){
			%>
			<tr>
				<td colspan="3">No bids yet. Be the first to bid!</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<p>Total bids: <%=bidCount%></p>
		
		<%
				} else {
		%>
		<h2>Product not found</h2>
		<p>The product you are looking for does not exist.</p>
		<%
				}
				
				if(prodRes != null) prodRes.close();
				if(bidRes != null) bidRes.close();
				if(prodMgr != null) prodMgr.close();
				if(bidMgr != null) bidMgr.close();
				
			} catch(Exception e){
				e.printStackTrace();
		%>
		<h2>Error loading product</h2>
		<p>An error occurred while loading the product details.</p>
		<%
			}
		%>
		
		<hr>
		<p><a href="browseProducts.jsp">Back to Browse</a> | <a href="welcomeMenu.jsp">Main Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
