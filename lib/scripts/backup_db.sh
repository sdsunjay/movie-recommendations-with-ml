docker exec -t movierecommendationswithml_db_1 pg_dumpall -c -U postgres > /home/deploy/dbbackup/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
