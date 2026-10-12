<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
	applicationDepartmentManager deptMgr = null;
	ResultSet deptRes = null;
	
	try{
		deptMgr = new applicationDepartmentManager();
		deptRes = deptMgr.listAllDepartments();
		
		while(deptRes.next()){
			int deptId = deptRes.getInt("DeptId");
			String deptName = deptRes.getString("DeptName");
%><option value="<%=deptId%>"><%=deptName%></option><%
		}
		
		deptRes.close();
		deptMgr.close();
		
	} catch(Exception e){
		e.printStackTrace();
	}
%>
