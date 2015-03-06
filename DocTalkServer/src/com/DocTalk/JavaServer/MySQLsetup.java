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
	private final static String passwordTableName = "docTalkPasswords";
	private static Connection messageConn = null;
	private static Statement massageStatment = null;
	private static Connection passwordConn = null;
	private static Statement passwordStatment = null;
	private final static String url="jdbc:mysql://localhost:3306/";
    final static int mySQLnameFieldSize = 35;
    
    
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
            System.out.println("result is: " + result);
            
            massageStatment.setCursorName("docTalkCursor");
            ResultSet res = massageStatment.executeQuery("SHOW DATABASES;");
            res.first();
            printResultSet(res);
            massageStatment.execute("USE " + dataBaseName + ";");
            //s.execute("DROP TABLE IF EXISTS " + messageTableName + ";");
            massageStatment.execute("CREATE TABLE IF NOT EXISTS " + messageTableName + " (id INT NOT NULL AUTO_INCREMENT, sender VARCHAR("+mySQLnameFieldSize+"), reciver VARCHAR("+mySQLnameFieldSize+"), message VARCHAR(1000), PRIMARY KEY (id) );");
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
            passwordStatment.execute("CREATE TABLE IF NOT EXISTS " + passwordTableName + " (id INT NOT NULL AUTO_INCREMENT, sender VARCHAR("+mySQLnameFieldSize+"), message VARCHAR(64), PRIMARY KEY (id) );");
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
	
	public String queryMessageTableByReciever(String reciever)
	{
		String res = null;
		try 
		{
			printResultSet(massageStatment.executeQuery("SHOW DATABASES;"));
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
	
	public boolean insertPassword(String[] args)
	{
		boolean sucsess = false;
		if(3 == args.length)
		{
			try {
				passwordStatment.executeUpdate("INSERT INTO " + passwordTableName + " (sender,message) VALUES ('" + args[1] + "','" + args[2] + "');" );
				printResultSet(passwordStatment.getResultSet());
				sucsess = true;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return sucsess;
	}
	
	public boolean insertMessage(String[] args)
	{
		boolean sucsess = false;
		if(4 == args.length)
		{
			try {
				massageStatment.executeUpdate("INSERT INTO " + messageTableName + " (sender,reciver,message) VALUES ('" + args[1] + "','" + args[2] + "','" + args[3] +"');" );
				printResultSet(massageStatment.getResultSet());
		//		s.execute("COMMIT;");
				sucsess = true;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return sucsess;
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
