#!/usr/bin/env bash
#!/usr/bin/rclone

#Uses rclone (https://github.com/ncw/rclone) to sync any new files to box.com
#https://rclone.org/box/


BASEDIRECTORY=$(dirname ./wr-backup/upload-sites.sh)
if [ -d "$BASEDIRECTORY" ]; then
  cd $BASEDIRECTORY
fi

if pidof -o %PPID -x "upload-sites.sh"; then
exit 1
fi

{
  TZ=America/Los_Angeles date '+%F|%H:%M'>>./upload-sites.log
}
RED='\033[0;31m'
NC='\033[0m' # No Color

for PATH in $(find ./site-backups -type f -name '*.tar.gz' -or -name '*.split'); do
  PATHLOCAL=${PATH}
  PATH=${PATH/.\/}
  PATH=${PATH%/*}
  echo -en "\033[2K"
  echo -en "${RED}${PATH}${NC}\r"
  # echo "/usr/bin/rclone copy ${PATHLOCAL} 'box:Website Review/'${PATH} -v --box-upload-cutoff=50M --log-file=./upload-sites.log --low-level-retries=12\n\n"
  {
    /usr/bin/rclone copy ${PATHLOCAL} 'box:Website Review/'${PATH} -v --box-upload-cutoff=50M --log-file=./upload-sites.log --low-level-retries=12
  }
done
echo -en "\033[2K"
exit 0
