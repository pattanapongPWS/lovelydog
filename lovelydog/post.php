<?php 

    session_start();
    include_once 'dbConfig.php';
?>

<html>

<head>
    <link rel="stylesheet" href="style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@200&display=swap" rel="stylesheet">

    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PostPHP Upload Image System</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>

    <nav class="font">   
            <a style="color: white;" href="account.php">บัญชีผู้ใช้</a>
            <a style="color: white;" href="post.php">โพสต์ข้อมูลข่าวสาร</a>
            <a style="color: white;" href="notice.php">แจ้งเตือน</a>
    </nav>
</head>

<body>
    <div>
    <div class="container">
        <div class="row mt-5">
            <div class="col-12">
                <form action="upload.php" method="POST" enctype="multipart/form-data">
                    <div class="text-center justify-content-center align-items-center p-4 border-2 border-dashed rounded-3">
                        <h6 class="my-2">Select image file to upload</h6>
                        <input type="file" name="file" class="form-control streched-link" accept="image/gif, image/jpeg, image/png">
                        <p class="small mb-0 mt-2"><b>Note:</b> Only JPG, JPEG, PNG & GIF files are allowed to upload</p>
                    </div>
                    <div class="d-sm-flex justify-content-end mt-2">
                        <input type="submit" name="submit" value="Upload" class="btn btn-sm btn-primary mb-3">
                    </div>
                </form>
            </div>
        </div>
        <div class="row">
            <?php  if (!empty($_SESSION['statusMsg'])) { ?>
                <div class="alert alert-success" role="alert">
                    <?php 
                        echo $_SESSION['statusMsg']; 
                        unset($_SESSION['statusMsg']);
                        $firstname = $_REQUEST['file'];
                        echo $fileName;
                    ?>
                </div>
            <?php } ?>
        </div>

        <div class="row g-2">
            
            <?php 
            
            
                $query = $db->query("SELECT * FROM posts ORDER BY post_date DESC");
                if ($query->num_rows > 0) {
                    while($row = $query->fetch_assoc()) {
                        $imageURL = 'uploads/'.$row['post_date'];
                    ?>
                    <div class="col-sm-6 col-lg-4 col-xl-3">
                        <div class="card shadow h-100">
                            <img src="<?php echo $imageURL ?>" alt="" width="100%" class="card-img">
                        </div>
                    </div>
                <?php 
                    }
                } else { ?>
                <p>No image found...</p>
            <?php } ?>
        </div>
    </div>
    </div>
</body>

</html>