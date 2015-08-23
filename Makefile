PATH := node_modules/.bin:$(PATH)
SHELL := /bin/bash

configure:
	@npm install

build:
	@mkdir -p dist
	@coffee -c -o dist src/fbfriends.coffee
	@uglifyjs -o dist/fbfriends.min.js dist/fbfriends.js
	@lessc src/fbfriends.less > dist/fbfriends.css
