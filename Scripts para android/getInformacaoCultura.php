<?php
	$url="127.0.0.1";
	$database="sid2019";
    	$conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	$sql = "call getInformacaoCultura(".$_POST['idCultura'].");";
	$result = mysqli_query($conn, $sql);
	$response["descricoes"] = array();
	if ($result){
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				$ad = array();
				$ad["nomeCultura"] = $r['NomeCultura'];
				$ad["descricaoCultura"] = $r['DescricaoCultura'];
				array_push($response["descricoes"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["descricoes"]);
	echo $json;
	mysqli_close ($conn);