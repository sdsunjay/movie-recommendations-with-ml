docker exec -t movierecommendationswithml_db_1 pg_dumpall -c -U postgres | gzip -c > /home/deploy/dbbackup/dump.sql.gz
name=$(date +%Y-%m-%d_%H:%M)
mv /home/deploy/dbbackup/dump.sql.gz "/home/deploy/dbbackup/dump_$name.sql.gz"
/home/deploy/Dropbox-Uploader/dropbox_uploader.sh -s -p upload "/home/deploy/dbbackup/dump_$name.sql.gz" movie-recommendations-with-ml-db
