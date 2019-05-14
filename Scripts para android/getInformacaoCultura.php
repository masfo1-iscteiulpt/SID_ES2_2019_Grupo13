<?php

	$username = $_GET['username'];
	$password = $_GET['password'];
	$id= $_GET['idCultura'];
	$url = 'localhost';
	$database = 'sid2019'
	$conn = mysqli_connect($url, $username, $password,$database);

	if (!$conn) {
		die("ConnectionFailled: " . $conn->connect_error);
	}
	
	$sql = "call getInformacaoCultura(".$id.");";
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