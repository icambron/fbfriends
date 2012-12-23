build:
	@node_modules/coffee-script/bin/coffee -c -o files src/fbfriends.coffee
	@node_modules/uglify-js/bin/uglifyjs files/fbfriends.js > files/fbfriends.min.js
	@node_modules/less/bin/lessc src/fbfriends.less > files/fbfriends.css
