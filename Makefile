LOCAL_MYSQL_DATA=/Users/jsalort/Documents/VPS/webapp_data/mysql

all:
	docker build --build-arg MYSQL_PWD="${MYSQL_PWD}" -t jsalort/uwsgi:latest .

run:
	docker run -it --name local-uwsgi --rm -p 7032:7032 --ip=0.0.0.0 -v ${LOCAL_MYSQL_DATA}:/var/lib/mysql jsalort/uwsgi:latest

