<?php

	$username = $_GET['username'];
	$password = $_GET['password'];
	$id= $_GET['idCultura'];
	$url = 'localhost';
	$conn = mysqli_connect($url, $username, $password);

	if (!$conn) {
		die("ConnectionFailled: " . $conn->connect_error);
	}
	
	//criar nova stored procedure que devolve a informacao de uma cultura identificada pelo id
	$sql = "call select_cultura(".$id.");";
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