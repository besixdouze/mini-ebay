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
		<title>Mini-ebay - My Bids</title>
	</head>
	<body>
		<h1>My Bids</h1>
		<p>Viewing bids placed by: <b><%=userName%></b></p>
		
		<table border="1">
			<tr>
				<th>Product</th>
				<th>Department</th>
				<th>My Bid</th>
				<th>Current Bid</th>
				<th>Bid Date</th>
				<th>Due Date</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			
			<%
				applicationBidManager bidMgr = null;
				ResultSet bidRes = null;
				int count = 0;
				
				try{
					bidMgr = new applicationBidManager();
					bidRes = bidMgr.getBidsByUser(userName);
					
					while(bidRes.next()){
						count++;
						int productId = bidRes.getInt("ProductId");
						String productName = bidRes.getString("ProductName");
						String deptName = bidRes.getString("DeptName");
						double myBid = bidRes.getDouble("BidAmount");
						double currentBid = bidRes.getDouble("CurrentBid");
						String bidDate = bidRes.getString("BidDate");
						String dueDate = bidRes.getString("DueDate");
						boolean isActive = bidRes.getBoolean("IsActive");
						
						String status = "";
						String statusColor = "black";
						
						if(!isActive){
							status = "Ended";
							statusColor = "gray";
						} else if(myBid >= currentBid){
							status = "Winning";
							statusColor = "green";
						} else {
							status = "Outbid";
							statusColor = "red";
						}
			%>
			<tr>
				<td><%=productName%></td>
				<td><%=deptName%></td>
				<td>$<%=String.format("%.2f", myBid)%></td>
				<td>$<%=String.format("%.2f", currentBid)%></td>
				<td><%=bidDate%></td>
				<td><%=dueDate%></td>
				<td><font color="<%=statusColor%>"><b><%=status%></b></font></td>
				<td><a href="productDetail.jsp?productId=<%=productId%>">View Product</a></td>
			</tr>
			<%
					}
					
					if(count == 0){
			%>
			<tr>
				<td colspan="8">You have not placed any bids yet</td>
			</tr>
			<%
					}
					
					bidRes.close();
					bidMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
			%>
			<tr>
				<td colspan="8">Error loading bids</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<p>Total bids: <%=count%></p>
		
		<hr>
		<p><a href="welcomeMenu.jsp">Main Menu</a> | <a href="signout.jsp">Logout</a></p>
	</body>
</html>
