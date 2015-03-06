package main;

import com.DocTalk.JavaServer.listener;


public class main 
{
	private static com.DocTalk.JavaServer.Server myServer= new com.DocTalk.JavaServer.Server();
	private static com.DocTalk.JavaServer.Client myTestClient= new com.DocTalk.JavaServer.Client();
	private static com.DocTalk.JavaServer.listener mylistener= new com.DocTalk.JavaServer.listener();
	private static final boolean DEBUG = true;
	
	
	public static void main(String[] args)
	{
		try
		{
			if(1<=args.length)
			{
				switch(args[0])
				{
				case "-s": case "--server":
					myServer.run(args);
					break;
				case "-c": case "--client":
					myTestClient.run(args);
					break;
				case "-l":
					//mylistener.run(args);
					mylistener.runHTTP(args);
				default:
					System.out.println("Unknown user input");
					usage();
					break;
				}
			}
			else
			{
				myServer.run(args);
			}
			
			System.out.println("Done");
		}
		catch( Exception e )
		{
			if(DEBUG) e.printStackTrace();
			System.out.println("An error occured. Shutting down");
		}
	}
		
	private static void usage()
	{
		System.out.println("java -jar Server.jar --server");
	}
}
