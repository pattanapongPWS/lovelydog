<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

$app->post('/adddog', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $userid = $_POST['userid'];
    $name = $_POST['name'];
    $gender = $_POST['gender'];
    $gene = $_POST['gene'];
    $weight = $_POST['weight'];
    $birthdate = date('Y-m-d', strtotime($_POST['birthdate']));
    $status = 'มีชีวิต';


    $sql = "INSERT into dogs (user_id, dog_name, dog_gender, dog_gene, dog_birth, dog_weight, dog_status) values ('$userid', '$name', '$gender', '$gene', '$birthdate', '$weight', '$status')";
    $result = mysqli_query($conn, $sql);
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->post('/adddogImg', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $userid = $_POST['userid'];
    $name = $_POST['name'];
    $gender = $_POST['gender'];
    $gene = $_POST['gene'];
    $weight = $_POST['weight'];
    $birthdate = date('Y-m-d',strtotime($_POST['birthdate']));
    $image = $_POST['image'];
    $status = 'มีชีวิต';


    $sql = "INSERT into dogs (user_id, dog_name, dog_gender, dog_gene, dog_birth, dog_weight, dog_img, dog_status) values ('$userid', '$name', '$gender', '$gene', '$birthdate', '$weight', '$image', '$status')";
    $result = mysqli_query($conn, $sql);
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->get('/getDog/{user_id}', function (Request $request, Response $response, array $args) {
    $idx = $args['user_id'];
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT * FROM dogs WHERE user_id = ?';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('i', $idx);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = array();
    foreach ($result as $row) {
        array_push($data, $row);
    }
    $response->getBody()->write(json_encode($data));
    return $response;
});