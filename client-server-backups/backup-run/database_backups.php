<?php
$emailaddress = "emailaddress@testing.com";
$host="localhost"; // database host
$dbuser="username"; // database user name
$dbpswd="password"; // database password
$mysqldb="dbbname"; // name of database
$path = "/absolute/path/to/the/directory/where/you/want/the/backup/files/(no/trailing/slash)"; // full server path to the directory where you want the backup files (no trailing slash)
// modify the above values to fit your environment
$filename = $path . "/database-backup" . date("d") . ".sql";
if ( file_exists($filename) ) unlink($filename);
echo " /usr/bin/mysqldump --user=$dbuser --password=$dbpswd --host=$host $mysqldb > $filename";
system(" /usr/bin/mysqldump --user=$dbuser --password=$dbpswd --host=$host $mysqldb > $filename",$result);
echo '<br>';
echo $result;
$size = filesize($filename);
switch ($size) {
  case ($size>=1048576): $size = round($size/1048576) . " MB"; break;
  case ($size>=1024): $size = round($size/1024) . " KB"; break;
  default: $size = $size . " bytes"; break;
}
// $message = "The database backup for " . $mysqldb . " has been run.\n\n";
// $message .= "The return code was: " . $result . "\n\n";
// $message .= "The file path is: " . $filename . "\n\n";
// $message .= "Size of the backup: " . $size . "\n\n";
// $message .= "Server time of the backup: " . date(" F d h:ia") . "\n\n";
// mail($emailaddress, "Database Backup Message" , $message, "From: Website <>");
?>
