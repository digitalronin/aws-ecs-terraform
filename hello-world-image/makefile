build:
	docker build -t digitalronin/nodejs-hello-world .

run:
	docker run --rm \
		-e PORT=3000 \
		-p 3000:3000 \
		--name foo \
		digitalronin/nodejs-hello-world
