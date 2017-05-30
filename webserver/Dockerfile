FROM ibmcom/ibm-http-server:9.0.0.3

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
ENV JAVA_HOME=/opt/IBM/HTTPServer/java/8.0
ENV PATH=/wlp/bin:$JAVA_HOME/bin:$PATH

# Install features needed for the collective controller
RUN installUtility install dynamicRouting-1.0 --acceptLicense

EXPOSE 80
EXPOSE 443

# Copy support files
COPY wlpcluster.conf plugin-cfg.xml webserver.sh /

RUN echo "Include /wlpcluster.conf" >> /opt/IBM/HTTPServer/conf/httpd.conf
RUN chmod 700 /webserver.sh

CMD ["/webserver.sh"]
