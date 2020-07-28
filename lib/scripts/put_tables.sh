#!/bin/bash
TEMP_PATH="/home/deploy/new_prod_tables/"
docker cp "${TEMP_PATH}categorizations.sql" movierecommendationswithml_db_1:/etc/.
docker cp "${TEMP_PATH}companies.sql" movierecommendationswithml_db_1:/etc/.
docker cp "${TEMP_PATH}movie_lists.sql" movierecommendationswithml_db_1:/etc/.
docker cp "${TEMP_PATH}movie_production_companies.sql" movierecommendationswithml_db_1:/etc/.
docker cp "${TEMP_PATH}movie_user_recommendations.sql" movierecommendationswithml_db_1:/etc/.
docker cp "${TEMP_PATH}reviews.sql" movierecommendationswithml_db_1:/etc/.
docker cp "${TEMP_PATH}movies.sql" movierecommendationswithml_db_1:/etc/.
