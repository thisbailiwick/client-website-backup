<?php
set_time_limit(600);
$path = "/absolute/path/to/the/directory/where/you/want/the/backup/files/(no/trailing/slash)"; // full server path to the directory where you want the backup file (no trailing slash)
$directory_to_backup = '/absolute/path/to/directory/to/be/backed/up';

$target = $path . "/site-backup.tar.gz";
if (file_exists($target)) {
	unlink($target);
}

for ($i = 0; $i < 10; $i++) {
	echo 'round ' . $i . '<br>';
	system('rm -rf ' . $path . '/site_' . $i);
}

# ideally backups are out of the public_html directory but some clients hosting companies have limitations. This example is within public_html
system("tar --create --preserve-permissions --gzip --exclude=" . $directory_to_backup . "/backups --file=" . $target . " " . $directory_to_backup, $result);

$size = filesize($target);
echo $size . ': size<br>';
if ($size > 1024) {
	//we need to split this up to fit the 5gb box.com filesize limit
	system("split --bytes=1024m --suffix-length=1 --numeric-suffix " . $path . "/site-backup.tar.gz " . $path . "/site_", $result);
	//delete the large over 5gb file, no longer needed.
	unlink($target);
}
?>
