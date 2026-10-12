//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

//Import hashing functions
import org.apache.commons.codec.*;

/******
	This class manages administrative operations for the Mini-ebay system
*/
public class applicationAdminManager{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationAdminManager(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		listAllUsers method
			List all users in the system
			@parameters:
			@returns:
				A ResultSet containing all users
	*/
	public ResultSet listAllUsers()
	{
		String fields, tables;
		
		tables = "usergood";
		fields = "UserName, Name, Telephone";
		
		System.out.println("listing all users...");
		
		return myDBConn.doSelect(fields, tables);
	}
	
	/*******
		getUserRoles method
			Get all roles assigned to a user
			@parameters:
				userName: the username
			@returns:
				A ResultSet containing the user's roles
	*/
	public ResultSet getUserRoles(String userName)
	{
		String fields, tables, whereClause;
		
		tables = "roleuser, role";
		fields = "roleuser.RoleId, role.RoleName, roleuser.dateAssign";
		whereClause = "roleuser.RoleId = role.RoleId AND roleuser.UserName = '" + userName + "'";
		
		System.out.println("getting user roles...");
		
		return myDBConn.doSelect(fields, tables, whereClause);
	}
	
	/*******
		addUser method
			Add a new user (admin version with role assignment)
			@parameters:
				userName, completeName, userPass, userTelephone, roleId
			@returns:
				boolean: true if user was added successfully
	*/
	public boolean addUser(String userName, String completeName, String userPass, String userTelephone, String roleId)
	{
		boolean res;
		String table, values, hashingValue;
		
		hashingValue = hashingSha256(userName + userPass);
		table = "usergood";
		values = "'" + userName + "', '" + hashingValue + "', '" + completeName + "', '" + userTelephone + "'";
		
		res = myDBConn.doInsert(table, values);
		System.out.println("User insertion result: " + res);
		
		// Add role to the new user
		if(!res) {
			table = "roleuser";
			values = "'" + userName + "', '" + roleId + "', CURDATE()";
			myDBConn.doInsert(table, values);
		}
		
		return res;
	}
	
	/*******
		deleteUser method
			Delete a user from the system
			@parameters:
				userName: the username to delete
			@returns:
				int: number of rows deleted
	*/
	public int deleteUser(String userName)
	{
		String table = "usergood";
		String whereClause = "UserName = '" + userName + "'";
		
		return myDBConn.doDelete(table, whereClause);
	}
	
	/*******
		assignRole method
			Assign a role to a user
			@parameters:
				userName: the username
				roleId: the role ID
			@returns:
				boolean: true if role was assigned successfully
	*/
	public boolean assignRole(String userName, String roleId)
	{
		boolean res;
		String table, values;
		
		table = "roleuser";
		values = "'" + userName + "', '" + roleId + "', CURDATE()";
		
		res = myDBConn.doInsert(table, values);
		System.out.println("Role assignment result: " + res);
		
		return res;
	}
	
	/*******
		removeRole method
			Remove a role from a user
			@parameters:
				userName: the username
				roleId: the role ID
			@returns:
				int: number of rows deleted
	*/
	public int removeRole(String userName, String roleId)
	{
		String table = "roleuser";
		String whereClause = "UserName = '" + userName + "' AND RoleId = '" + roleId + "'";
		
		return myDBConn.doDelete(table, whereClause);
	}
	
	/*********
		hashingSha256 method
			Generates a hash value using the sha256 algorithm.
			@parameters: Plain text
			@returns: the hash string based on the plainText
	*/
	private String hashingSha256(String plainText)
	{
		String sha256hex = org.apache.commons.codec.digest.DigestUtils.sha256Hex(plainText); 
		return sha256hex;
	}
	
	/*********
		close method
			Close the connection to the database.
			This method must be called at the end of each page/object that instatiates a applicationAdminManager object
			@parameters:
			@returns:
	*/
	public void close()
	{
		//Close the connection
		myDBConn.closeConnection();
	}

}
