FROM amazon/aws-cli:latest

LABEL com.dotcms.contact "info@dotcms.com"
LABEL com.dotcms.vendor "dotCMS LLC"
LABEL com.dotcms.description "dotCMS Content Management System"
LABEL com.github.actions.icon "hash"
LABEL com.github.actions.color "gray-dark"

#RUN /etc/lsb-release
RUN cat /etc/os-release
#RUN apk add --no-cache curl iptables
RUN apt-get update
RUN apt-get install iproute2

COPY entrypoint.sh /entrypoint.sh
RUN chmod 500 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
