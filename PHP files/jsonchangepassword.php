<?php

header('Content-type: application/json');
if($_POST) {
	$oldpassword   = $_POST['oldpassword'];
	$newpassword = $_POST['newpassword'];
	$updatedpassword   = $_POST['updatedpassword'];

	if($_POST['oldpassword']) {
		if ( $newpassword == $updatedpassword ) {

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

				//check to see if old password matches with the actual password in the sql database for select user
				$result = mysql_query("SELECT password FROM users WHERE id=".$_SESSION['user_id']." AND password = '".$oldpassword."'");
				if(!$result){
				echo "The username you entered does not exist or old password didn't match"; 	
				}

				else{

				$stmt = $mysqli->prepare("UPDATE users SET password = ? where username = ?")
				//$password = md5($password); 
				
				//try getting sha-256 to work
				//PORT 3306 DEFAULT ON XAMPP

				$password = hash("sha256", $password);
				$stmt->bind_param("ss", $password, $username);

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
					error_log("Password for '$username' succesfully changed."); //change line
					echo '{"success":1}';
				} else {
					echo '{"success":0,"error_message":"Password not changed."}';
				}
			}
			}
		} else {
			echo '{"success":0,"error_message":"Passwords do not match."}';
		}
	} else {
		echo '{"success":0,"error_message":"Invalid Username."}';
	}
}else {
	echo '{"success":0,"error_message":"Invalid Data."}';
}
?>
