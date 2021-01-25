# Dockerfile
#Taken and edited from: https://forum.portfolio-performance.info/t/portfolio-performance-in-docker/10062 
# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.12-glibc

#AppIcon Link
ENV APP_ICON_URL=https://www.portfolio-performance.info/images/logo.png
# Set the name of the application.
ENV APP_NAME="Portfolio Performance"

#Install dependencies for getting portfolio
RUN apk --no-cache add ca-certificates wget curl && update-ca-certificates

#get Portfolio and unpack
RUN cd /opt && \
	curl -s https://api.github.com/repos/buchen/portfolio/releases/latest \
	| grep "browser_download_url.*linux.gtk.x86_64.tar.gz" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -qi - && \
	tar xvzf PortfolioPerformance-*-linux.gtk.x86_64.tar.gz && \
	rm PortfolioPerformance-*-linux.gtk.x86_64.tar.gz

#Install dependencies for getting portfolio
RUN \
	add-pkg \
	openjdk11-jre \
	gtk+3.0

RUN \
	sed -i '1s;^;-configuration\n/config/portfolio/configuration\n-data\n/config/portfolio/workspace\n;' /opt/portfolio/PortfolioPerformance.ini && \
	install_app_icon.sh "$APP_ICON_URL"

# Copy the start script.
COPY startapp.sh /startapp.sh


