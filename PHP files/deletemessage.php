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



//$name = isset($_GET['name']) ? $_GET['name'] : '';
$messageID = isset($_GET['messageID']) ? $_GET['messageID'] : '';

// if(!isset($_GET['name'])||empty($_GET['name']))
// {
// 	echo "empty message";
// }
// else
// {
//$messageID = '36';
	//$message = isset($_GET['message']) ? $_GET['message'] : '';

	$sql = "DELETE FROM messageTable WHERE messageID=$messageID ";

	if (mysqli_query($conn, $sql)) {
	    echo "Record deleted";
	} else {
	    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
	}
//}
mysqli_close($conn);


?>