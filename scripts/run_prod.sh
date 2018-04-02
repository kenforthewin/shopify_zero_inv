#!/bin/bash
docker-compose -f docker-compose.prod.yml -f docker-compose.yml up --build -d
docker network connect hcr_esnet shopifyzeroinv_app_1
docker network connect hcr_esnet shopifyzeroinv_sidekiq_1
docker network connect nginx_network shopifyzeroinv_app_1