FROM amazon/aws-cli:latest

LABEL com.dotcms.contact "info@dotcms.com"
LABEL com.dotcms.vendor "dotCMS LLC"
LABEL com.dotcms.description "dotCMS Content Management System"
LABEL com.github.actions.icon "hash"
LABEL com.github.actions.color "gray-dark"

RUN yum install net-tools

COPY entrypoint.sh /entrypoint.sh
RUN chmod 500 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
