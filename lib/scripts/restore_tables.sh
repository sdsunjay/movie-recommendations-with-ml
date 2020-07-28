docker exec -t movierecommendationswithml_db_1 pg_restore -U postgres -d movierecommendationswithml_production -t companies /etc/companies.sql
