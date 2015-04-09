<?php

header('Content-type: application/json');
if($_POST) {
	$id = $_POST['id'];
	$oldpassword = $_POST['oldpassword'];
	$updatedpassword = $_POST['updatedpassword'];
	$repeatedpassword   = $_POST['repeatedpassword'];

	if($_POST['oldpassword']) {
		if ( $updatedpassword == $repeatedpassword ) {

			$db_name     = 'authentication';
			$db_user     = 'root';
			$db_password = '';
			$server_url  = 'localhost';

			$mysqli = new mysqli('localhost', $db_user, $db_password, $db_name);

			/* check connection */
			if (mysqli_connect_errno()) {
				error_log("Connect failed: " . mysqli_connect_error());
				echo '{"success":0,"error_message":"' . mysqli_connect_error() . '"}';
			} else {
				$stmt = $mysqli->prepare("UPDATE users SET password = ? WHERE id = ?");
				//$password = md5($password);
				
				//try getting sha-256 to work
				//PORT 3306 DEFAULT ON XAMPP

				$password = hash("sha256", $repeatedpassword);
				$stmt->bind_param("ss", $password, $id);

				/* execute prepared statement */
				$stmt->execute();

				if ($stmt->error) {error_log("Error: " . $stmt->error); }

				$success = $stmt->affected_rows;

				/* close statement and connection */
				$stmt->close();

				/* close connection */
				$mysqli->close();
				error_log("Success: $success");

				if ($success > 0) {
					//error_log("User '$username' created.");
					echo '{"success":1}';
				} else {
					echo '{"success":0,"error_message":"Username Exist."}';
				}
			}
		} else {
			echo '{"success":0,"error_message":"Passwords does not match."}';
		}
	} else {
		echo '{"success":0,"error_message":"Invalid Username."}';
	}
}else {
	echo '{"success":0,"error_message":"Invalid Data."}';
}
?>
