all: init

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

.PHONY: all init clean
