FROM	ubuntu:20.04

ENV	TZ=Europe/Kiev

#Put your own certificates here
#COPY    Your_CA2.crt /usr/local/share/ca-certificates/
#COPY    Your_RootCA.crt /usr/local/share/ca-certificates/

RUN	ln -snf /usr/share/zoneinfo/$TZ  /etc/localtime && echo $TZ > /etc/timezone && \
	apt update && apt install -y apache2 libapache2-mod-security2 git && \
	a2enmod md && a2enmod ssl && a2enmod proxy && a2enmod proxy_http &&  a2ensite default-ssl &&  a2dissite 000-default.conf && \
	cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf && \
	update-ca-certificates && sed -i 's/SecRuleEngine\ DetectionOnly/SecRuleEngine On/g' /etc/modsecurity/modsecurity.conf

EXPOSE 80 443
CMD 	["apachectl","-D","FOREGROUND"]
HEALTHCHECK --start-period=15s --interval=10s --timeout=3s --retries=2    CMD pgrep apache2

