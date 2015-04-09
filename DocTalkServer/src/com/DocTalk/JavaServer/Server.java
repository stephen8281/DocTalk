package com.DocTalk.JavaServer;

import java.io.*;
import java.math.BigInteger;
import java.net.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Server 
{
	static final int PORT = 12000;
	private static final boolean DEBUG = false;
	private MySQLsetup mySQLmessage = new MySQLsetup();
	private MySQLsetup mySQLpassowrds = new MySQLsetup();
	private static String userName="root";
    private static String password="ThyferraBactais!real";
    
	public void run(String[] args) throws Exception
	{
		
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
//		String userName = null;
//		String password = null;
		if(6<=args.length )
		{
			if(args[2].equals("-u"))
			{
			//	mySQLmessage;
				userName = args[3];
			}
			else if(args[4].equals("-u"))
			{
				userName = args[5];
			}
			if(args[2].equals("-p"))
			{
			//	mySQLmessage;
				password = args[3];
			}
			else if(args[4].equals("-p"))
			{
				password = args[5];
			}
		}
		welcomeSocket = new ServerSocket(myPort);
		if(DEBUG) System.out.println("The Server is listening on port " + myPort);
		else System.out.println("The Server is listening");
		mySQLmessage.setupMessageTables(userName,password);
		mySQLpassowrds.setupPasswordTable(userName,password);
		
		while(true)
		{
			Socket connectionSocket = welcomeSocket.accept();
			BufferedReader inFromClient = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
			DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());
			clientSentence = inFromClient.readLine();
			System.out.println("Received: " + clientSentence);
			//capitalizedSentence = clientSentence.toUpperCase() + '\n';
			capitalizedSentence = " \n";
			//server behavior here
			String[] brokenClientInput = clientSentence.split(" ", 4);
			switch(brokenClientInput[0])
			{
			case "r":
				if(2 > brokenClientInput.length)
				{
					capitalizedSentence = "\n";	//this prevents the receiver from hanging
					break;
				}
				capitalizedSentence = mySQLmessage.queryMessageTableByReciever(brokenClientInput[1]);
				String[] breakByLine = capitalizedSentence.split("\n");
				capitalizedSentence = "";
				for( int i=0; i<breakByLine.length ;i++)
				{
					String[] brokenLine = breakByLine[i].split("\\|");
					if(DEBUG) System.out.println(brokenLine[0]);
					String sender = brokenLine[1];
					String revciver = brokenLine[3];
					capitalizedSentence += sender + "|" + revciver + "\n";
					mySQLmessage.deleteMessage(brokenLine[0].split(" ")[1]);		//remove messages once delivered
				}
				
				capitalizedSentence = stripSlashN(capitalizedSentence) + '\n';
				break;
			case "i":
				if(checkNameLengths(brokenClientInput))
				{
					mySQLmessage.insertMessage(brokenClientInput);
					capitalizedSentence = "message inserted\n";
				}
				else
				{
					capitalizedSentence = "error inserting message\n";
				}
				break;
			case "q":
				//TODO: !!!remove this whole case for production!!!
				if(DEBUG)
				{
					capitalizedSentence = mySQLmessage.queryMessageTable();
					System.out.print("Message query result: \"" + capitalizedSentence + "\"\n");
					capitalizedSentence = stripSlashN(capitalizedSentence) + '\n';
					System.out.print("Sending: \"" + capitalizedSentence + "\"\n");
					
					System.out.print("Password query result: \"" + mySQLpassowrds.queryPasswordTable() + "\"\n");
					
				}
				break;
			case "p":
				if(null != brokenClientInput && checkNameLengths(brokenClientInput))
				{
					if(2 <= brokenClientInput.length)
					{	
						if(DEBUG) brokenClientInput[2] = hashString(brokenClientInput[2]);
						String[] tablePasswordHashLine = mySQLpassowrds.queryPasswordTableBySender(brokenClientInput[1]).split(" ");
						String clientHash = stripSlashN(brokenClientInput[2]+'\n');
						String serverHash = stripSlashN(tablePasswordHashLine[5]);
						if(clientHash.equals(serverHash))
						{
							capitalizedSentence = "password is good\n";
						}
						else
						{
							capitalizedSentence = "password hash does not match\n";
						}
						
					}
					else
					{
						if(DEBUG) System.out.println("bad message format");
						capitalizedSentence = "incorrect formatting";
					}
				}
				break;
			case "ip":
				if(checkNameLengths(brokenClientInput))
				{
					if(3 <= brokenClientInput.length)
					{	
						if(DEBUG) brokenClientInput[2] = hashString(brokenClientInput[2]);
						mySQLpassowrds.insertPassword(brokenClientInput);
						capitalizedSentence = "password hash inserted\n";
					}
					else
					{
						if(DEBUG) System.out.println("bad message format");
						capitalizedSentence = "incorrect formatting";
					}
				}
				break;
			case "d":
				//TODO: !!!remove this whole case for production!!!
				if(DEBUG) mySQLmessage.dropDatabase();
				break;
//			case "s":
//				pingMySQLServer();
//				break;
			case "h":
				if(2 <= brokenClientInput.length)
				{	
					capitalizedSentence = hashString(brokenClientInput[1]);
					if(DEBUG) System.out.println("hash computed");
				}
				else
				{
					if(DEBUG) System.out.println("bad message format");
					capitalizedSentence = "incorrect formatting";
				}
				break;
			default:
				break;
			}
			
			
			outToClient.writeBytes(capitalizedSentence);
		}
	}
	
//	private String stripOtherRecievers
	
	private String stripSlashN(String text)
	{
		String res = "";
		for(int i=0; i< text.length();i++)
		{
			char ch = text.charAt(i);
			res += ('\n' == ch) ? '\07' : ch;
		}
		return res;
	}
	
	private boolean checkNameLengths(String[] textInput)
	{
		boolean res = false;
		switch(textInput.length)
		{
		case 3:
			if(mySQLmessage.mySQLnameFieldSize >= textInput[1].length())
			{
				res = true;
			}
			break;
		case 4:
			if(mySQLmessage.mySQLnameFieldSize >= textInput[1].length() && mySQLmessage.mySQLnameFieldSize >= textInput[2].length())
			{
				res = true;
			}
			break;	
		default:
			break;
		}
		return res;
	}
	
	private void pingMySQLServer()
	{
		mySQLmessage.setupMessageTables(userName,password);
		//mySQLserver.testJCBdriver();
		//mySQLserver.dropDatabase();
	}
	
	private static String hashString(String text)
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
