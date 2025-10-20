present:
	npm exec -c 'slidev "slides.md" --port 3030'

build:
	# --base /bda/mongo is the relative path for github pages
	npx slidev build courses/mongo/slides.md -o dist/mongo --base /bda/mongo