<?php

$url = 'localhost';
$username = "root";
$password = "123";
$conn = mysqli_connect($url, $username, $password);

if (!$conn) {
    die("ConnectionFailled: " . $conn->connect_error);
}

ini_set('max_execution_time', 300);

$sql1 = "INSERT INTO auditor.cultura_log
         SELECT * FROM sid2019.cultura_log
         WHERE id > 
            (SELECT IF(MAX(id) != '', MAX(id), 0) FROM auditor.cultura_log);";

$sql2 = "INSERT INTO auditor.utilizador_log
         SELECT * FROM sid2019.utilizador_log
         WHERE id > 
            (SELECT IF(MAX(id) != '', MAX(id), 0) FROM auditor.utilizador_log);";

$sql3 = "INSERT INTO auditor.medicao_log
         SELECT * FROM sid2019.medicao_log
         WHERE id > 
            (SELECT IF(MAX(id) != '', MAX(id), 0) FROM auditor.medicao_log);";

$sql4 = "INSERT INTO auditor.sistema_log
         SELECT * FROM sid2019.sistema_log
         WHERE id > 
            (SELECT IF(MAX(id) != '', MAX(id), 0) FROM auditor.sistema_log);";

$sql5 = "INSERT INTO auditor.variavel_log
         SELECT * FROM sid2019.variavel_log
         WHERE id > 
            (SELECT IF(MAX(id) != '', MAX(id), 0) FROM auditor.variavel_log);";

$sql6 = "INSERT INTO auditor.variaveis_medidas_log
         SELECT * FROM sid2019.variaveis_medidas_log
         WHERE id > 
            (SELECT IF(MAX(id) != '', MAX(id), 0) FROM auditor.variaveis_medidas_log);";

echo "Starting migrations.<br>";

$start_time = strtotime("now");
$result1 = mysqli_query($conn, $sql1);
$result2 = mysqli_query($conn, $sql2);
$result3 = mysqli_query($conn, $sql3);
$result4 = mysqli_query($conn, $sql4);
$result5 = mysqli_query($conn, $sql5);
$result6 = mysqli_query($conn, $sql6);
$end_time = strtotime("now");

if ($result1) {
    echo "SUCCESS - cultura_log<br>";
} else {
    echo "FAILED - cultura_log<br>";
}

if ($result2) {
    echo "SUCCESS - utilizador_log<br>";
} else {
    echo "FAILED - utilizador_log<br>";
}

if ($result3) {
    echo "SUCCESS - medicao_log<br>";
} else {
    echo "FAILED - medicao_log<br>";
}

if ($result4) {
    echo "SUCCESS - sistema_log<br>";
} else {
    echo "FAILED - sistema_log<br>";
}

if ($result5) {
    echo "SUCCESS - variavel_log<br>";
} else {
    echo "FAILED - variavel_log<br>";
}

if ($result6) {
    echo "SUCCESS - variaveis_medidas_log<br>";
} else {
    echo "FAILED - variaveis_medidas_log<br>";
}

echo "Migrations completed.<br>";
echo "Time elapsed: ", $end_time - $start_time, " seconds.<br>";

mysqli_close($conn);

?>
