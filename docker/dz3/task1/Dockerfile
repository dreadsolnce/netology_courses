FROM nginx:1.21.1
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN apt-get update && apt-get install vim -y
	
COPY ./index.html /usr/share/nginx/html/index.html
