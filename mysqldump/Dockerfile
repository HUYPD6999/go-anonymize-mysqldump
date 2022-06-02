FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum update -y \
    && yum install unzip mariadb gzip -y
RUN rm -rf /bin/aws \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install -i /usr/local/aws-cli -b /bin \
    && rm -rf awscliv2.zip aws
COPY ./ .
RUN chmod +x entrypoint.sh
ENTRYPOINT ./entrypoint.sh
