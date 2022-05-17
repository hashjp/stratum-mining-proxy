FROM python:2 AS compile-image

RUN apt-get update && apt-get install -y --no-install-recommends python-dev

WORKDIR /app
RUN git clone --depth 1 https://github.com/braiins/stratum.git

WORKDIR /app/stratum-mining-proxy
COPY . ./

WORKDIR /app/stratum-mining-proxy/midstatec
RUN make

WORKDIR /app/stratum-mining-proxy

RUN virtualenv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install ../stratum/ && pip install .

FROM python:2-alpine AS build-image
EXPOSE 3333
EXPOSE 8332

COPY --from=compile-image /opt/venv /opt/venv
COPY --from=compile-image  /app/stratum-mining-proxy /app/stratum-mining-proxy
WORKDIR /app/stratum-mining-proxy

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
ENTRYPOINT ["./mining_proxy.py"]
