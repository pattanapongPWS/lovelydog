<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

$app->post('/addPost', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $userid = $_POST['userid'];
    $text = $_POST['text'];
    $image = $_POST['image'];


    $sql = 'insert into posts (user_id, post_text, post_img) values (?, ?, ?)';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('iss', $userid, $text, $image);
    $stmt->execute();
    $affected = $stmt->affected_rows;

    $data = ["affected_rows" => $affected, "last_idx" => $conn->insert_id];
    $response->getBody()->write(json_encode($data));
    return $response
        ->withHeader('Content-Type', 'application/json')
        ->withStatus(200);

    echo json_encode('Success');
});

$app->post('/addPostText', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $userid = $_POST['userid'];
    $text = $_POST['text'];


    $sql = 'insert into posts (user_id, post_text) values (?, ?)';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('is', $userid, $text);
    $stmt->execute();
    $affected = $stmt->affected_rows;

    $data = ["affected_rows" => $affected, "last_idx" => $conn->insert_id];
    $response->getBody()->write(json_encode($data));
    return $response
        ->withHeader('Content-Type', 'application/json')
        ->withStatus(200);

    echo json_encode('Success');
});

$app->post('/addPostImg', function (Request $request, Response $response, $args) {
    $json = $request->getBody();
    $jsonData = json_decode($json, true);

    $conn = $GLOBALS['connect'];

    $userid = $_POST['userid'];
    $image = $_POST['image'];


    $sql = 'insert into posts (user_id, post_img) values (?, ?)';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('is', $userid, $image);
    $stmt->execute();
    $affected = $stmt->affected_rows;

    $data = ["affected_rows" => $affected, "last_idx" => $conn->insert_id];
    $response->getBody()->write(json_encode($data));
    return $response
        ->withHeader('Content-Type', 'application/json')
        ->withStatus(200);

    echo json_encode('Success');
});

$app->get('/getPost', function (Request $request, Response $response) {
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT posts.post_id, posts.post_text, posts.post_img, posts.post_like, posts.post_date, posts.user_id, users.user_nickname, users.user_img
    FROM posts
    inner join users on users.user_id = posts.user_id
    ORDER BY post_date DESC';
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

$app->get('/getPost/{user_id}', function (Request $request, Response $response, array $args) {
    $idx = $args['user_id'];
    $conn = $GLOBALS['connect'];
    $sql = 'SELECT posts.post_id, posts.post_text, posts.post_img, posts.post_like, posts.post_date, posts.user_id, users.user_nickname, users.user_img
    FROM posts
    inner join users on users.user_id = posts.user_id
    WHERE posts.user_id = ?
    ORDER BY post_date DESC';
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


// Post & User Join

// SELECT posts.post_id, posts.post_text, posts.post_img, posts.post_like, posts.post_date, posts.user_id, users.user_nickname, users.user_img
// FROM posts
// inner join users on users.user_id = posts.user_id