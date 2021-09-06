make-docs:
	jazzy --clean --author "Miguel de Icaza" --author_url https://tirania.org/ --github_url https://github.com/migueldeicaza/SkiaKit --github-file-prefix https://github.com/migueldeicaza/SkiaKit/tree/master --module-version master --root-url https://migueldeicaza.github.io/SwiftKit --output docs

download-payload:
	bash ./download-payload.sh

download-payload-linux:
	bash ./download-payload-linux.sh
