import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import java.sql.*;
import ut.JAR.CPEN410.*;

public class ProductSearchServlet extends HttpServlet {
   
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
      
      String searchTerm = request.getParameter("searchTerm");
      String deptIdStr = request.getParameter("deptId");
      int deptId = 0;
      
      if (deptIdStr != null && !deptIdStr.isEmpty()) {
         try {
            deptId = Integer.parseInt(deptIdStr);
         } catch (NumberFormatException e) {
            deptId = 0;
         }
      }
      
      if (searchTerm == null) {
         searchTerm = "";
      }
      
      StringBuilder jsonResult = new StringBuilder();
      jsonResult.append("{\"products\":[");
      
      applicationProductManager appDBMg = new applicationProductManager();
      boolean first = true;
      
      try {
         ResultSet res = appDBMg.searchProducts(searchTerm, deptId);
         System.out.println("ProductSearchServlet: searching for '" + searchTerm + "' in dept " + deptId);
         
         while (res.next()) {
            if (!first) {
               jsonResult.append(",");
            }
            first = false;
            
            jsonResult.append("{");
            jsonResult.append("\"productId\":\"" + escapeJson(res.getString("ProductId")) + "\",");
            jsonResult.append("\"productName\":\"" + escapeJson(res.getString("ProductName")) + "\",");
            jsonResult.append("\"description\":\"" + escapeJson(res.getString("Description")) + "\",");
            jsonResult.append("\"currentBid\":\"" + escapeJson(res.getString("CurrentBid")) + "\",");
            jsonResult.append("\"startingBid\":\"" + escapeJson(res.getString("StartingBid")) + "\",");
            jsonResult.append("\"dueDate\":\"" + escapeJson(res.getString("DueDate")) + "\",");
            jsonResult.append("\"imagePath\":\"" + escapeJson(res.getString("ImagePath")) + "\",");
            jsonResult.append("\"deptName\":\"" + escapeJson(res.getString("DeptName")) + "\",");
            jsonResult.append("\"sellerUserName\":\"" + escapeJson(res.getString("SellerUserName")) + "\"");
            jsonResult.append("}");
         }
         
         appDBMg.close();
         
      } catch(Exception e) {
         System.out.println("ProductSearchServlet error: " + e.getMessage());
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
