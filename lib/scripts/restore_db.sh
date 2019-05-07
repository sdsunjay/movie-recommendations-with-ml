if [ -z "$1" ]
then
   echo Please enter path of your dump.sql file
   read x
else
   x=$1
fi
cat $x | docker exec -i movierecommendationswithml_db_1 psql -U postgres
