@echo off

docker-compose start postgres
docker-compose start redis
docker-compose start worker
docker-compose start nginx
docker-compose up website
