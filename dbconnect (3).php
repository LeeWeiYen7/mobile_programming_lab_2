<?php
$servername = "localhost";
$username   = "bornforf1";
$password   = "PPHtIM0Ln8p7";
$dbname     = "bornforf_bornforfish";

$conn = mysqli_connect($servername, $username, $password, $dbname);
if ($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);

}
?>
