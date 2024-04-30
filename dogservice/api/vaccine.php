<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

$app->get('/getVaccine', function (Request $request, Response $response) {
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT * FROM vaccine';
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = array();
    foreach ($result as $row) {
        array_push($data, $row);
    }

    $response->getBody()->write(json_encode($data));
    return $response;
});

$app->get('/getVaccineSched', function (Request $request, Response $response) {
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT * FROM vaccineschedule';
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = array();
    foreach ($result as $row) {
        array_push($data, $row);
    }

    $response->getBody()->write(json_encode($data));
    return $response;
});

$app->get('/getVaccineSched/{dog_id}', function (Request $request, Response $response, array $args) {
    $idx = $args['dog_id'];
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT vacsched_id, vacsched_name, vacsched_detail, DATE_FORMAT(vacsched_date, "%d/%m/%Y") AS vacsched_date, DATE_FORMAT(vacsched_time, "%H:%i") AS vacsched_time
    FROM vaccineschedule 
    WHERE dog_id = ?
    ORDER BY vacsched_date';

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

$app->post('/addVaccine', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $dogid = $_POST['dogid'];
    $name = $_POST['name'];
    $detail = $_POST['detail'];
    $date = $_POST['date'];
    $time = $_POST['time'];


    $sql = "INSERT into vaccineschedule (dog_id, vacsched_name, vacsched_detail, vacsched_date, vacsched_time) values ('$dogid', '$name', '$detail', '$date', '$time')";
    $result = mysqli_query($conn, $sql);
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->post('/editVaccine', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $vacschedid = $_POST['vacschedid'];
    $name = $_POST['name'];
    $detail = $_POST['detail'];
    $date = $_POST['date'];
    $time = $_POST['time'];


    $sql = "UPDATE vaccineschedule SET vacsched_name = '".$name."', vacsched_detail = '".$detail."', vacsched_time = '".$time."', vacsched_date = '".$date."' WHERE vacsched_id = '".$vacschedid."'";
    $result = mysqli_query($conn, $sql);
    $arr=[];
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->post('/deleteVaccine', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $vacschedid = $_POST['vacschedid'];
    $conn = $GLOBALS['connect'];

    $sql = "DELETE FROM vaccineschedule WHERE vacsched_id = '$vacschedid'";
    $result = mysqli_query($conn, $sql);
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});