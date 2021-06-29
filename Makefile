all: init

start:
	@echo "Starting BAE containers..."
	@cd ./db && docker compose up -d && echo "Waiting 30s..." && sleep 30
	@cd ./apis && docker compose up -d && echo "Waiting 30s..." && sleep 30
	@cd ./rss && docker compose up -d && echo "Waiting 30s..." && sleep 30
	@cd ./charging-proxy && docker compose up -d && echo "All containers started"

stop:
	@echo "Stopping BAE containers..."
	@cd ./charging-proxy && docker compose down
	@cd ./rss && docker compose down
	@cd ./apis && docker compose down
	@cd ./db && docker compose down && echo "All containers stopped"

init:
	-docker network create -d bridge marketplace
	mkdir -p ./db/mongo-data
	mkdir -p ./db/mysql-data
	mkdir -p ./charging-proxy/charging-bills
	mkdir -p ./charging-proxy/charging-assets
	mkdir -p ./charging-proxy/charging-plugins
	mkdir -p ./charging-proxy/charging-inst-plugins
	mkdir -p ./charging-proxy/proxy-indexes
	mkdir -p ./charging-proxy/proxy-themes
	mkdir -p ./charging-proxy/proxy-static
	mkdir -p ./charging-proxy/proxy-locales

clean:
	docker network rm marketplace
	rm -rf ./db/mongo-data
	rm -rf ./db/mysql-data
	rm -rf ./charging-proxy/charging-bills
	rm -rf ./charging-proxy/charging-assets
	rm -rf ./charging-proxy/charging-plugins
	rm -rf ./charging-proxy/charging-inst-plugins
	rm -rf ./charging-proxy/proxy-indexes
	rm -rf ./charging-proxy/proxy-themes
	rm -rf ./charging-proxy/proxy-static
	rm -rf ./charging-proxy/proxy-locales

.PHONY: all init clean start
