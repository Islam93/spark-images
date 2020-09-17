spark-and-hadoop-build:
	docker build \
	-f spark_and_hadoop.dockerfile \
	--tag spark-and-hadoop .

spark-and-hadoop-run: spark-and-hadoop-stop spark-and-hadoop-build
	docker run --rm -itd \
		-p 4040:4040 \
		--name spark-and-hadoop \
		spark-and-hadoop

spark-and-hadoop-stop:
	docker stop spark-and-hadoop || true

spark-and-hadoop-exec:
	docker exec -it spark-and-hadoop bash



spark-with-hadoop-build:
	docker build \
	-f spark_with_hadoop.dockerfile \
	--tag spark-with-hadoop .

spark-with-hadoop-run: spark-with-hadoop-stop spark-with-hadoop-build
	docker run --rm -itd \
		-p 4040:4040 \
		--name spark-with-hadoop \
		spark-with-hadoop

spark-with-hadoop-stop:
	docker stop spark-with-hadoop || true

spark-with-hadoop-exec:
	docker exec -it spark-with-hadoop bash
