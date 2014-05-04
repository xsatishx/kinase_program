<?php

$fileName = $_FILES["uploaded_file"]["name"];//the files name takes from the HTML form
$fileTmpLoc = $_FILES["uploaded_file"]["tmp_name"];//file in the PHP tmp folder
$fileType = $_FILES["uploaded_file"]["type"];//the type of file 
$fileSize = $_FILES["uploaded_file"]["size"];//file size in bytes
$fileErrorMsg = $FILES["uploaded_file"]["error"];//0 for false and 1 for true
$target_path = "/usr/local/net/doc/netserv/actrec/psp_tool/KINASE_BIGPROGRAM/" . basename( $_FILES["uploaded_file"]["name"]); 

echo "file name: $fileName </br> temp file location: $fileTmpLoc<br/> file type: $fileType<br/> file size: $fileSize<br/> file upload target: $target_path<br/> file error msg: $fileErrorMsg<br/>";

//START PHP  Upload Error Handling---------------------------------------------------------------------------------------------------

    if(!$fileTmpLoc)//no file was chosen ie file = null
    {
        echo "ERROR: Please select a file before clicking submit button.";
        exit();
    }
    else
       
                if($fileErrorMsg == 1)//if file uploaded error key = 1 ie is true
                {
                    echo "ERROR: An error occured while processing the file. Please try again.";
                    exit();
                }


    //END PHP  Upload Error Handling---------------------------------------------------------------------------------------------------------------------


    //Place it into your "uploads" folder using the move_uploaded_file() function
    $moveResult = move_uploaded_file($fileTmpLoc, $target_path);

    //Check to make sure the result is true before continuing
    if($moveResult != true)
    {
        echo "ERROR: File not uploaded. Please Try again.";
        unlink($fileTmpLoc);//remove the uploaded file from the PHP temp folder

    }
    else
    {
        //Display to the page so you see what is happening 
        echo "The file named <strong>$fileName</strong> uploaded successfully.<br/><br/>";
        echo "It is <strong>$fileSize</strong> bytes.<br/><br/>";
        echo "It is a <strong>$fileType</strong> type of file.<br/><br/>";
        echo "The Error Message output for this upload is: $fileErrorMsg";
    }

system ("cp $fileName mspec");
system ("perl megaparser.pl mspec");
?>