<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

//select *
$app->get('/user', function (Request $request, Response $response) {
    $conn = $GLOBALS['connect'];
    $sql = 'select * from users';
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

$app->get('/getUser/{user_id}', function (Request $request, Response $response, array $args) {
    $idx = $args['user_id'];
    $conn = $GLOBALS['connect'];
    $sql = 'select * from users where user_id = ?';
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

///login
$app->post('/login', function (Request $request, Response $response, array $args) {

    $conn = $GLOBALS['connect'];

    $body = $request->getBody();
    $bodyArr = json_decode($body, true);

    //Login
    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt = $conn->prepare("SELECT * FROM users WHERE user_email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if($result->num_rows == 1){

        $row = $result->fetch_assoc();
        $pass = $row["user_password"];
        $encrypted_pwd = md5($password);

        if($pass == $encrypted_pwd){
            $data = array();
    foreach ($result as $row) {
        array_push($data, $row);
    }
            $response->getBody()->write(json_encode($data));
            return $response->withHeader('Content-Type', 'application/json')->withStatus(200);

        } else {
            $data = ["success" => false, "error" => "Incorrect password"];
            $response->getBody()->write(json_encode($data));
            return $response->withHeader('Content-Type', 'application/json')->withStatus(200);
            echo json_encode('Incorrect password');
        }
    } else {
        $data = ["success" => false, "error" => "Email not found"];
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus(200);
        echo json_encode('Email not found');
    }
});

$app->post('/register', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $firstname = $_POST['firstname'];
    $lastname = $_POST['lastname'];
    $nickname = $_POST['nickname'];
    $phone = $_POST['phone'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $encrypted_pwd = md5($password);
    $sql = "SELECT * FROM users WHERE user_email = '$email'";

    $result = mysqli_query($conn, $sql);
    $count = mysqli_num_rows($result);

    if ($count > 0) {
        echo json_encode('Error');
    } else {
        $sql = 'insert into users (user_email, user_password, user_firstname, user_lastname, user_nickname, user_phone) values (?, ?, ?, ?, ?, ?)';
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('ssssss', $email, $encrypted_pwd, $firstname, $lastname, $nickname, $phone);
        $stmt->execute();
        $affected = $stmt->affected_rows;

        $data = ["affected_rows" => $affected, "last_idx" => $conn->insert_id];
        $response->getBody()->write(json_encode($data));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(200);

        echo json_encode('Success');
    }
});

$app->post('/registerImg', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $firstname = $_POST['firstname'];
    $lastname = $_POST['lastname'];
    $nickname = $_POST['nickname'];
    $phone = $_POST['phone'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $image = $_POST['image'];

    $encrypted_pwd = md5($password);
    $sql = "SELECT * FROM users WHERE user_email = '$email'";

    $result = mysqli_query($conn, $sql);
    $count = mysqli_num_rows($result);

    if ($count > 0) {
        echo json_encode('Error');
    } else {
        $sql = 'insert into users (user_email, user_password, user_firstname, user_lastname, user_nickname, user_phone, user_img) values (?, ?, ?, ?, ?, ?, ?)';
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('sssssss', $email, $encrypted_pwd, $firstname, $lastname, $nickname, $phone, $image);
        $stmt->execute();
        $affected = $stmt->affected_rows;

        $data = ["affected_rows" => $affected, "last_idx" => $conn->insert_id];
        $response->getBody()->write(json_encode($data));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(200);

        echo json_encode('Success');
    }
});

$app->post('/editToken', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $userid = $_POST['userid'];
    $token = $_POST['token'];

    $sql = "UPDATE users SET token = '".$token."' WHERE user_id = '".$userid."'";
    $result = mysqli_query($conn, $sql);
    $arr=[];
    if($result)
        echo 'Success';
    else{
        echo 'Fail';
    }
});

?>