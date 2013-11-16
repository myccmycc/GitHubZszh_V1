<?php
require 'includes/conn.php';//数据库连接的内容独立出去了
session_start();
$uid=$_SESSION['user'];
$sql="......";//省略读取过程
$album=DBarray($sql);//从数据库获取数组
$result=null;
if($album)
{
 foreach ($album AS $idx => $row)
    {
     $output .= "<album>";
     $output .= "<albumid>";
     $output .= $album[$idx]['albumid'];
     $output .= "</albumid>";
     $output .= "<coverurl>";
     $output .= $album[$idx]['coverurl'];
     $output .= "</coverurl>";
     $output .= "<albumname>";
     $output .= $album[$idx]['name'];
     $output .= "</albumname>";
     $output .= "</album>";
    }
}
print ($output);
?>