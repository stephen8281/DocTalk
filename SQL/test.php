<?php

$username = "root";

$database = "testdb";

mysql_connect("localhost", $username);

@mysql_select_db($database) or die("Unable to find database");

//$name = $_GET["name"];
$name = isset($_GET['name']) ? $_GET['name'] : '';

//$message = $_GET["message"];
$message = isset($_GET['message']) ? $_GET['message'] : '';

$query = "INSERT INTO test VALUES ('', '$name', '$message')";

mysql_query($query) or die(mysql_error("error"));

mysql_close();

?>