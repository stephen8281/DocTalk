<?php

// $username = "root";
// $database = "chat";

// mysql_connect("localhost", $username);

// @mysql_select_db($database) or die("Error");

// $receiver = isset($_GET['receiver']) ? $_GET['receiver'] : '';

// $query = "SELECT * FROM messageTable WHERE receiver ='$receiver'";

// $result = mysql_query($query) or die(mysql_error());

// $num = mysql_numrows($result);

// mysql_close();

// $rows = array();
// while($r = mysql_fetch_assoc($result))
// {
// 	//$r["date_string"] = date("D, M jS, Y @ g:i", $r['timestamp']);
// 	$rows[] = $r;
// }

// echo json_encode($rows);


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

$receiver = isset($_GET['receiver']) ? $_GET['receiver'] : '';

$sql = "SELECT * FROM messageTable WHERE receiver ='$receiver'";


$result = mysqli_query($conn,$sql) or die(mysqli_error($conn));

$num = mysqli_num_rows($result);



$rows = array();
while($r = mysqli_fetch_assoc($result))
{
	//$r["date_string"] = date("D, M jS, Y @ g:i", $r['timestamp']);
	$rows[] = $r;
}

echo json_encode($rows);

mysqli_close($conn);



?>