# TODO : Move all this make stuff into make.js

OVERRIDING=default

SRC_DIR = src
TEST_DIR = test

PREFIX = .
DIST_DIR = ${PREFIX}/dist

COMPILER = uglifyjs -nc --unsafe

HEADER = ${SRC_DIR}/f0xy.header.js

FILES = ${HEADER}\
	${SRC_DIR}/f0xy.main.js\
	${SRC_DIR}/f0xy.baseclass.js\
	${SRC_DIR}/f0xy.class.js\
	${SRC_DIR}/f0xy.static.js\
	${SRC_DIR}/f0xy.singleton.js\
	${SRC_DIR}/f0xy.notifications.js\

VER = $(shell cat version.txt)

F0XY = ${DIST_DIR}/f0xy.${VER}.js
F0XY_MIN = ${DIST_DIR}/f0xy.${VER}.min.js

DATE=$(shell git log -1 --pretty=format:%ad)

BRANCH=$(git symbolic-ref -q HEAD)
BRANCH=${branch_name##refs/heads/}
BRANCH=${branch_name:-HEAD}

m=0
b=0

all: core node

core: min docs
	@@echo "f0xy build complete."

f0xy: 
	@@echo "Building" ${F0XY}
	@@echo "Version:" ${VER}

	@@mkdir -p ${DIST_DIR}

	@@cat ${FILES} | \
		sed 's/@DATE/'"${DATE}"'/' | \
		sed 's/@VERSION/'"${VER}"'/' > ${F0XY};

	@@cat ${FILES} | \
		sed 's/@DATE/'"${DATE}"'/' | \
		sed 's/@VERSION/'"${VER}"'/' > ${PREFIX}/bin/f0xy.js;

min: f0xy
	@@${COMPILER} ${F0XY} > ${F0XY_MIN}

	@@cat ${HEADER} ${F0XY_MIN} | \
		sed 's/@DATE/'"${DATE}"'/' | \
		sed 's/@VERSION/'"${VER}"'/' > bin/tmp

	@@mv bin/tmp ${F0XY_MIN}

docs: f0xy
	node_modules/jsdoc-toolkit/app/run.js -c=${SRC_DIR}/jsdoc-conf.json

size: f0xy min
	@@gzip -c ${F0XY_MIN} > ${F0XY_MIN}.gz; \
	wc -c ${F0XY} ${F0XY_MIN} ${F0XY_MIN}.gz;
	@@rm ${F0XY_MIN}.gz; \

push_docs: docs
	cd gh-pages; git add .; \
	git commit -am "updated docs"; \
	git push origin gh-pages

node:
	@@node make.js