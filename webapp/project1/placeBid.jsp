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
	String bidAmountStr = request.getParameter("bidAmount");
	String currentBidStr = request.getParameter("currentBid");
	
	int productId = 0;
	double bidAmount = 0.0;
	double currentBid = 0.0;
	boolean success = false;
	String errorMessage = "";
	
	try{
		productId = Integer.parseInt(productIdStr);
		bidAmount = Double.parseDouble(bidAmountStr);
		currentBid = Double.parseDouble(currentBidStr);
	} catch(NumberFormatException e){
		errorMessage = "Invalid bid amount or product ID";
	}
%>

<html>
	<head>
		<title>Mini-ebay - Place Bid</title>
	</head>
	<body>
		<h1>Place Bid</h1>
		
		<%
			if(!errorMessage.isEmpty()){
		%>
		<h2>Error</h2>
		<p><font color="red"><%=errorMessage%></font></p>
		<%
			} else if(bidAmount <= currentBid){
		%>
		<h2>Bid Too Low</h2>
		<p><font color="red">Your bid of $<%=String.format("%.2f", bidAmount)%> must be higher than the current bid of $<%=String.format("%.2f", currentBid)%></font></p>
		<%
			} else {
				applicationBidManager bidMgr = null;
				applicationProductManager prodMgr = null;
				
				try{
					bidMgr = new applicationBidManager();
					prodMgr = new applicationProductManager();
					
					success = bidMgr.placeBid(productId, userName, bidAmount);
					
					if(!success){
						int rowsUpdated = prodMgr.updateProductBid(productId, bidAmount);
						
						if(rowsUpdated > 0){
		%>
		<h2>Bid Placed Successfully!</h2>
		<p><font color="green">Your bid of $<%=String.format("%.2f", bidAmount)%> has been placed successfully.</font></p>
		<p>You are now the highest bidder!</p>
		<%
						} else {
		%>
		<h2>Error</h2>
		<p><font color="red">Failed to update product bid. Please try again.</font></p>
		<%
						}
					} else {
		%>
		<h2>Error</h2>
		<p><font color="red">Failed to place bid. Please try again.</font></p>
		<%
					}
					
					bidMgr.close();
					prodMgr.close();
					
				} catch(Exception e){
					e.printStackTrace();
		%>
		<h2>Error</h2>
		<p><font color="red">An error occurred while placing your bid.</font></p>
		<%
				}
			}
		%>
		
		<hr>
		<p>
			<a href="productDetail.jsp?productId=<%=productId%>">Back to Product</a> | 
			<a href="browseProducts.jsp">Browse Products</a> | 
			<a href="welcomeMenu.jsp">Main Menu</a> | 
			<a href="signout.jsp">Logout</a>
		</p>
	</body>
</html>
