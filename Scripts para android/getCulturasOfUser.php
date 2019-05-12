<?php

	$username = $_GET['username'];
	$password = $_GET['password'];
	$url = 'localhost';
	$conn = mysqli_connect($url, $username, $password);

	if (!$conn) {
		die("ConnectionFailled: " . $conn->connect_error);
	}
	
	$sql = "call select_culturas();";
	$result = mysqli_query($conn, $sql);
	$rows = array();
	if ($result) {
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				array_push($rows, $r);
			}
		}
	}
	mysqli_close ($conn);
	return json_encode($rows);

?>