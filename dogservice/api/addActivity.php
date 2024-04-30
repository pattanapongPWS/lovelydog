<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

use function PHPSTORM_META\type;

$app->post('/addActivity', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $dogid = $_POST['dogid'];
    $name = $_POST['name'];
    $type = $_POST['type'];
    $detail = $_POST['detail'];
    $date = $_POST['date'];
    $time = $_POST['time'];


    $sql = "INSERT into activity (dog_id, act_name, act_type, act_detail, act_date, act_time) values ('$dogid', '$name', '$type', '$detail', '$date', '$time')";
    $result = mysqli_query($conn, $sql);
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->post('/addActivityImg', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $dogid = $_POST['dogid'];
    $name = $_POST['name'];
    $type = $_POST['type'];
    $detail = $_POST['detail'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $image = $_POST['image'];


    $sql = "INSERT into activity (dog_id, act_name, act_type, act_detail, act_date, act_time, act_img) values ('$dogid', '$name', '$type', '$detail', '$date', '$time', '$image')";
    $result = mysqli_query($conn, $sql);
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->get('/getSched/{dog_id}', function (Request $request, Response $response, array $args) {
    $idx = $args['dog_id'];
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT act_id, act_name, act_type, act_detail, DATE_FORMAT(act_date, "%d/%m/%Y") AS act_date, DATE_FORMAT(act_time, "%H:%i") AS act_time, act_img 
    FROM activity 
    WHERE dog_id = ?
    ORDER BY act_date';

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

$app->post('/editActivity', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $actid = $_POST['actid'];
    $name = $_POST['name'];
    $type = $_POST['type'];
    $detail = $_POST['detail'];
    $date = $_POST['date'];
    $time = $_POST['time'];


    $sql = "UPDATE activity SET act_name = '".$name."', act_type = '".$type."', act_detail = '".$detail."', act_time = '".$time."', act_date = '".$date."' WHERE act_id = '".$actid."'";
    $result = mysqli_query($conn, $sql);
    $arr=[];
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->post('/editActivityImg', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $actid = $_POST['actid'];
    $name = $_POST['name'];
    $type = $_POST['type'];
    $detail = $_POST['detail'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $image = $_POST['image'];


    $sql = "UPDATE activity SET act_name = '".$name."', act_type = '".$type."', act_detail = '".$detail."', act_time = '".$time."', act_date = '".$date."', act_img = '".$image."' WHERE act_id = '".$actid."'";

    $result = mysqli_query($conn, $sql);
    $arr=[];
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->post('/deleteActivity', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $actid = $_POST['actid'];
    $conn = $GLOBALS['connect'];

    $sql = "DELETE FROM activity WHERE act_id = '$actid'";
    $result = mysqli_query($conn, $sql);
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

$app->get('/getSched/{dog_id}/{act_type}', function (Request $request, Response $response, array $args) {
    $idx = $args['dog_id'];
    $type = $args['act_type'];
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT act_id, act_name, act_type, act_detail, DATE_FORMAT(act_date, "%d/%m/%Y") AS act_date, DATE_FORMAT(act_time, "%H:%i") AS act_time, act_img 
    FROM activity 
    WHERE dog_id = ?
    AND act_type = ?
    ORDER BY act_date';

    $stmt = $conn->prepare($sql);
    $stmt->bind_param('is', $idx, $type);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = array();
    foreach ($result as $row) {
        array_push($data, $row);
    }
    $response->getBody()->write(json_encode($data));
    return $response;
});


//activity with Dog name
// SELECT activity.act_id, activity.act_name, activity.act_type, activity.act_detail, activity.act_date, activity.act_img, activity.dog_id, dogs.dog_name
// FROM activity
// inner join dogs on dogs.dog_id = activity.dog_id

// 'SELECT activity.act_id, activity.act_name, activity.act_type, activity.act_detail, activity.act_date, activity.act_img, activity.dog_id, dogs.dog_name
//     FROM activity
//     inner join dogs on dogs.dog_id = activity.dog_id
//     WHERE activity.dog_id = ?'