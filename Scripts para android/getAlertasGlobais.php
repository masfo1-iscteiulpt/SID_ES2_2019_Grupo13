<?php

	$url = "127.0.0.1";
	$database = "sid2019";
	$conn = mysqli_connect($url, $_POST['username'], $_POST['password'], $database);

	if (!$conn) {
		die("ConnectionFailled: " . $conn->connect_error);
	}

	$sql = "CALL getAlertasGlobais(".$_POST['date'].");";
	$result = mysqli_query($conn, $sql);
	$rows = array();

	if ($result) {
		if (mysqli_num_rows($result) > 0) {
			while ($r = mysqli_fetch_assoc($result)) {
				array_push($rows, $r);
			}
		}
	}

	mysqli_close($conn);
	return json_encode($rows);

?>
