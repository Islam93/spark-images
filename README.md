##### spark-images

###### контейнеры со spark'ом:
- `spark_and_hadoop.dockerfile` -- отдельно установленные spark и hadoop
- `spark_with_hadoop.dockerfile` -- spark с hadoop'ом на борту

###### запуск:
- `spark_and_hadoop.dockerfile` -- команды `make spark-and-hadoop-run`, затем `make spark-and-hadoop-exec`
- `spark_with_hadoop.dockerfile` -- команды `make spark-with-hadoop-run`, затем `make spark-with-hadoop-exec`