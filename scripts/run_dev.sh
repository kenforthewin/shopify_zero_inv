#!/bin/bash
docker-compose -f docker-compose.dev.yml -f docker-compose.yml up --build -d
docker network connect hcr_esnet shopifybucks_app_1
docker network connect hcr_esnet shopifybucks_sidekiq_1