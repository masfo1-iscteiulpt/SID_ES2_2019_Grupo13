<?php

	$username = $_GET['username'];
	$password = $_GET['password'];
	$url = 'localhost';
	$conn = mysqli_connect($url, $username, $password);

	if (!$conn) {
		die("ConnectionFailled: " . $conn->connect_error);
	}else{
		mysqli_close($conn);
		return json_encode(array());
	}

?>