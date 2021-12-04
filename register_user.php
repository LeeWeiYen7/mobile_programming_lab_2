<?php
include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['passowrd'];


$sqlregister = "INSERT INTO USER(NAME,EMAIL,PASSWORD,) VALUES('$name','$email','$password')";

if(mysqli_query($conn,$sqlregister)){
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
