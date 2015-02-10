package com.DocTalk.JavaServer;

import java.io.*;
import java.net.*;

public class Client 
{
	public void run(String[] args) throws Exception
	{
		System.out.println("Ready to send message to server");
		String sentence;
		String modifiedSentence;
		BufferedReader inFromUser = new BufferedReader( new InputStreamReader(System.in));
		//System.out.println("knock knock");
		Socket clientSocket = null;
		if(2<=args.length)
		{
			clientSocket = new Socket("localhost", Integer.valueOf(args[1]));
		}
		else
		{
			clientSocket = new Socket("localhost", com.DocTalk.JavaServer.Server.PORT);
		}
		//System.out.println("knock knock");
		DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
		
		BufferedReader inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		sentence = inFromUser.readLine();
		outToServer.writeBytes(sentence + '\n');
		modifiedSentence = inFromServer.readLine();
		modifiedSentence = replaceSlashN(modifiedSentence);
		System.out.println("FROM SERVER: \n\t\t" + modifiedSentence);
		clientSocket.close();
	}
	
	private String replaceSlashN(String mystring)
	{
		String res = "";
		for(int i=0; i< mystring.length();i++)
		{
			char ch = mystring.charAt(i);
			res += ('\07' == ch) ? "\n\t\t" : ch;
		}		
		return res;
	}
}
