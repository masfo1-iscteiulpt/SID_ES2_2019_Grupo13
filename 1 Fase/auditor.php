<?php

$url = 'localhost';
$username = "root";
$password = "123";
$conn = mysqli_connect($url, $username, $password);

if (!$conn) {
    die("ConnectionFailled: " . $conn->connect_error);
}

$sql = "SELECT * FROM auditor.".$_GET["table"];
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

echo "<form action='auditor.html'><input type='submit' value='Voltar'></form>";
echo "<h1>Tabela: ", $_GET["table"], "</h1>";
echo "<table border='1'>";
foreach ($rows as $value) {
    echo "<tr>";
    foreach ($value as $k => $v) {
        echo "<th>$k</th>";
    }
    echo "</tr>";
    break;
}
foreach ($rows as $value) {
    echo "<tr>";
    foreach ($value as $k => $v) {
        echo "<td>$v</td>";
    }
    echo "</tr>";
}
echo "</table>";

?>
