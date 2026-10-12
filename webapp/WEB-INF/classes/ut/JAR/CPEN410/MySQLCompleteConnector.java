//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manage a connection to the Department database and it should not be accessed from the front End. 
*/
public class MySQLCompleteConnector{

	//Database credential <jdbc:<protocol>://<hostName>/<databaseName>>
	private String DB_URL = envOrDefault("DB_URL", "jdbc:mysql://localhost/project1");
	
	//Database authorized user information
	private String USER = System.getenv("DB_USER");
	private String PASS = System.getenv("DB_PASS");

	//Read an environment variable, falling back to a default when it is not set
	private static String envOrDefault(String name, String fallback){
		String v = System.getenv(name);
		return (v == null || v.isEmpty()) ? fallback : v;
	}
   
   //Connection objects
   private Connection conn;
   
   //Statement object to perform queries and transations on the database
   private Statement stmt;
   
	/********
		Default constructor
		@parameters:
		
	*/
	public MySQLCompleteConnector()
	{
		//define connections ojects null
		conn = null;
		stmt = null;}
		
	/********
		doConnection method
			It creates a new connection object and open a connection to the database
			@parameters:

	*/		
	public void doConnection(){
		try{
		  //Register JDBC the driver
		  Class.forName("com.mysql.cj.jdbc.Driver").newInstance();

								   
		  System.out.println("Connecting to database...");
		   //Open a connection using the database credentials
		  conn = DriverManager.getConnection(DB_URL, USER, PASS);
		  
		  System.out.println("Creating statement...");
		  //Create an Statement object for performing queries and transations
		  stmt = conn.createStatement();
		  System.out.println("Statement Ok...");
		} catch(SQLException sqlex){
			sqlex.printStackTrace();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	/********
		closeConnection method
			Close the connection to the database
			@parameters:

	*/		
	public void closeConnection()
	{
		try{
			//close the statement object
			stmt.close();
			//close the connection to the database
			conn.close();
			}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	/***********
		doSelect method
			This method performs a query to the database
			@parameters:
				fields: list of fields to be projected from the tables
				tables: list of tables to be selected
				where: where clause
			@returns:
				ResulSet result containing the project tuples resulting from the query
	*/
	public ResultSet doSelect(String fields, String tables, String where){
		//Create a ResulSet
		ResultSet result=null;
		
		//Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + " where " + where + " ;";
		System.out.println(selectionStatement);
		
		try{
			//perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e){
			e.printStackTrace();
		}
		finally{
			//return results
			return result;
		}
	}
	/***********
		doSelect method
			This method performs a query to the database
			@parameters:
				fields: list of fields to be projected from the tables
				tables: list of tables to be selected
			@returns:
				ResulSet result containing the project tuples resulting from the query
	*/
	
	public ResultSet doSelect(String fields, String tables){
		//Create a ResulSet
		ResultSet result=null;
		
		//Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + ";";
		System.out.println(selectionStatement);
		
		try{
			//perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e){
			e.printStackTrace();
		}
		finally{
			//return results
			return result;
		}
	}
	
	/***********
		doSelect method
			This method performs a query to the database
			@parameters:
				fields: list of fields to be projected from the tables
				tables: list of tables to be selected
				where: where clause
				orderBy: order by condition
			@returns:
				ResulSet result containing the project tuples resulting from the query
	*/
	public ResultSet doSelect(String fields, String tables, String where, String orderBy){
		
		//Create a ResulSet
		ResultSet result=null;
		
		//Create the selection statement 
		String selectionStatement = "Select" + fields+ " from " + tables + " where " + where + " order by " + orderBy + ";";
		
		try{
			//perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e){
			e.printStackTrace();
		}
		finally{
			//return results
			return result;
		}
	}
	
	/***********
		doInsertion method
			This method performs an insertion to the database
			@parameters:
				values: values to be inserted 
				table: table to be updated
				
			@returns:
				boolean value: true: the insertion was ok, an error was generated
	*/
	
	public boolean doInsert(String table, String values)
	{
		boolean res=false;
		String charString ="INSERT INTO "+ table + " values (" + values +");";
		System.out.println(charString);
		//try to insert a record to the selected table
		try{
			 res=stmt.execute(charString);
			 System.out.println("MySQLCompleteConnector insertion: " + res);
			 
		}
		catch(Exception e)
		{
			
			e.printStackTrace();
		}
		finally{
			return res;
		}
			
	}
	
	/***********
		doUpdate method
			This method performs an update to the database
			@parameters:
				table: table to be updated
				setClause: SET clause with fields to update
				whereClause: WHERE clause
			@returns:
				int: number of rows affected
	*/
	public int doUpdate(String table, String setClause, String whereClause)
	{
		int rowsAffected = 0;
		String updateString = "UPDATE " + table + " SET " + setClause + " WHERE " + whereClause + ";";
		System.out.println(updateString);
		
		try{
			rowsAffected = stmt.executeUpdate(updateString);
			System.out.println("MySQLCompleteConnector update: " + rowsAffected + " rows affected");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			return rowsAffected;
		}
	}
	
	/***********
		doDelete method
			This method performs a deletion from the database
			@parameters:
				table: table to delete from
				whereClause: WHERE clause
			@returns:
				int: number of rows deleted
	*/
	public int doDelete(String table, String whereClause)
	{
		int rowsDeleted = 0;
		String deleteString = "DELETE FROM " + table + " WHERE " + whereClause + ";";
		System.out.println(deleteString);
		
		try{
			rowsDeleted = stmt.executeUpdate(deleteString);
			System.out.println("MySQLCompleteConnector delete: " + rowsDeleted + " rows deleted");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			return rowsDeleted;
		}
	}

}
