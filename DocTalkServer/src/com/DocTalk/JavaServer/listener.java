package com.DocTalk.JavaServer;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.mysql.jdbc.MysqlParameterMetadata;
import com.sun.jndi.cosnaming.IiopUrl.Address;
import com.sun.net.httpserver.*;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.BrokenBarrierException;

public class listener {
	
	static int PORT = 12000;
	private static boolean DEBUG = false;
	private static MySQLsetup mySQLmessage = new MySQLsetup();
	private static MySQLsetup mySQLusers = new MySQLsetup();
//	private static String userName="root";
//    private static String password="ThyferraBactais!real";
    
	public void runHTTP(String[] args)
	{
		HttpServer server;
		String userName="root";
	    String password="ThyferraBactais!real";
		if(3<=args.length)
		{
			userName = args[1];
			password = args[2];
		}
		if(4<=args.length)
		{
			if("-d".equals(args[3]))
			{
				DEBUG = true;
			}
			else
			{
				PORT = Integer.parseInt(args[3]);
			}
		}
		try {
			//setup connection to MySQL database
			mySQLmessage.setupMessageTables(userName,password);
			mySQLusers.setupPasswordTable(userName,password);
			
			//setup tcp server
			server = HttpServer.create(new InetSocketAddress(PORT), 0);
			//server.createContext("/test", new MyMessageReciverHandler());
	        server.createContext("/postmessage.php", new MyMessageReciverHandler());
	        server.createContext("/readmessage.php", new MyMessageQHandler());
	        server.createContext("/deletemessage.php", new MyMessageDeleteHandler());
	        server.createContext("/jsonsignup.php", new MySignupHandler());
	        server.createContext("/jsonlogin2.php", new MyLogInHandler());
	        server.createContext("/jsonpwchange.php", new MyChangePasswordHandler());
	        server.createContext("/profilesettings.php", new MyChangeProfileHandler());
	        server.setExecutor(null); // creates a default executor
	        while(true)
			{//use this loop to recover if the server stops
				server.start();
				InetSocketAddress address = server.getAddress();
				System.out.println("the server is listening to port " + address.getPort() );
				try
				{
					while(true){;}	//the server is running
				}
				catch(Exception e)
				{//error in server runtime
					e.printStackTrace();
					System.out.println("error while server running");
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			//this is only reached if an error occurs while setting up the server
			e.printStackTrace();
			System.out.println("error starting server");
		}
		
	}
	
	static class MyMessageReciverHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("connected to Message Reciver");
        	
        	BufferedReader inFromClient = new BufferedReader(new InputStreamReader(t.getRequestBody()));
        	String clientSentence = t.getRequestURI().getRawQuery();

			if(DEBUG)
			{
				System.out.println(clientSentence.length());
				System.out.println(clientSentence);
			}
			
			String[] brokenClientSentence = parseMessage(clientSentence,5);	//there are 5 items to retrive here
			//System.out.println("message parsed");
			brokenClientSentence[2] = cleanSQLInput(brokenClientSentence[2]);
//			brokenClientSentence[3] = replaceUTFencoding(brokenClientSentence[3]);
			if(DEBUG)
			{
				for(int i=0;i<brokenClientSentence.length;i++)
				{
					System.out.println(brokenClientSentence[i]);
				}
			}
			int id = -1;
			try
			{
				System.out.println("inserting message to database");
			
				id = mySQLmessage.insertMessage(brokenClientSentence);
			//	mySQLmessage.queryMessageTableByReciever(reciever);
				if(DEBUG) System.out.println("message inserted id is: "+id);
				
			}
			catch(ArrayIndexOutOfBoundsException aiobe)
			{
				System.out.println(aiobe.getStackTrace()[0]);
				System.out.println("ArrayIndexOutOfBoundsException");
				
			}
			catch(Exception e)
			{
				System.out.println(e.getStackTrace()[0]);
				System.out.println("exception caught in MyMessageReciverHandler");
				
			}
			
        	Map<String, Object> map = new LinkedHashMap<String, Object>();
//			map.put("messageID", new Integer(43));
//			map.put("sender", "6047678065");
//			map.put("receiver", "Stephen");
//			map.put("message", "Hello World");
//			map.put("time", "Mar%2005,%202015%2014:42");
//			map.put("urgency", "Green");
//			
        	map.put("messageID", id);
			map.put("sender", brokenClientSentence[0]);
			map.put("receiver", brokenClientSentence[1]);
			map.put("message", replaceUTFencoding(brokenClientSentence[2]));
			map.put("time", replaceUTFencoding(brokenClientSentence[3]));
			map.put("urgency", brokenClientSentence[4]);
			
			//JSONObject jsonForClient = new JSONObject();
			String JSONforClient = JSONValue.toJSONString(map);
			
            String response = "["+JSONforClient+"]";//"This is the response";
            if(DEBUG) System.out.println("JSON object sent to client \'" + response +"\'");
			t.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
	
	static class MyMessageQHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("connected to message handler ");
        	
        	BufferedReader inFromClient = new BufferedReader(new InputStreamReader(t.getRequestBody()));
			String clientSentence = "";
			//clientSentence = inFromClient.readLine();
			
//			int ch;
			//System.out.println(t.getRequestURI().getRawQuery());
			clientSentence = t.getRequestURI().getRawQuery();
			
			if(DEBUG)
			{
				System.out.println("\""+clientSentence+"\"");
			}
			String[] messages = null; 
			Map<String, String> largemap = new LinkedHashMap<String, String>();
        	String allMessages = "[";
			try
			{
				clientSentence = clientSentence.split("=")[1];
				messages = mySQLmessage.queryMessageTableByReciever(clientSentence).split("\\n");
				if(DEBUG) System.out.println(messages.length);
				for(int i=0;i<messages.length;i++)
	        	{
	        		//System.out.println("splitting on |");
					Map<String, String> map = new LinkedHashMap<String, String>();
					String[] parts = messages[i].split("\\| ");
					String id = parts[0].split(" ")[1];
					String sender = parts[1].split(" ")[1];
					String reciver =  parts[2].split(" ")[1];
					String message =  replaceUTFencoding(parts[3].split(" ")[1]);
					String time =  replaceUTFencoding(parts[4].split(" ")[1]);
					String urgency =  parts[5].split(" ")[1];
					if(DEBUG)
					{
						System.out.println("id \""+id+"\"");
						System.out.println("sender \""+sender+"\"");
						System.out.println("reciver \""+reciver+"\"");
						System.out.println("message \""+message+"\"");
						System.out.println("time \""+time+"\"");
						System.out.println("urgency \""+urgency+"\"");
					}
	        		map.put("messageID", id);
					map.put("sender", sender);
					map.put("receiver", reciver);
					map.put("message", message);
					map.put("time", time);
					map.put("urgency", urgency);
					//largemap.put(Integer.valueOf(i).toString(), JSONValue.toJSONString(largemap));//TODO: need to check what key value is needed
					allMessages += JSONValue.toJSONString(map);
					if(i+1 < messages.length)
					{
						allMessages += ",";
					}
					else
					{
						allMessages += "]";
					}
	        	}
			}
			catch(ArrayIndexOutOfBoundsException aiobe)
			{
				aiobe.printStackTrace();
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			
        	
        	try
        	{
			//JSONObject jsonForClient = new JSONObject();
			//String JSONforClient = JSONValue.toJSONString(largemap);
			String JSONforClient = allMessages;
			
            String response = JSONforClient;//"This is the response";
            if(DEBUG) System.out.println("JSON object sent to client \"" + response +"\"");
			t.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        	}
            catch(Exception e)
			{
            	System.out.println("error building json");
    			
				e.printStackTrace();
			}
        }
    }
	

	static class MyMessageDeleteHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("connected to message deletion");
        	
        	BufferedReader inFromClient = new BufferedReader(new InputStreamReader(t.getRequestBody()));
			//clientSentence = inFromClient.readLine();
			String clientSentence = t.getRequestURI().getRawQuery();
					
			if(DEBUG) System.out.println(clientSentence);
			clientSentence = clientSentence.split("=")[1];
			mySQLmessage.deleteMessage(clientSentence);
			
			
//            String response = JSONforClient;//"This is the response";
//            t.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = t.getResponseBody();
//            os.write(response.getBytes());
            os.close();
        }
    }
	
	static class MySignupHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("registering new user");
        	
        	BufferedReader inFromClient = new BufferedReader(new InputStreamReader(t.getRequestBody()));
        	boolean sucess = false;
        	String response = "{\"success\":0,\"error_message\":\"Username Exist.\"}";
        	String clientSentence = inFromClient.readLine();
			if(DEBUG)
			{
				System.out.println(clientSentence.length());
				System.out.println(clientSentence+"");
				
			}
			
			String[] brokenClientSentence = parseMessage(clientSentence,4);//4 items of intrest here
			if(DEBUG)
			{
				for(int i=0;i<brokenClientSentence.length;i++)
				{
					System.out.println(brokenClientSentence[i]);
				}
								
			}
			System.out.println("message parsed");
			brokenClientSentence[2] = cleanSQLInput(brokenClientSentence[2]);
			if(DEBUG)
			{
				for(int i=0;i<brokenClientSentence.length;i++)
				{
					System.out.println(brokenClientSentence[i]);
				}
			}
			int id = -1;
			if(userIsAllowed(brokenClientSentence[0]))
			{
				try
				{
					if(brokenClientSentence[2].equals(brokenClientSentence[3]))
					{
						System.out.println("inserting message to database");
					
						id = mySQLusers.insertPassword(brokenClientSentence);
					//	mySQLmessage.queryMessageTableByReciever(reciever);
						if(DEBUG) System.out.println("message inserted id is: "+id);
						if(-1!=id) sucess = true;
					}
					else
					{
						if(DEBUG)
						{
							System.out.println("passwords do not match");
							System.out.println(brokenClientSentence[2]);
							System.out.println(brokenClientSentence[3]);
						}
						
					}
				}
				catch(ArrayIndexOutOfBoundsException aiobe)
				{
					System.out.println(aiobe.getStackTrace()[0]);
					System.out.println("ArrayIndexOutOfBoundsException");
					
				}
				catch(Exception e)
				{
					System.out.println(e.getStackTrace()[0]);
					System.out.println("exception caught in MyMessageReciverHandler");
					
				}
			}
			System.out.println("sending responce to server");
			if(sucess)
			{
				response = "{\"success\":1}";//JSONforClient;//"This is the response";
			}
				
            t.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
	
	static class MyLogInHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("connected to Message Reciver");
        	
        	BufferedReader inFromClient = new BufferedReader(new InputStreamReader(t.getRequestBody()));
        //	String clientSentence = t.getRequestURI().getRawQuery();
        	String clientSentence = inFromClient.readLine();

			if(DEBUG)
			{
				System.out.println(clientSentence.length());
				System.out.println(clientSentence);
			}
			
			String[] brokenClientSentence = parseMessage(clientSentence,2);
			if(DEBUG) System.out.println("message parsed");
		//	brokenClientSentence[2] = cleanSQLInput(brokenClientSentence[2]);
//			for(int i=0;i<brokenClientSentence.length;i++)
//			{
//				System.out.println(brokenClientSentence[i]);
//			}
			int id = -1;
			String phoneNumber = null;
			String usrID = null;
			String usrName = null;
			String password = null;
			Integer success = new Integer(0);
			
			try
			{
				System.out.println("checking with registered users");
				usrName = brokenClientSentence[0];
				password = brokenClientSentence[1];
			//	id = mySQLmessage.insertMessage(brokenClientSentence);
				String users = mySQLusers.queryPasswordTableByUser(usrName,password);
				if(!users.equals("\n"))
				{
					String[] brokenUsr = users.split("\\n");
					brokenUsr = brokenUsr[0].split("\\|");
					phoneNumber = brokenUsr[0].split("phonenumber ")[1];
					usrID = brokenUsr[1].split("id ")[1];
					usrName = brokenUsr[2].split("username ")[1];
					success = new Integer(1);
					if(DEBUG) System.out.println("message inserted id is: "+id);
				}
				else
				{
					success = new Integer(0);
				}
			}
			catch(ArrayIndexOutOfBoundsException aiobe)
			{
				System.out.println(aiobe.getStackTrace()[0]);
				System.out.println("ArrayIndexOutOfBoundsException");
				
			}
			catch(Exception e)
			{
				System.out.println(e.getStackTrace()[0]);
				System.out.println("exception caught in MyMessageReciverHandler");
				
			}
			
        	Map<String, Object> map = new LinkedHashMap<String, Object>();
        	String JSONforClient = null;
			
        	map.put("success", success.toString());
			
        	if(1==success.intValue())
        	{
	        	map.put("phonenumber", phoneNumber);
				map.put("getuserid", usrID);
				map.put("getusername", usrName);
				JSONforClient = JSONValue.toJSONString(map);
        	}
        	else
        	{
        		//map.put("error_message","Invalid Username/Password");
        		JSONforClient = "{\"success\":0,\"error_message\":\"Invalid Username/Password\"}";
        	}
			//JSONObject jsonForClient = new JSONObject();
			if(DEBUG) System.out.println("JSON object sent to client \'" + JSONforClient +"\'");
			
            //String response = JSONforClient;//"This is the response";
            t.sendResponseHeaders(200, JSONforClient.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(JSONforClient.getBytes());
            os.close();
        }
    }
	
	static class MyChangePasswordHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("connected password change");
        	String response = "{\"success\":0,\"error_message\":\"Invalid Data.\"}";
        	String clientSentence = (new BufferedReader(new InputStreamReader(t.getRequestBody()))).readLine();

			if(DEBUG)
			{
				System.out.println(clientSentence.length());
				System.out.println(clientSentence);
				
			}
			
			String[] brokenClientSentence = parseMessage(clientSentence,4);//TODO: set this correctly
			//brokenClientSentence[0] = brokenClientSentence[0].split(" ")[2];
			if(DEBUG)
			{
				System.out.println("message parsed");
				System.out.println(brokenClientSentence[0]);
			}
			
			String id = "-1";
			if(brokenClientSentence[2].equals(brokenClientSentence[3]))
			{
				try
				{
					if(DEBUG) System.out.println("updating password");
				
					id = mySQLusers.updatePasswordTableByUser(brokenClientSentence[0], brokenClientSentence[2]);
					if(DEBUG) System.out.println("result is: "+id);
					
					response = "{\"success\":1}";				
				}
				catch(ArrayIndexOutOfBoundsException aiobe)
				{
					System.out.println(aiobe.getStackTrace()[0]);
					System.out.println("ArrayIndexOutOfBoundsException");
					
				}
				catch(Exception e)
				{
					System.out.println(e.getStackTrace()[0]);
					System.out.println("exception caught in MyMessageReciverHandler");
					
				}
			
			}
			else
			{
				if(DEBUG)
				{
					System.out.println("passwords do not match");
					System.out.println(brokenClientSentence[2]);
					System.out.println(brokenClientSentence[3]);
				}
				
				response = "{\"success\":0,\"error_message\":\"Passwords does not match.\"}";
			}
			
            //"{\"success\":1}";//JSONforClient;//"This is the response";
            t.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
	
	
	static class MyChangeProfileHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("connected to Profile change");
        	String response = "{\"success\":0,\"error_message\":\"Could not update Contact Profile.\"}";
        	String clientSentence = (new BufferedReader(new InputStreamReader(t.getRequestBody()))).readLine();
        	//clientSentence = t.getRequestURI().getRawQuery();
        	
			if(DEBUG)
			{
				System.out.println(clientSentence.length());
				System.out.println(clientSentence);
				
			}
			
			String[] brokenClientSentence = parseMessage(clientSentence,5);//TODO: set this correctly
			//brokenClientSentence[0] = brokenClientSentence[0].split(" ")[2];
			//System.out.println("sentence \"" + field + "\"");
			String ID = brokenClientSentence[0];
			String name = brokenClientSentence[1];
			String phoneNumber = brokenClientSentence[2];
			String email = brokenClientSentence[3];
			String hospital = brokenClientSentence[4];
			
//			System.out.println("message parsed");
//			for(int i=0;i<brokenClientSentence.length;i++)
//			{
//				System.out.println(brokenClientSentence[i]);
//			}
			
			String id = "-1";
			try
			{
				if(DEBUG) System.out.println("inserting message to database");
			
				id = mySQLusers.updateUserTableProfile(brokenClientSentence);
				if(DEBUG) System.out.println("result is: "+id);
				
				response = "{\"success\":1}";				
			}
			catch(ArrayIndexOutOfBoundsException aiobe)
			{
				System.out.println(aiobe.getStackTrace()[0]);
				System.out.println("ArrayIndexOutOfBoundsException");
			}
			catch(Exception e)
			{
				System.out.println(e.getStackTrace()[0]);
				System.out.println("exception caught in MyMessageReciverHandler");
			}
			
			//"{\"success\":1}";//JSONforClient;//"This is the response";
			t.sendResponseHeaders(200, response.getBytes().length);
			OutputStream os = t.getResponseBody();
			os.write(response.getBytes());
			os.close();
        }
	}
	
	/*
	public void run(String[] args) throws Exception
	{
		//?sender=Stephen&receiver=6047678065&message=Watt&time=Mar%2005,%202015%2014:42&urgency=Green
		String clientSentence;
		String capitalizedSentence;
		ServerSocket welcomeSocket;
		int myPort = 0;
		if(2<=args.length && ( args[0].equals("-s") || args[0].equals("--server")))
		{
			myPort = Integer.valueOf(args[1]);
		}
		else
		{
			myPort = PORT;
		}
		welcomeSocket = new ServerSocket(myPort);
		if(DEBUG) System.out.println("The Server is listening on port " + myPort);
		else System.out.println("The Server is listening");
		
		while(true)
		{
			Socket connectionSocket = welcomeSocket.accept();
			if(DEBUG) System.out.println("client connected");
			BufferedReader inFromClient = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
			DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());
			//clientSentence = inFromClient.readLine();
			clientSentence = "";
			int ch;
			
			do
			{
				ch = inFromClient.read();
				clientSentence += (char) ch;
				
			}while(-1 != ch);
			
			//System.out.println("Received: \"" + clientSentence + "\"");
			String[] payload = null;
			try
			{
				//System.out.println(clientSentence);
				//payload = parseMessage(clientSentence);
				//System.out.println(clientSentence);
			
			//capitalizedSentence = clientSentence.toUpperCase() + '\n';
			//capitalizedSentence = " \n";
			//server behavior here
			//String[] brokenClientInput = clientSentence.split(" ", 4);			
			Map<String, String> map = new LinkedHashMap<String, String>();
			map.put("messageID", (new Integer(42)).toString());
			//map.put("sender", payload[0] );?sender=Stephen&receiver=6047678065&message=Watt&time=Mar%2005,%202015%2014:42&urgency=Green
			map.put("sender", "6047678065");
			map.put("receiver", "Stephen");
			map.put("message", "Hello");
			map.put("time", "Mar%2005,%202015%2014:42");
			map.put("urgency", "Green");
			
			//JSONObject jsonForClient = new JSONObject();
			String JSONforClient = JSONValue.toJSONString(map);
			if(DEBUG) System.out.println("JSON object sent to client \"" + JSONforClient +"\"");
			
			outToClient.writeBytes(JSONforClient);
			if(DEBUG) System.out.println("reply sent to client");
			}
			catch(ArrayIndexOutOfBoundsException aioube)
			{
				outToClient.writeBytes("\n");
				System.out.println("aioube");
			}
			System.out.println("connection closed");
		}
	}
	*/
	private static String replaceUTFencoding(String data)
	{
		String retval = null;
		char ch;
		for(int i=0;i<data.length();i++)
		{
			ch = data.charAt(i);
			if('%'==ch &&'2'==data.charAt(i+1)&&'7'==data.charAt(i+2))
			{
				retval += "\'";
				i+=2;
			}
			else
			{
				retval += ch;
			}
			
		}
		
		try {
			retval = URLDecoder.decode(data, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retval;
	}
	
	
	static boolean userIsAllowed(String string) {
		// TODO Auto-generated method stub
		//check if a usr atempting to register is allowed to
		return true;
	}


	private static String[] parseMessage(String data, int fields) throws ArrayIndexOutOfBoundsException
	{
		//TODO: need to ensure that HTTP/ in the message dosent break this maybe use instenceOf( )
		String[] broken ;//= data.split("HTTP/");
//		String restOfPayload = broken[1];
		
//		broken = broken[0].split("\\?",2);		//only want to do this on the first occurrence of '?' or risk breaking up the message
		
		//final int numOfFields = 5;				//TODO: should check to see if '&' in the message breaks this
		broken = data.split("&",fields);	//pull out data fields
													//Sender
													//Receiver
													//message
													//time
													//Urgency
											
		for(int i=0;i<fields;i++)
		{	//remove the field name from all entries
			broken[i] = broken[i].split("=",2)[1];	//<catagory>=<value>
			if(DEBUG) System.out.println(broken[i]);
		}
		
//		if(DEBUG&&(5==broken.length))
//		{
//			System.out.println("Sender: \""  + broken[0] + "\"");
//			System.out.println("Reciver: \"" + broken[1] + "\"");
//			System.out.println("Message: \"" + broken[2] + "\"");
//			System.out.println("Time: \"" 	 + broken[3] + "\"");
//			System.out.println("Urgency: \"" + broken[4] + "\"");
//		}
		return broken;
	}
	
	private static String cleanSQLInput(String text)
	{
		String retval = "";
		char ch;
		for(int i=0;i<text.length();i++)
		{
			ch = text.charAt(i);
			switch(ch)
			{
			case '\'':
				retval += "%27";
				break;
			default :
				retval += ch;
			}
			
		}
		return retval;
	}
	
	private String toHexVal(byte[] data)
	{
		
		return null;		
	}
	
	private static String SHA256hashString(String text)
	{
		MessageDigest md;
		String retval = null;
		try {
			md = MessageDigest.getInstance("SHA-256");
			if(DEBUG) System.out.println("updating digest");
			md.update(text.getBytes());
			if(DEBUG) System.out.println("digesting text");
			byte[] hash = md.digest();
	        BigInteger bigInt = new BigInteger(1, hash);
	        retval = bigInt.toString(16);
	        while ( retval.length() < 32 ) {
	            retval = "0" + retval; //the hash should be 32 bytes long. if the most significant bytes are zero we need to replace them
	        }
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retval.toUpperCase() + '\n';
	}
	
}
