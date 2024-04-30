<?php 

// Database configuration
$dbHost = "localhost";
$dbUsername = "lovely";
$dbPassword = "dog1234";
$dbName = "lovelydog";

// Create database connection
$db = new mysqli($dbHost, $dbUsername, $dbPassword, $dbName);

if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}


?>