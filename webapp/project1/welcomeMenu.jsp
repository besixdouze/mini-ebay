<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<%
        String userName = (String)session.getAttribute("userName");
        String userFullName = (String)session.getAttribute("userFullName");
        
        if(userName == null || userName.equals("null")){
                response.sendRedirect("loginHashing.html");
                return;
        }
%>

<html>
        <head>
                <title>Mini-ebay - Welcome</title>
        </head>
        <body>
                <h1>Welcome to Mini-ebay, <%=userFullName%>!</h1>
                <h3>Main Menu</h3>
                
                <h4>Product Operations</h4>
                <ul>
                        <li><a href="browseProducts.jsp">Browse All Products</a></li>
                        <li><a href="sellProduct.jsp">Sell a Product</a></li>
                        <li><a href="myProducts.jsp">My Products</a></li>
                        <li><a href="myBids.jsp">My Bids</a></li>
                </ul>
                
                <%
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
                        
                        if(isAdmin){
                %>
                <h4>Administrative Functions</h4>
                <ul>
                        <li><a href="adminMenu.jsp">Admin Dashboard</a></li>
                </ul>
                <%
                        }
                %>
                
                <hr>
                <p><a href="signout.jsp">Logout</a></p>
                
                <p>Logged in as: <b><%=userName%></b></p>
        </body>
</html>
