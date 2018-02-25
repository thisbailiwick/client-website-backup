<?php
#this is only for clients whose site backup is less than 5gbs
#this is also an example of
$path = '/absolute/path/to/the/directory/where/you/want/the/backup/files/(no/trailing/slash)'; // full server path to the directory where you want the backup files (no trailing slash)
// modify the above values to fit your environment
$target = $path . '/site-backup' . '.tar.gz';
$directory_to_backup = '/absolute/path/to/directory/to/be/backed/up';
if (file_exists($target)) {
	unlink($target);
}

system("tar --create --preserve --gzip  --file=" . $target . " " . $directory_to_backup . " ", $result);