package com.DocTalk.JavaServer;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.sun.jndi.cosnaming.IiopUrl.Address;
import com.sun.net.httpserver.*;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
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

public class listener {
	
	static final int PORT = 12000;
	private static final boolean DEBUG = true;
	private MySQLsetup mySQLmessage = new MySQLsetup();
	private MySQLsetup mySQLpassowrds = new MySQLsetup();

	public void runHTTP(String[] args)
	{
		HttpServer server;
		try {
			server = HttpServer.create(new InetSocketAddress(PORT), 0);
	        server.createContext("/test", new MyHandler());
	        server.createContext("/postmessage", new MyHandler());
	        server.createContext("/readmessage", new MyHandler());
	        server.createContext("/deletemessage", new MyHandler());
	        server.setExecutor(null); // creates a default executor
	        server.start();
			InetSocketAddress address = server.getAddress();
			System.out.println("the server is listening to port " + address.getPort() );
			while(true){;}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("error starting server");
		}
		
	}
	
	static class MyHandler implements HttpHandler {
        public void handle(HttpExchange t) throws IOException {
        	System.out.println("connected");
        	
        	BufferedReader inFromClient = new BufferedReader(new InputStreamReader(t.getRequestBody()));
			//clientSentence = inFromClient.readLine();
			String clientSentence = "";
			int ch;
			
			do
			{
				ch = inFromClient.read();
				clientSentence += (char) ch;
				
			}while(-1 != ch);
			
			try
			{
			parseMessage(clientSentence);
			}
			catch(ArrayIndexOutOfBoundsException aiobe)
			{
				
			}
			
        	Map<String, Object> map = new LinkedHashMap<String, Object>();
			map.put("messageID", new Integer(43));
			//map.put("sender", payload[0] );?sender=Stephen&receiver=6047678065&message=Watt&time=Mar%2005,%202015%2014:42&urgency=Green
			map.put("sender", "6047678065");
			map.put("receiver", "Stephen");
			map.put("message", "Hello World");
			map.put("time", "Mar%2005,%202015%2014:42");
			map.put("urgency", "Green");
			
			//JSONObject jsonForClient = new JSONObject();
			String JSONforClient = JSONValue.toJSONString(map);
			if(DEBUG) System.out.println("JSON object sent to client \'" + JSONforClient +"\'");
			
            String response = JSONforClient;//"This is the response";
            t.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
	
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
	
	private String replaceUTFencoding(String data)
	{
		String retval = null;
		try {
			retval = URLDecoder.decode(data, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retval;
	}
	
	
	private static String[] parseMessage(String data) throws ArrayIndexOutOfBoundsException
	{
		//TODO: need to ensure that HTTP/ in the message dosent break this maybe use instenceOf( )
		String[] broken = data.split("HTTP/");
		String restOfPayload = broken[1];
		
		broken = broken[0].split("\\?",2);
		
		final int numOfFields = 5;
		broken = broken[1].split("&",numOfFields);	//pull out data fields
													//Sender
													//Receiver
													//message
													//time
													//Urgency
											
		for(int i=0;i<numOfFields;i++)
		{
			broken[i] = broken[i].split("=",2)[1];
		}
//		broken[0] = broken[0].split("=",2)[1];
//		broken[1] = broken[1].split("=",2)[1];
//		broken[2] = replaceUTFencoding(broken[2].split("=",2)[1]);
		String[] retval = new String[broken.length+1];
		for(int i=0;i<numOfFields;i++)
		{
			retval[i] = broken[i];
		}
//		retval[0] = broken[0];
//		retval[1] = broken[1];
//		retval[2] = broken[2];
		retval[3] = restOfPayload;
		
		if(DEBUG)
		{
			System.out.println("Sender: \""  + broken[0] + "\"");
			System.out.println("Reciver: \"" + broken[1] + "\"");
			System.out.println("Message: \"" + broken[2] + "\"");
			System.out.println("Time: \"" + broken[3] + "\"");
			System.out.println("Urgency: \"" + broken[4] + "\"");
		}
		return broken;
	}
	
	private String toHexVal(byte[] data)
	{
		
		return null;		
	}
	
}
