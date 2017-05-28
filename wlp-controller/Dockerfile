FROM ibmjava:8-jre

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
&& rm -rf /var/lib/apt/lists/*

ENV LIBERTY_VERSION 17.0.0_01
ARG LIBERTY_URL
ARG DOWNLOAD_OPTIONS=""
RUN LIBERTY_URL=${LIBERTY_URL:-$(wget -q -O - https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/index.yml  | grep $LIBERTY_VERSION -A 6 | sed -n 's/\s*kernel:\s//p' | tr -d '\r' )}  \
    && wget -q $DOWNLOAD_OPTIONS $LIBERTY_URL -U UA-IBM-WebSphere-Liberty-Docker -O /tmp/wlp.zip \
    && unzip -q /tmp/wlp.zip \
    && rm /tmp/wlp.zip
ENV PATH=/wlp/bin:$PATH

EXPOSE 9080 9443

# Create default server
RUN server create

# Install features needed for the collective controller
RUN installUtility install collectiveController-1.0 adminCenter-1.0 dynamicRouting-1.0 --acceptLicense

# Copy support files
COPY server.xml /wlp/usr/servers/defaultServer
COPY wlp-controller.sh /

RUN chmod 700 /wlp-controller.sh

CMD ["/wlp-controller.sh"]
