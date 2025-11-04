FROM ghcr.io/sagernet/sing-box

WORKDIR /var/lib

RUN mkdir -p /etc/sing-box

RUN touch /etc/sing-box/config.json

COPY start.sh /start.sh

RUN chmod +x /start.sh

ENTRYPOINT ["sh","/start.sh"]  

EXPOSE 8080
