<?php

$url = 'localhost';
$username = "root";
$password = "123";
$conn = mysqli_connect($url, $username, $password);

if (!$conn) {
    die("ConnectionFailled: " . $conn->connect_error);
}

ini_set('max_execution_time', 300);

$sql1 = "INSERT INTO auditordb.log_consultas
         SELECT * FROM siddb.log_consultas
         WHERE idLog_Consultas > 
            (SELECT IF(MAX(idLog_Consultas) != '', MAX(idLog_Consultas), 0) FROM auditordb.log_consultas);";

$sql2 = "INSERT INTO auditordb.log_cultura
         SELECT * FROM siddb.log_cultura
         WHERE idCultura > 
            (SELECT IF(MAX(idCultura) != '', MAX(idCultura), 0) FROM auditordb.log_cultura);";

$sql3 = "INSERT INTO auditordb.log_investigador
         SELECT * FROM siddb.log_investigador
         WHERE idLog_Investigador > 
            (SELECT IF(MAX(idLog_Investigador) != '', MAX(idLog_Investigador), 0) FROM auditordb.log_investigador);";

$sql4 = "INSERT INTO auditordb.log_medicoes
         SELECT * FROM siddb.log_medicoes
         WHERE idMedicao > 
            (SELECT IF(MAX(idMedicao) != '', MAX(idMedicao), 0) FROM auditordb.log_medicoes);";

$sql5 = "INSERT INTO auditordb.log_sistema
         SELECT * FROM siddb.log_sistema
         WHERE idLog_Sistema > 
            (SELECT IF(MAX(idLog_Sistema) != '', MAX(idLog_Sistema), 0) FROM auditordb.log_sistema);";

$sql6 = "INSERT INTO auditordb.log_variavel
         SELECT * FROM siddb.log_variavel
         WHERE idVariavel > 
            (SELECT IF(MAX(idVariavel) != '', MAX(idVariavel), 0) FROM auditordb.log_variavel);";

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
    echo "SUCCESS - log_consultas<br>";
} else {
    echo "FAILED - log_consultas<br>";
}

if ($result2) {
    echo "SUCCESS - log_cultura<br>";
} else {
    echo "FAILED - log_cultura<br>";
}

if ($result3) {
    echo "SUCCESS - log_investigador<br>";
} else {
    echo "FAILED - log_investigador<br>";
}

if ($result4) {
    echo "SUCCESS - log_medicoes<br>";
} else {
    echo "FAILED - log_medicoes<br>";
}

if ($result5) {
    echo "SUCCESS - log_sistema<br>";
} else {
    echo "FAILED - log_sistema<br>";
}

if ($result6) {
    echo "SUCCESS - log_variavel<br>";
} else {
    echo "FAILED - log_variavel<br>";
}

echo "Migrations completed.<br>";
echo "Time elapsed: ", $end_time - $start_time, " seconds.<br>";

mysqli_close($conn);

?>