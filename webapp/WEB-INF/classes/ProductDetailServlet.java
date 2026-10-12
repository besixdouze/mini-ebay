import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import java.sql.*;
import ut.JAR.CPEN410.*;

public class ProductDetailServlet extends HttpServlet {
   
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
      
      String productIdStr = request.getParameter("productId");
      
      if (productIdStr == null || productIdStr.isEmpty()) {
         out.println("{\"status\":\"error\",\"message\":\"Product ID is required\"}");
         return;
      }
      
      int productId;
      try {
         productId = Integer.parseInt(productIdStr);
      } catch (NumberFormatException e) {
         out.println("{\"status\":\"error\",\"message\":\"Invalid product ID\"}");
         return;
      }
      
      StringBuilder jsonResult = new StringBuilder();
      
      applicationProductManager appDBMg = new applicationProductManager();
      
      try {
         ResultSet res = appDBMg.getProductById(productId);
         System.out.println("ProductDetailServlet: getting product " + productId);
         
         if (res.next()) {
            jsonResult.append("{\"status\":\"success\",\"product\":{");
            jsonResult.append("\"productId\":\"" + escapeJson(res.getString("ProductId")) + "\",");
            jsonResult.append("\"productName\":\"" + escapeJson(res.getString("ProductName")) + "\",");
            jsonResult.append("\"description\":\"" + escapeJson(res.getString("Description")) + "\",");
            jsonResult.append("\"currentBid\":\"" + escapeJson(res.getString("CurrentBid")) + "\",");
            jsonResult.append("\"startingBid\":\"" + escapeJson(res.getString("StartingBid")) + "\",");
            jsonResult.append("\"dueDate\":\"" + escapeJson(res.getString("DueDate")) + "\",");
            jsonResult.append("\"imagePath\":\"" + escapeJson(res.getString("ImagePath")) + "\",");
            jsonResult.append("\"deptName\":\"" + escapeJson(res.getString("DeptName")) + "\",");
            jsonResult.append("\"deptId\":\"" + escapeJson(res.getString("DeptId")) + "\",");
            jsonResult.append("\"sellerUserName\":\"" + escapeJson(res.getString("SellerUserName")) + "\",");
            jsonResult.append("\"dateCreated\":\"" + escapeJson(res.getString("DateCreated")) + "\",");
            jsonResult.append("\"isActive\":\"" + escapeJson(res.getString("IsActive")) + "\",");
            
            applicationBidManager bidMgr = new applicationBidManager();
            ResultSet bidRes = bidMgr.getBidsByProduct(productId);
            
            StringBuilder bidsArray = new StringBuilder();
            bidsArray.append("[");
            int bidCount = 0;
            boolean firstBid = true;
            
            while (bidRes.next()) {
               if (!firstBid) {
                  bidsArray.append(",");
               }
               firstBid = false;
               
               bidsArray.append("{");
               bidsArray.append("\"bidId\":\"" + escapeJson(bidRes.getString("BidId")) + "\",");
               bidsArray.append("\"bidAmount\":\"" + escapeJson(bidRes.getString("BidAmount")) + "\",");
               bidsArray.append("\"bidDate\":\"" + escapeJson(bidRes.getString("BidDate")) + "\",");
               bidsArray.append("\"userName\":\"" + escapeJson(bidRes.getString("UserName")) + "\",");
               bidsArray.append("\"bidderName\":\"" + escapeJson(bidRes.getString("Name")) + "\"");
               bidsArray.append("}");
               bidCount++;
            }
            
            bidsArray.append("]");
            
            jsonResult.append("\"bidCount\":" + bidCount + ",");
            jsonResult.append("\"bids\":" + bidsArray.toString());
            jsonResult.append("}}");
            
            bidMgr.close();
            
         } else {
            jsonResult.append("{\"status\":\"error\",\"message\":\"Product not found\"}");
         }
         
         appDBMg.close();
         
      } catch(Exception e) {
         System.out.println("ProductDetailServlet error: " + e.getMessage());
         e.printStackTrace();
         jsonResult = new StringBuilder();
         jsonResult.append("{\"status\":\"error\",\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
      }
      
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
