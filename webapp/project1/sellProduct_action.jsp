<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*,java.util.*, jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload2.jakarta.servlet5.*" %>
<%@ page import="org.apache.commons.fileupload2.core.*" %>
<%@ page import="java.nio.file.*" %>

<%
	String userName = (String)session.getAttribute("userName");
	
	if(userName == null || userName.equals("null")){
		response.sendRedirect("loginHashing.html");
		return;
	}
%>

<html>
	<head>
		<title>Mini-ebay - Sell Product Action</title>
	</head>
	<body>
		<h1>Sell Product</h1>
		
		<%
			String productName = "";
			String description = "";
			String startingBidStr = "";
			String dueDate = "";
			String deptIdStr = "";
			String imagePath = "";
			boolean success = false;
			String errorMessage = "";
			
			File file;
			int maxFileSize = 5000 * 1024;
			int maxMemSize = 5000 * 1024;
			String filePath = application.getRealPath("/project1/images") + File.separator;
			
			String contentType = request.getContentType();
			
			if((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)){
				
				DiskFileItemFactory factory = DiskFileItemFactory.builder()
					.setPath(filePath)
					.get();
				
				JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
				upload.setSizeMax(maxFileSize);
				
				try{
					List fileItems = upload.parseRequest(request);
					Iterator i = fileItems.iterator();
					
					while(i.hasNext()){
						FileItem fi = (FileItem)i.next();
						
						if(!fi.isFormField()){
							String fieldName = fi.getFieldName();
							String fileName = fi.getName();
							
							if(fileName != null && !fileName.isEmpty()){
								long sizeInBytes = fi.getSize();
								file = new File(filePath + fileName);
								Path path = FileSystems.getDefault().getPath(filePath + fileName);
								fi.write(path);
								imagePath = "images/" + fileName;
							}
						} else {
							String fieldName = fi.getFieldName();
							String fieldValue = fi.getString();
							
							if(fieldName.equals("productName")){
								productName = fieldValue;
							} else if(fieldName.equals("description")){
								description = fieldValue;
							} else if(fieldName.equals("startingBid")){
								startingBidStr = fieldValue;
							} else if(fieldName.equals("dueDate")){
								dueDate = fieldValue;
							} else if(fieldName.equals("deptId")){
								deptIdStr = fieldValue;
							}
						}
					}
					
					double startingBid = Double.parseDouble(startingBidStr);
					int deptId = Integer.parseInt(deptIdStr);
					
					applicationProductManager prodMgr = new applicationProductManager();
					success = prodMgr.addProduct(productName, description, startingBid, imagePath, dueDate, deptId, userName);
					prodMgr.close();
					
					if(!success){
		%>
		<h2>Product Listed Successfully!</h2>
		<p><font color="green">Your product "<%=productName%>" has been listed for auction.</font></p>
		<p>Starting bid: $<%=String.format("%.2f", startingBid)%></p>
		<p>Due date: <%=dueDate%></p>
		<%if(!imagePath.isEmpty()){%>
			<p>Image uploaded: <%=imagePath%></p>
		<%}%>
		<%
					} else {
		%>
		<h2>Error</h2>
		<p><font color="red">Failed to list product. Please try again.</font></p>
		<%
					}
					
				} catch(Exception e){
					e.printStackTrace();
		%>
		<h2>Error</h2>
		<p><font color="red">An error occurred while listing your product: <%=e.getMessage()%></font></p>
		<%
				}
			} else {
		%>
		<h2>Error</h2>
		<p><font color="red">Invalid form submission. Please use the form to submit your product.</font></p>
		<%
			}
		%>
		
		<hr>
		<p>
			<a href="myProducts.jsp">View My Products</a> | 
			<a href="sellProduct.jsp">Sell Another Product</a> | 
			<a href="welcomeMenu.jsp">Main Menu</a> | 
			<a href="signout.jsp">Logout</a>
		</p>
	</body>
</html>
