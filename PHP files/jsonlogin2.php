<?php

header('Content-type: application/json');
if($_POST) {
	$username   = $_POST['username'];
	$password   = $_POST['password'];

	if($username && $password) {

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
				if ($stmt = $mysqli->prepare("SELECT username FROM users WHERE username = ? and password = ?")) {

					/* bind parameters for markers */
					$stmt->bind_param("ss", $username, hash("sha256", $password));

					/* execute query */
					$stmt->execute();

					/* bind result variables */
					$stmt->bind_result($id);

					/* fetch value */
					$stmt->fetch();

					/* close statement */
					$stmt->close();

					$getPhoneNumber = "SELECT phonenumber FROM users WHERE username = '$username' ";
					$result = mysqli_query($mysqli,$getPhoneNumber);
					$row = mysqli_fetch_row($result);
					$phonenumber = $row[0];
				}

				/* close connection */
				$mysqli->close();

				if ($id) {
					error_log("User $username: password match.");
					//echo '{"success":1}';
					echo json_encode(array('success' => 1,'phonenumber' => $phonenumber));
				} else {
					error_log("User $username: password doesn't match.");
					echo '{"success":0,"error_message":"Invalid Username/Password"}';
				}
			}
	} else {
		echo '{"success":0,"error_message":"Invalid Username/Password."}';
	}
}else {
	echo '{"success":0,"error_message":"Invalid Data."}';
}
?>
