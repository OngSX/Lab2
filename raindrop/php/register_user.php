<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,VERIFY) VALUES ('$name','$email','$password','$phone','0')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
}
else
{
    echo "failed";
}

//http://www.albeeneko.com/raindrop/register_user.php?name=Neko&email=sxong1998@hotmail.com&phone=01949494959&password=123

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for RainDrop'; 
    $message = 'Please click the link to verify your email: http://www.albeeneko.com/raindrop/verify.php?email='.$useremail; 
    $headers = 'From: noreply@raindrop.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>