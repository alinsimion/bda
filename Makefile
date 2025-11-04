present_mongo:
	npm exec -c 'slidev "courses/mongo/slides.md" --port 3030'

present_rabbit:
	npm exec -c 'slidev "courses/rabbit_prom_grafana/slides.md" --port 3030'

present_elastic:
	npm exec -c 'slidev "courses/elastic_kibana/slides.md" --port 3030'

build_mongo:
	# --base /bda/mongo is the relative path for github pages
	npx slidev build courses/mongo/slides.md -o ../../dist/mongo --base /bda/mongo

build_rabbit:
	# --base /bda/rabbit_prom_grafana is the relative path for github pages
	rm -rf dist/rabbit_prom_grafana
	npx slidev build courses/rabbit_prom_grafana/slides.md -o ../../dist/rabbit_prom_grafana --base /bda/rabbit_prom_grafana
	cp -r courses/rabbit_prom_grafana/diagrams/* dist/rabbit_prom_grafana/assets/

build_elastic:
	# --base /bda/elastic_kibana is the relative path for github pages
	npx slidev build courses/elastic_kibana/slides.md -o ../../dist/elastic_kibana --base /bda/elastic_kibana

deploy:
	npx gh-pages -d dist