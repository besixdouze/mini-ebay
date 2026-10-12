//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
        This class manages product operations for the Mini-ebay system
*/
public class applicationProductManager{

        //myDBConn is an MySQLConnector object for accessing to the database
        private MySQLCompleteConnector myDBConn;
        
        /********
                Default constructor
                It creates a new MySQLConnector object and open a connection to the database
                @parameters:
                
        */
        public applicationProductManager(){
                //Create the MySQLConnector object
                myDBConn = new MySQLCompleteConnector();
                
                //Open the connection to the database
                myDBConn.doConnection();
        }
        
        
        /*******
                listAllProducts method
                        List all active products in the database
                        @parameters:
                        @returns:
                                A ResultSet containing all active products
        */
        public ResultSet listAllProducts()
        {
                //Declare function variables
                String fields, tables, whereClause;
                
                //Define the table where the selection is performed
                tables="product, department";
                //Define the list fields list to retrieve from the table product
                fields ="product.ProductId, product.ProductName, product.Description, product.CurrentBid, product.StartingBid, " +
                        "product.DueDate, product.ImagePath, department.DeptName, product.SellerUserName, product.DateCreated";
                whereClause="product.DeptId = department.DeptId AND product.IsActive = TRUE ORDER BY product.DateCreated DESC";
                
                System.out.println("listing all products...");
                
                //Return the ResultSet containing all products
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                searchProducts method
                        Search products by name and/or department
                        @parameters:
                                searchTerm: product name to search for
                                deptId: department ID (0 for all departments)
                        @returns:
                                A ResultSet containing matching products
        */
        public ResultSet searchProducts(String searchTerm, int deptId)
        {
                String fields, tables, whereClause;
                
                tables="product, department";
                fields ="product.ProductId, product.ProductName, product.Description, product.CurrentBid, product.StartingBid, " +
                        "product.DueDate, product.ImagePath, department.DeptName, product.SellerUserName";
                
                whereClause="product.DeptId = department.DeptId AND product.IsActive = TRUE";
                
                if(searchTerm != null && !searchTerm.trim().isEmpty()){
                        whereClause += " AND product.ProductName LIKE '%" + searchTerm + "%'";
                }
                
                if(deptId > 0){
                        whereClause += " AND product.DeptId = " + deptId;
                }
                
                whereClause += " ORDER BY product.DateCreated DESC";
                
                System.out.println("searching products...");
                
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                getProductById method
                        Get detailed information about a specific product
                        @parameters:
                                productId: the product ID
                        @returns:
                                A ResultSet containing the product details
        */
        public ResultSet getProductById(int productId)
        {
                String fields, tables, whereClause;
                
                tables="product, department";
                fields ="product.ProductId, product.ProductName, product.Description, product.CurrentBid, product.StartingBid, " +
                        "product.DueDate, product.ImagePath, department.DeptName, department.DeptId, product.SellerUserName, product.DateCreated, product.IsActive";
                whereClause="product.DeptId = department.DeptId AND product.ProductId = " + productId;
                
                System.out.println("getting product by id...");
                
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                getProductsByUser method
                        Get all products listed by a specific user
                        @parameters:
                                userName: the seller's username
                        @returns:
                                A ResultSet containing the user's products
        */
        public ResultSet getProductsByUser(String userName)
        {
                String fields, tables, whereClause;
                
                tables="product, department";
                fields ="product.ProductId, product.ProductName, product.Description, product.CurrentBid, product.StartingBid, " +
                        "product.DueDate, product.ImagePath, department.DeptName, product.IsActive";
                whereClause="product.DeptId = department.DeptId AND product.SellerUserName = '" + userName + "' ORDER BY product.DateCreated DESC";
                
                System.out.println("getting products by user...");
                
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                addProduct method
                        Add a new product to the database
                        @parameters:
                                productName, description, startingBid, imagePath, dueDate, deptId, sellerUserName
                        @returns:
                                boolean: true if insertion was successful
        */
        public boolean addProduct(String productName, String description, double startingBid, 
                                  String imagePath, String dueDate, int deptId, String sellerUserName)
        {
                boolean res;
                String table, values;
                
                table = "product";
                values = "NULL, '" + productName + "', '" + description + "', " + startingBid + ", " + startingBid + ", '" + 
                         imagePath + "', '" + dueDate + "', " + deptId + ", '" + sellerUserName + "', NOW(), TRUE";
                
                res = myDBConn.doInsert(table, values);
                System.out.println("Product insertion result: " + res);
                
                return res;
        }
        
        /*******
                updateProductBid method
                        Update the current bid for a product
                        @parameters:
                                productId: the product ID
                                newBid: the new bid amount
                        @returns:
                                int: number of rows affected
        */
        public int updateProductBid(int productId, double newBid)
        {
                String table = "product";
                String setClause = "CurrentBid = " + newBid;
                String whereClause = "ProductId = " + productId;
                
                return myDBConn.doUpdate(table, setClause, whereClause);
        }
        
        /*******
                deleteProduct method
                        Delete (deactivate) a product - soft delete
                        @parameters:
                                productId: the product ID
                        @returns:
                                int: number of rows affected
        */
        public int deleteProduct(int productId)
        {
                String table = "product";
                String setClause = "IsActive = FALSE";
                String whereClause = "ProductId = " + productId;
                
                return myDBConn.doUpdate(table, setClause, whereClause);
        }
        
        /*******
                deleteProductPermanently method
                        Permanently delete a product from the database (hard delete)
                        @parameters:
                                productId: the product ID
                        @returns:
                                int: number of rows deleted
        */
        public int deleteProductPermanently(int productId)
        {
                String table = "product";
                String whereClause = "ProductId = " + productId;
                
                int rowsDeleted = myDBConn.doDelete(table, whereClause);
                System.out.println("Permanently deleted product " + productId + ": " + rowsDeleted + " rows");
                
                return rowsDeleted;
        }
        
        /*********
                close method
                        Close the connection to the database.
                        This method must be called at the end of each page/object that instatiates a applicationProductManager object
                        @parameters:
                        @returns:
        */
        public void close()
        {
                //Close the connection
                myDBConn.closeConnection();
        }

}
