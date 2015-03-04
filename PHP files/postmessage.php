<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "chat";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

//$name = $_GET["name"];

$sender = isset($_GET['sender']) ? $_GET['sender'] : '';
$receiver = isset($_GET['receiver']) ? $_GET['receiver'] : '';

if(!isset($_GET['receiver'])||empty($_GET['receiver']))
{
	//echo "empty message";
}
else
{

	$message = isset($_GET['message']) ? $_GET['message'] : '';
	$time = isset($_GET['time']) ? $_GET['time'] : '';
	$urgency = isset($_GET['urgency']) ? $_GET['urgency'] : '';

	$sql = "INSERT INTO messageTable VALUES ('','$sender', '$receiver', '$message', '$time', '$urgency')";

	if (mysqli_query($conn, $sql)) {

	    //echo "New record created successfully";

		$sql2 = "SELECT * FROM messageTable WHERE messageID = (SELECT max(messageID) FROM messageTable)";
		$result = mysqli_query($conn,$sql2) or die(mysqli_error($conn));
		$num = mysqli_num_rows($result);
		$rows = array();
		while($r = mysqli_fetch_assoc($result))
		{
			$rows[] = $r;
		}
		echo json_encode($rows);


	} else {
	    //echo "Error: " . $sql . "<br>" . mysqli_error($conn);
	}
}




mysqli_close($conn);


?>