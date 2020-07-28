docker exec -t movierecommendationswithml_db_1 pg_dump -U postgres -t reviews movierecommendationswithml_production > /home/deploy/dbbackup/tables/reviews.sql
docker exec -t movierecommendationswithml_db_1 pg_dump -U postgres -t categorizations movierecommendationswithml_production > /home/deploy/dbbackup/tables/categorizations.sql
docker exec -t movierecommendationswithml_db_1 pg_dump -U postgres -t movie_lists movierecommendationswithml_production > /home/deploy/dbbackup/tables/movie_lists.sql
docker exec -t movierecommendationswithml_db_1 pg_dump -U postgres -t companies movierecommendationswithml_production > /home/deploy/dbbackup/tables/companies.sql
docker exec -t movierecommendationswithml_db_1 pg_dump -U postgres -t movie_production_companies movierecommendationswithml_production > /home/deploy/dbbackup/tables/movie_production_companies.sql
docker exec -t movierecommendationswithml_db_1 pg_dump -U postgres -t movie_user_recommendations movierecommendationswithml_production > /home/deploy/dbbackup/tables/movie_user_recommendations.sql
docker exec -t movierecommendationswithml_db_1 pg_dump -U postgres -t movies movierecommendationswithml_production > /home/deploy/dbbackup/tables/movies.sql


