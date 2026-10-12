// Import required java libraries
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import ut.JAR.CPEN410.*;

// Extend HttpServlet class
public class AuthenticationServlet extends HttpServlet {
 
   private String message;

   public void init() throws ServletException {
      // Do required initialization
      message = "Authentication Servlet";
   }

   public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
     
      // Set response content type
      response.setContentType("text/html");

      // Actual logic goes here.
      PrintWriter out = response.getWriter();
      
      // Send the response
      out.println("This servlet does not support authentication via GET method!");
   }

   public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
     
      // Retrieve the http request parameters
      String userName = request.getParameter("user");
      String passwd = request.getParameter("pass");
         
      // Set response content type
      response.setContentType("application/json");
      response.setCharacterEncoding("UTF-8");

      // Actual logic goes here.
      PrintWriter out = response.getWriter();
     
      // Perform the actual authentication process
      String msg = doAuthentication(userName, passwd);
          
      // Send the final response to the requester
      out.println(msg);
      System.out.println(msg);
   }

   public String doAuthentication(String userName, String passwd)
   {
      String msg = "not";
                
      try {
         applicationDBAuthenticationGood appDBAut = new applicationDBAuthenticationGood();
         ResultSet res = appDBAut.authenticate(userName, passwd);
         if (res.next()) {
            // You got authenticated
            // then, generate the JSON object
            msg = "{\"userName\":\"" + res.getString(1) + "\", \n";
            msg += "\"name\":\"" + res.getString(3) + "\", \n";
            msg += "\"email\":\"dummy@dummy.com\", \n";
            msg += "\"id\":\"12345\" \n}";
         }
         appDBAut.close();
      }
      catch(Exception e) {
         e.printStackTrace();
      }
      finally {
         // Return the actual message
         return msg;
      }
   }

   public void destroy() {
      // do nothing.
   }
}
