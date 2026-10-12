import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import java.sql.*;
import ut.JAR.CPEN410.*;

public class PlaceBidServlet extends HttpServlet {
   
   public void init() throws ServletException {
   }

   public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
     
      response.setContentType("text/html");
      PrintWriter out = response.getWriter();
      out.println("This servlet does not support placing bids via GET method!");
   }

   public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
        
      response.setContentType("application/json");
      response.setCharacterEncoding("UTF-8");
      PrintWriter out = response.getWriter();
      
      String productIdStr = request.getParameter("productId");
      String userName = request.getParameter("userName");
      String bidAmountStr = request.getParameter("bidAmount");
      
      if (productIdStr == null || userName == null || bidAmountStr == null ||
          productIdStr.isEmpty() || userName.isEmpty() || bidAmountStr.isEmpty()) {
         out.println("{\"status\":\"error\",\"message\":\"Missing required parameters\"}");
         return;
      }
      
      int productId;
      double bidAmount;
      
      try {
         productId = Integer.parseInt(productIdStr);
         bidAmount = Double.parseDouble(bidAmountStr);
      } catch (NumberFormatException e) {
         out.println("{\"status\":\"error\",\"message\":\"Invalid product ID or bid amount\"}");
         return;
      }
      
      StringBuilder jsonResult = new StringBuilder();
      
      applicationProductManager appDBMg = new applicationProductManager();
      
      try {
         ResultSet res = appDBMg.getProductById(productId);
         System.out.println("PlaceBidServlet: placing bid for product " + productId);
         
         if (!res.next()) {
            out.println("{\"status\":\"error\",\"message\":\"Product not found\"}");
            appDBMg.close();
            return;
         }
         
         double currentBid = res.getDouble("CurrentBid");
         boolean isActive = res.getBoolean("IsActive");
         
         if (!isActive) {
            out.println("{\"status\":\"error\",\"message\":\"This auction has ended\"}");
            appDBMg.close();
            return;
         }
         
         if (bidAmount <= currentBid) {
            out.println("{\"status\":\"error\",\"message\":\"Bid must be higher than current bid of $" + String.format("%.2f", currentBid) + "\",\"currentBid\":" + currentBid + "}");
            appDBMg.close();
            return;
         }
         
         applicationBidManager bidMgr = new applicationBidManager();
         boolean bidResult = bidMgr.placeBid(productId, userName, bidAmount);
         
         if (!bidResult) {
            int rowsUpdated = appDBMg.updateProductBid(productId, bidAmount);
            
            if (rowsUpdated > 0) {
               jsonResult.append("{\"status\":\"success\",");
               jsonResult.append("\"message\":\"Bid placed successfully\",");
               jsonResult.append("\"bidAmount\":" + bidAmount + ",");
               jsonResult.append("\"currentBid\":" + bidAmount + ",");
               jsonResult.append("\"productId\":" + productId + "}");
            } else {
               jsonResult.append("{\"status\":\"error\",\"message\":\"Failed to update product bid\"}");
            }
         } else {
            jsonResult.append("{\"status\":\"error\",\"message\":\"Failed to place bid\"}");
         }
         
         bidMgr.close();
         appDBMg.close();
         
      } catch(Exception e) {
         System.out.println("PlaceBidServlet error: " + e.getMessage());
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
