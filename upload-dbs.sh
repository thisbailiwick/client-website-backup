#!/usr/bin/env bash
#!/usr/bin/rclone

#Uses rclone (https://github.com/ncw/rclone) to sync any new files to box.com
#https://rclone.org/box/

cd $(dirname ./wr-backup/run_site.sh)
echo pwd

if pidof -o %PPID -x "upload-dbs.sh"; then
exit 1
fi
for PATH in $(find ./site-backups -type f -name '*.sql' -or -name '*.zip'); do
  PATHLOCAL=${PATH}
  PATH=${PATH/.\/}
  PATH=${PATH%/*}
  /usr/bin/rclone copy ${PATHLOCAL} 'box:Website Review/'${PATH} -v --box-upload-cutoff=50M
  echo $PATH
done
exit
