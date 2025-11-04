FROM ghcr.io/sagernet/sing-box

WORKDIR /

COPY config.json /config.json

ENTRYPOINT ["sing-box","run","-C',"/config.json"]  

EXPOSE 8080
