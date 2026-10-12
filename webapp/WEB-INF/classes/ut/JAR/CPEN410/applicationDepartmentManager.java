//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manages department operations for the Mini-ebay system
*/
public class applicationDepartmentManager{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationDepartmentManager(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		listAllDepartments method
			List all departments in the database
			@parameters:
			@returns:
				A ResultSet containing all departments
	*/
	public ResultSet listAllDepartments()
	{
		String fields, tables;
		
		tables = "department";
		fields = "DeptId, DeptName, Description";
		
		System.out.println("listing all departments...");
		
		return myDBConn.doSelect(fields, tables);
	}
	
	/*******
		getDepartmentById method
			Get a specific department by ID
			@parameters:
				deptId: the department ID
			@returns:
				A ResultSet containing the department
	*/
	public ResultSet getDepartmentById(int deptId)
	{
		String fields, tables, whereClause;
		
		tables = "department";
		fields = "DeptId, DeptName, Description";
		whereClause = "DeptId = " + deptId;
		
		System.out.println("getting department by id...");
		
		return myDBConn.doSelect(fields, tables, whereClause);
	}
	
	/*******
		addDepartment method
			Add a new department
			@parameters:
				deptName: the department name
				description: the department description
			@returns:
				boolean: true if insertion was successful
	*/
	public boolean addDepartment(String deptName, String description)
	{
		boolean res;
		String table, values;
		
		table = "department";
		values = "NULL, '" + deptName + "', '" + description + "'";
		
		res = myDBConn.doInsert(table, values);
		System.out.println("Department insertion result: " + res);
		
		return res;
	}
	
	/*******
		updateDepartment method
			Update a department
			@parameters:
				deptId: the department ID
				deptName: the new department name
				description: the new description
			@returns:
				int: number of rows affected
	*/
	public int updateDepartment(int deptId, String deptName, String description)
	{
		String table = "department";
		String setClause = "DeptName = '" + deptName + "', Description = '" + description + "'";
		String whereClause = "DeptId = " + deptId;
		
		return myDBConn.doUpdate(table, setClause, whereClause);
	}
	
	/*******
		deleteDepartment method
			Delete a department
			@parameters:
				deptId: the department ID
			@returns:
				int: number of rows deleted
	*/
	public int deleteDepartment(int deptId)
	{
		String table = "department";
		String whereClause = "DeptId = " + deptId;
		
		return myDBConn.doDelete(table, whereClause);
	}
	
	/*********
		close method
			Close the connection to the database.
			This method must be called at the end of each page/object that instatiates a applicationDepartmentManager object
			@parameters:
			@returns:
	*/
	public void close()
	{
		//Close the connection
		myDBConn.closeConnection();
	}

}
