<?php

	$url = "127.0.0.1";
	$database = "sid2019";
	$conn = mysqli_connect($url, $_POST['username'], $_POST['password'], $database);
	$sql = "CALL getAlertasCultura(".$_POST['idCultura'].",".$_POST['date'].");";
	$result = mysqli_query($conn, $sql);
	$rows = array();

	$response["alertas"] = array();
	if ($result){
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				$ad = array();
				$ad["DataHora"] = $r['datahora'];
				$ad["NomeVariavel"] = $r['variavel'];
				$ad["LimiteInferior"] = $r['limiteInferior'];
				$ad["LimiteSuperior"] = $r['limiteSuperior'];
				$ad["ValorMedicao"] = $r['valor'];
				$ad["Descricao"] = $r['Descricao'];
				array_push($response["alertas"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["alertas"]);
	echo $json;
	mysqli_close ($conn);
?>
