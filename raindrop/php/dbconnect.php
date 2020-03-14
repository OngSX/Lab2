<?php
$servername = "localhost";
$username   = "albeenek_raindropAdmin";
$password   = "^r#^[8me@EN1";
$dbname     = "albeenek_raindrop";

$conn = new mysqli($servername, $username, $password, $dbname);
if($conn->connect_error){
    die("Connection failed: ".$conn->connect_error);
}

?>