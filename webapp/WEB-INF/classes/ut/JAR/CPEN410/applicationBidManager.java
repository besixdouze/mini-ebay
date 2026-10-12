//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
        This class manages bid operations for the Mini-ebay system
*/
public class applicationBidManager{

        //myDBConn is an MySQLConnector object for accessing to the database
        private MySQLCompleteConnector myDBConn;
        
        /********
                Default constructor
                It creates a new MySQLConnector object and open a connection to the database
                @parameters:
                
        */
        public applicationBidManager(){
                //Create the MySQLConnector object
                myDBConn = new MySQLCompleteConnector();
                
                //Open the connection to the database
                myDBConn.doConnection();
        }
        
        
        /*******
                placeBid method
                        Place a bid on a product
                        @parameters:
                                productId: the product ID
                                userName: the bidder's username
                                bidAmount: the bid amount
                        @returns:
                                boolean: true if bid was placed successfully
        */
        public boolean placeBid(int productId, String userName, double bidAmount)
        {
                boolean res;
                String table, values;
                
                table = "bid";
                values = "NULL, " + productId + ", '" + userName + "', " + bidAmount + ", NOW()";
                
                res = myDBConn.doInsert(table, values);
                System.out.println("Bid insertion result: " + res);
                
                return res;
        }
        
        /*******
                getHighestBid method
                        Get the highest bid for a product
                        @parameters:
                                productId: the product ID
                        @returns:
                                ResultSet containing the highest bid information
        */
        public ResultSet getHighestBid(int productId)
        {
                String fields, tables, whereClause;
                
                tables = "bid";
                fields = "MAX(BidAmount) as HighestBid, COUNT(*) as BidCount";
                whereClause = "ProductId = " + productId;
                
                System.out.println("getting highest bid...");
                
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                getBidsByProduct method
                        Get all bids for a specific product
                        @parameters:
                                productId: the product ID
                        @returns:
                                ResultSet containing all bids for the product
        */
        public ResultSet getBidsByProduct(int productId)
        {
                String fields, tables, whereClause;
                
                tables = "bid, usergood";
                fields = "bid.BidId, bid.BidAmount, bid.BidDate, bid.UserName, usergood.Name";
                whereClause = "bid.UserName = usergood.UserName AND bid.ProductId = " + productId + " ORDER BY bid.BidAmount DESC, bid.BidDate DESC";
                
                System.out.println("getting bids by product...");
                
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                getBidsByUser method
                        Get all bids placed by a specific user
                        @parameters:
                                userName: the bidder's username
                        @returns:
                                ResultSet containing all bids by the user
        */
        public ResultSet getBidsByUser(String userName)
        {
                String fields, tables, whereClause;
                
                tables = "bid, product, department";
                fields = "bid.BidId, bid.BidAmount, bid.BidDate, product.ProductId, product.ProductName, " +
                         "product.CurrentBid, product.DueDate, product.ImagePath, department.DeptName, product.IsActive";
                whereClause = "bid.ProductId = product.ProductId AND product.DeptId = department.DeptId " +
                              "AND bid.UserName = '" + userName + "' ORDER BY bid.BidDate DESC";
                
                System.out.println("getting bids by user...");
                
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                isHighestBidder method
                        Check if a user is the highest bidder on a product
                        @parameters:
                                productId: the product ID
                                userName: the user's username
                        @returns:
                                ResultSet with comparison result
        */
        public ResultSet isHighestBidder(int productId, String userName)
        {
                String fields, tables, whereClause;
                
                tables = "bid";
                fields = "UserName, BidAmount";
                whereClause = "ProductId = " + productId + " AND BidAmount = (SELECT MAX(BidAmount) FROM bid WHERE ProductId = " + productId + ")";
                
                System.out.println("checking highest bidder...");
                
                return myDBConn.doSelect(fields, tables, whereClause);
        }
        
        /*******
                deleteBidsByProduct method
                        Delete all bids associated with a product (used when deleting a product)
                        @parameters:
                                productId: the product ID
                        @returns:
                                int: number of bids deleted
        */
        public int deleteBidsByProduct(int productId)
        {
                String table = "bid";
                String whereClause = "ProductId = " + productId;
                
                int rowsDeleted = myDBConn.doDelete(table, whereClause);
                System.out.println("Deleted " + rowsDeleted + " bids for product " + productId);
                
                return rowsDeleted;
        }
        
        /*********
                close method
                        Close the connection to the database.
                        This method must be called at the end of each page/object that instatiates a applicationBidManager object
                        @parameters:
                        @returns:
        */
        public void close()
        {
                //Close the connection
                myDBConn.closeConnection();
        }

}
