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
        
        String productIdStr = request.getParameter("productId");
        String message = "";
        boolean success = false;
        
        if(productIdStr != null){
                try{
                        int productId = Integer.parseInt(productIdStr);
                        
                        applicationBidManager bidMgr = new applicationBidManager();
                        int bidsDeleted = bidMgr.deleteBidsByProduct(productId);
                        bidMgr.close();
                        
                        applicationProductManager prodMgr = new applicationProductManager();
                        int rowsDeleted = prodMgr.deleteProductPermanently(productId);
                        
                        if(rowsDeleted > 0){
                                message = "Product deleted successfully! (Including " + bidsDeleted + " associated bids)";
                                success = true;
                        } else {
                                message = "Error: Failed to delete product.";
                        }
                        
                        prodMgr.close();
                        
                } catch(Exception e){
                        e.printStackTrace();
                        message = "Error: " + e.getMessage();
                }
        }
%>

<html>
        <head>
                <title>Mini-ebay - Delete Product</title>
        </head>
        <body>
                <h1>Delete Product</h1>
                
                <%if(!message.isEmpty()){%>
                        <p><b><%=message%></b></p>
                        
                        <%if(success){%>
                                <p><a href="manageProducts.jsp">Back to Product Management</a></p>
                        <%}%>
                <%} else {%>
                        <p>Product not found or invalid request.</p>
                <%}%>
                
                <hr>
                <p><a href="manageProducts.jsp">View All Products</a> | <a href="adminMenu.jsp">Back to Admin Menu</a> | <a href="signout.jsp">Logout</a></p>
        </body>
</html>
