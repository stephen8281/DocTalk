<?php

header('Content-type: application/json');
if($_POST) {
	$name   = $_POST['name'];
	$phonenumber = $_POST['phonenumber'];
	$email   = $_POST['email'];
	$hospital = $_POST['hospital'];

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
				$stmt = $mysqli->prepare("INSERT INTO users (name, phonenumber, email, hospital) VALUES (?, ?, ?, ?)");
				//$password = md5($password);
				
				//try getting sha-256 to work
				//PORT 3306 DEFAULT ON XAMPP

				//$password = hash("sha256", $password);
				$stmt->bind_param("ssss", $name, $phonenumber, $email, $hospital);

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
					echo '{"success":0,"error_message":"Could not update Contact Profile."}';
				}
			}
		} else {
			echo '{"success":0,"error_message":"ERROR"}';
		}
?>
