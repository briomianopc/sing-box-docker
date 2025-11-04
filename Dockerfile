FROM ghcr.io/sagernet/sing-box

WORKDIR /

RUN mkdir -p /etc/sing-box

COPY config.json /etc/sing-box/config.json

ENTRYPOINT ["sing-box", "run", "-C", "/etc/sing-box"]  

EXPOSE 8080
