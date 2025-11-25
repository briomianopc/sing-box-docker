FROM ghcr.io/sagernet/sing-box

WORKDIR /

RUN mkdir -p /etc/sing-box

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV UUID="f4b1f1a5-5a5a-4b5a-8a8a-1a2b3c4d5e6f"
ENV WS_PATH="/laowang"

ENTRYPOINT ["/entrypoint.sh"]
