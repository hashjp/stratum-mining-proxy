FROM archlinux

RUN useradd -r -m -g users proxy

WORKDIR /home/proxy

RUN pacman -Sy --noconfirm  --needed base-devel git python2-pip vim python2-virtualenv

USER proxy

RUN git clone https://github.com/braiins/stratum-mining-proxy.git && \
    git clone https://github.com/braiins/stratum.git

RUN pip2 install --user ./stratum

EXPOSE 3333

ENTRYPOINT ["python2", "stratum-mining-proxy/mining_proxy.py", "--enable-stratum-extensions"]
