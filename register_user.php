<?php
include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['passowrd'];
$phone = $_POST['phone'];
$otp = rand(1000,9999);

$sqlregister = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,OTP) VALUES('$name','$email','$password','$phone','$otp')";

if($conn-> $mysqli->query($sqlregister) === TRUE){
    sendEmail($otp,$email);
    echo "success";
}else {
    echo "failed";
}

function sendEmail($otp,$email){
    $from = "noreply@bornforfish.com";
    $to = $email;
    $subject = "From BornForFish. Verify your account";
    $message = "Use the following link to verify your account :"."\n https://bornforfish07.com/bornforfish/php/verify_email.php?email=".$email."&key=".$otp;
    $headers = "From:".$from;
    mail($email,$subject,$message,$headers);
}

?>