import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import java.sql.*;
import ut.JAR.CPEN410.*;

public class DepartmentListServlet extends HttpServlet {
   
   public void init() throws ServletException {
   }

   public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
        
      this.doPost(request, response);
   }

   public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
        
      response.setContentType("application/json");
      response.setCharacterEncoding("UTF-8");
      PrintWriter out = response.getWriter();
      
      StringBuilder jsonResult = new StringBuilder();
      jsonResult.append("{\"departments\":[");
      
      applicationDepartmentManager appDBMg = new applicationDepartmentManager();
      boolean first = true;
      
      try {
         ResultSet res = appDBMg.listAllDepartments();
         System.out.println("DepartmentListServlet: listing all departments");
         
         while (res.next()) {
            if (!first) {
               jsonResult.append(",");
            }
            first = false;
            
            jsonResult.append("{");
            jsonResult.append("\"deptId\":\"" + escapeJson(res.getString("DeptId")) + "\",");
            jsonResult.append("\"deptName\":\"" + escapeJson(res.getString("DeptName")) + "\"");
            jsonResult.append("}");
         }
         
         appDBMg.close();
         
      } catch(Exception e) {
         System.out.println("DepartmentListServlet error: " + e.getMessage());
         e.printStackTrace();
      }
      
      jsonResult.append("]}");
      out.println(jsonResult.toString());
   }
   
   private String escapeJson(String value) {
      if (value == null) return "";
      return value.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
   }

   public void destroy() {
   }
}
