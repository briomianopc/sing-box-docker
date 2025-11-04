FROM ghcr.io/sagernet/sing-box

WORKDIR /var/lib

RUN mkdir -p /etc/sing-box

RUN touch /etc/sing-box/config.json

COPY start.sh /start.sh

RUN chmod +x /start.sh

RUN echo "sing-box run -C /etc/sing-box/config.json" >> /start.sh

ENTRYPOINT ["sh","/start.sh"]  

EXPOSE 8080
