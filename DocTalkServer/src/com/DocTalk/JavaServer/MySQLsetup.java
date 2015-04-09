package com.DocTalk.JavaServer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class MySQLsetup 
{
	private final static boolean DEBUG = false;
	private final static String dataBaseName = "docTalk";
	private final static String messageTableName = "docTalkMessages";
	private final static String passwordTableName = "docTalkUsers";
	private static Connection messageConn = null;
	private static Statement massageStatment = null;
	private static Connection passwordConn = null;
	private static Statement passwordStatment = null;
	private final static String url="jdbc:mysql://localhost:3306/";
    final static int mySQLnameFieldSize = 35;
    final static int mySQLtimeFieldSize = 24;
    final static int mySQLurgencyFieldSize = 10;
    
    
	public static void setupMessageTables(String userName,String password)
	{
		
		try {
            // The newInstance() call is a work around for some
            // broken Java implementations

            Class.forName("com.mysql.jdbc.Driver").newInstance();
           
//            String userName="DocTalk";
//            String password="BantingandBest";
           
          //conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?" + "user=DocTalk&password=BantingandBest");
            setupStatment(userName,password);
            int result = massageStatment.executeUpdate("CREATE DATABASE IF NOT EXISTS " + dataBaseName);
            if(DEBUG) System.out.println("result is: " + result);
            
            massageStatment.setCursorName("docTalkCursor");
            ResultSet res = massageStatment.executeQuery("SHOW DATABASES;");
            res.first();
            if(DEBUG) printResultSet(res);
            massageStatment.execute("USE " + dataBaseName + ";");
            //s.execute("DROP TABLE IF EXISTS " + messageTableName + ";");
            massageStatment.execute("CREATE TABLE IF NOT EXISTS " + messageTableName + " (id INT NOT NULL AUTO_INCREMENT, sender VARCHAR("+mySQLnameFieldSize+"), reciver VARCHAR("+mySQLnameFieldSize+"), message VARCHAR(1000), time VARCHAR("+mySQLtimeFieldSize+"), urgency VARCHAR("+mySQLurgencyFieldSize+"), PRIMARY KEY (id) );");
            if(DEBUG)
            {
	            massageStatment.execute("SHOW TABLES;");
	            printResultSet(massageStatment.getResultSet());
	            massageStatment.executeQuery("SELECT * FROM " + messageTableName + ";");
	            printResultSet(massageStatment.getResultSet());
            }
      //      s.execute("COMMIT;");
            
        } catch (Exception ex) {
            // handle the error
        	ex.printStackTrace();
        	if(DEBUG) System.out.println("Error in MySQL server");
        }
	}
	
	public static void setupPasswordTable(String userName,String password)
	{
		
		try {
            // The newInstance() call is a work around for some
            // broken Java implementations

            Class.forName("com.mysql.jdbc.Driver").newInstance();
            passwordConn = DriverManager.getConnection(url,userName,password);
            passwordStatment = passwordConn.createStatement();
            int result = massageStatment.executeUpdate("CREATE DATABASE IF NOT EXISTS " + dataBaseName);
            if(DEBUG) System.out.println("result is: " + result);
            
            passwordStatment.setCursorName("docTalkPasswordCursor");
//            ResultSet res = massageStatment.executeQuery("SHOW DATABASES;");
//            res.first();
//            printResultSet(res);
            passwordStatment.execute("USE " + dataBaseName + ";");
//            passwordStatment.execute("CREATE TABLE IF NOT EXISTS " + passwordTableName + " (id INT NOT NULL AUTO_INCREMENT, sender VARCHAR("+mySQLnameFieldSize+"), message VARCHAR(64), PRIMARY KEY (id) );");
            passwordStatment.execute("CREATE TABLE IF NOT EXISTS " + passwordTableName + " (id INT NOT NULL AUTO_INCREMENT, username VARCHAR("+mySQLnameFieldSize+"), phonenumber VARCHAR(64), password VARCHAR(64), email VARCHAR(64), hospital VARCHAR(64), PRIMARY KEY (id) );");
            if(DEBUG)
            {
	            passwordStatment.execute("SHOW TABLES;");
	            printResultSet(passwordStatment.getResultSet());
            	passwordStatment.executeQuery("SELECT * FROM " + passwordTableName + ";");
            	printResultSet(passwordStatment.getResultSet());
            }
      //      s.execute("COMMIT;");
            
        } catch (Exception ex) {
            // handle the error
        	ex.printStackTrace();
        	if(DEBUG) System.out.println("Error in MySQL server");
        }
	}
	
	
	private static boolean setupStatment(String userName,String password)
	{
		boolean res = false;
		try {
			messageConn = DriverManager.getConnection(url,userName,password);
           massageStatment = messageConn.createStatement();
			res = true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
	
	public String queryMessageTable()
	{
		String res = null;
		try 
		{
			printResultSet(massageStatment.executeQuery("SHOW DATABASES;"));
			massageStatment.execute("USE " + dataBaseName + ";");
			massageStatment.execute("SELECT * FROM " + messageTableName + ";");
			res = resultSetToString(massageStatment.getResultSet());
			if(DEBUG) System.out.println("res set to \"" + res + "\"");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new String(res+'\n');
	}
	
	public String queryPasswordTable()
	{
		String res = null;
		try 
		{
			//printResultSet(passwordStatment.executeQuery("SHOW DATABASES;"));
			passwordStatment.execute("USE " + dataBaseName + ";");
			passwordStatment.execute("SELECT * FROM " + passwordTableName + ";");
			res = resultSetToString(passwordStatment.getResultSet());
			//if(DEBUG) System.out.println("res set to \"" + res + "\"");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new String(res+'\n');
	}
	
	public String queryPasswordTableByUser(String usrname, String password)
	{
		String res = null;
		try 
		{
			//printResultSet(passwordStatment.executeQuery("SHOW DATABASES;"));
			passwordStatment.execute("USE " + dataBaseName + ";");
			passwordStatment.execute("SELECT phonenumber, id, username FROM " + passwordTableName + " WHERE username = '"+ usrname +"' and password='"+password+"';");
			res = resultSetToString(passwordStatment.getResultSet());
			if(DEBUG) System.out.println("res set to \"" + res + "\"");
			if(res.equals(""))
			{
				if(DEBUG) System.out.println("no such user");
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new String(res+'\n');
	}
	
	public String updatePasswordTableByUser(String id,String password)
	{
		String res = "-1";
		try 
		{
			//printResultSet(passwordStatment.executeQuery("SHOW DATABASES;"));
			passwordStatment.execute("USE " + dataBaseName + ";");
			passwordStatment.execute("UPDATE " + passwordTableName + " SET password = '"+ password +"' WHERE id = '" + id +"';");
			passwordStatment.execute("SELECT password from " + passwordTableName + " WHERE id='" + id +"';");
			res = resultSetToString(passwordStatment.getResultSet());
			res = res.split("password ")[1].split("\\n")[0];
			if(DEBUG) System.out.println("res set to \"" + res + "\"");
			if(null!=res && res.equals(password))
			{
				//check that the password has been updated
				res = "1";
				
			}
			else
			{
				res = "0";
				if(DEBUG) System.out.println("no such user");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new String(res);
	}
	
	public String updateUserTableProfile(String[] brokenClientSentence)
	{
		String res = "-1";
		try 
		{
			//printResultSet(passwordStatment.executeQuery("SHOW DATABASES;"));
			passwordStatment.execute("USE " + dataBaseName + ";");
			
			String NOVALUESENT = "";
			
			String ID = brokenClientSentence[0];
			String name = brokenClientSentence[1];//getFieldByID("username",passwordTableName,brokenClientSentence[4]);
			String phoneNumber = brokenClientSentence[2];
			String email = brokenClientSentence[3];
			String hospital = brokenClientSentence[4];
			//System.out.println("\""+brokenClientSentence[3]+"\"");
			
//			name = brokenClientSentence[1].equals(NOVALUESENT)?name:brokenClientSentence[1];
//			phoneNumber = brokenClientSentence[2].equals(NOVALUESENT)?phoneNumber:brokenClientSentence[2];
//			email = brokenClientSentence[3].equals(NOVALUESENT)?email:brokenClientSentence[3];
//			hospital = brokenClientSentence[4].equals(NOVALUESENT)?hospital:brokenClientSentence[4];
			
			passwordStatment.execute("UPDATE " + passwordTableName + " SET username = '" + name + "' WHERE id = '" + ID +"';");
			passwordStatment.execute("UPDATE " + passwordTableName + " SET phonenumber = '" + phoneNumber + "' WHERE id = '" + ID +"';");
			passwordStatment.execute("UPDATE " + passwordTableName + " SET email = '" + email + "' WHERE id = '" + ID +"';");
			passwordStatment.execute("UPDATE " + passwordTableName + " SET hospital = '" + hospital + "' WHERE id = '" + ID +"';");

			res = "1";
						
//			if(null!=res && res.equals(password))
//			{
//				//check that the password has been updated
//				res = "1";
//				
//			}
//			else
//			{
//				res = "0";
//				if(DEBUG) System.out.println("no such user");
//			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new String(res);
	}
	
	private String getFieldByID(String field, String table, String id)
	{
		String ret = null;
		try {
			passwordStatment.execute("SELECT " + field + " from " + table + " WHERE id='" + id +"';");
			ret = resultSetToString(passwordStatment.getResultSet());
			if(DEBUG)
			{
				System.out.println("raw \"" + ret + "\"");
				System.out.println("field \"" + field + "\"");
				System.out.println("table \"" + table + "\"");
				System.out.println("id \"" + id + "\"");
			}
			ret = ret.split(field+" ")[1].split("\\n")[0];
			if(DEBUG) System.out.println("res set to \"" + ret + "\"");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ret;
	}
	
	public String queryMessageTableByReciever(String reciever)
	{
		String res = null;
		try 
		{
			//printResultSet(massageStatment.executeQuery("SHOW DATABASES;"));
			massageStatment.execute("USE " + dataBaseName + ";");
			massageStatment.execute("SELECT * FROM " + messageTableName + " WHERE reciver='" + reciever + "';");
			res = resultSetToString(massageStatment.getResultSet());
			if(DEBUG) System.out.println("res set to \"" + res + "\"");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new String(res+'\n');
	}
	
	public String queryPasswordTableBySender(String sender)
	{
		String res = null;
		try 
		{
			printResultSet(massageStatment.executeQuery("SHOW DATABASES;"));
			passwordStatment.execute("USE " + dataBaseName + ";");
			passwordStatment.execute("SELECT * FROM " + passwordTableName + " WHERE sender='" + sender + "';");
			res = resultSetToString(passwordStatment.getResultSet());
			if(DEBUG) System.out.println("res set to \"" + res + "\"");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new String(res+'\n');
	}
	
	/*
	 * send this function {username, phonenumber, password}
	 */
	public int insertPassword(String[] args)
	{
		int id=-1;
		if(4 == args.length)
		{
			try {
				passwordStatment.executeUpdate("INSERT INTO " + passwordTableName + " (username,phonenumber,password,email,hospital) VALUES ('" + args[0] + "','" + args[1] + "','" + args[2] + "','n/a','n/a');" );
				//printResultSet(passwordStatment.getResultSet());
				ResultSet idResultSet = massageStatment.getGeneratedKeys();
//				String key = resultSetToString(idResultSet);
//				if(DEBUG) System.out.println(key);
//				key = key.split("KEY ")[1];
//				key = key.split("\\n")[0];
//				if(DEBUG) System.out.println(key);
//				id = Integer.parseInt(key,10);
				id = 1;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return id;
	}
	
	public int insertMessage(String[] args)
	{
		//boolean sucsess = false;
		int id = -1;
		if(5 == args.length)
		{
			try {
				massageStatment.executeUpdate("INSERT INTO " + messageTableName + " (sender,reciver,message,time,urgency) VALUES ('" + args[0] + "','" + args[1] + "','" + args[2] + "','" + args[3] + "','" + args[4] +"');", Statement.RETURN_GENERATED_KEYS );
		//		printResultSet(massageStatment.getResultSet());
		//		s.execute("COMMIT;");
				ResultSet idResultSet = massageStatment.getGeneratedKeys();
				String key = resultSetToString(idResultSet);
				if(DEBUG) System.out.println(key);
				key = key.split("KEY ")[1];
				key = key.split("\\n")[0];
				if(DEBUG) System.out.println(key);
				id = Integer.parseInt(key,10);
				
		//		sucsess = true;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return id;
	}
	
	public boolean deleteMessage(String idNum)
	{
		boolean sucsess = false;
		try 
		{
			massageStatment.executeUpdate("DELETE FROM " + messageTableName + " WHERE id=" + idNum +";" );
	//		printResultSet(massageStatment.getResultSet());
	//		s.execute("COMMIT;");
			sucsess = true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sucsess;
	}
	
	private static String resultSetToString(ResultSet rs)
	{
		String result = "";
		if(null != rs) 
		{
			try
			{
				java.sql.ResultSetMetaData rsmd = rs.getMetaData();
				int colNum = rsmd.getColumnCount();
				while(rs.next())
				{
					for(int i = 1; i <= colNum; i++ )
					{
						if( i > 1 ) result += "| ";
						String colVal = rs.getString(i);
						result += rsmd.getColumnName(i) + " " + colVal;
					}
					result += "\n";
				}
			}
			catch(SQLException sqle)
			{
				sqle.printStackTrace();
				result = null;
			}
		}
		else
		{
			System.out.println("Attempted to print null ReturnSet");
			result = null;
		}
		return result;
	}
	
	public static void printResultSet(ResultSet rs)
	{
		String result = resultSetToString(rs);
		if(null != result) System.out.print(result);
	}
	
	public static int dropDatabase()
	{
		int result = 0;
		try {
			Statement s = messageConn.createStatement();
			result = s.executeUpdate("DROP DATABASE IF EXISTS " + dataBaseName);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//if(result && DEBUG) System.out.println(dataBaseName + " dropped");
		System.out.println("result is: " + result);
		return result;
	}
	
	public static void testJCBdriver()
	{/*
		try {
			
		    System.out.println("Loading driver...");
		    //Class.forName("com.mysql.jdbc.Driver");
		    //Class.forName("mysql-connector-java-5.0.8-bin.jar");
		    Class.forName("jdbc2_0-stdext.jar");
		    System.out.println("Driver loaded!");
		   
		} catch (ClassNotFoundException e) {
		    throw new RuntimeException("Cannot find the driver in the classpath!", e);
		} */
		
		try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            System.out.println("JDBC driver loaded");
        } catch (ClassNotFoundException e) {
            System.out.println(e.toString());
        } //Eclipse may auto-force some extra catch blocks here
		catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
