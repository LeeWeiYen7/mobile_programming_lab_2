<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$otp = $_POST['otp'];

$sqllogin = "SELECT = FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$password'AND OTP = '$otp'";
$result = $conn-> query($sqllogin);

if($result-> num_rows > 0){
    while ($row = $result ->fetch_assoc()){
        echo $data = $row["NAME"].",".$row["PHONE"];
    }
}else{
    echo "failed";
    
}
?>