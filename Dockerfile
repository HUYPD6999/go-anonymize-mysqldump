FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum update -y \
    && yum install golang unzip mariadb nano gzip -y
RUN rm -rf /bin/aws \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install -i /usr/local/aws-cli -b /bin \
    && rm -rf awscliv2.zip aws
RUN mkdir /go-anonymize-mysqldump
WORKDIR /go-anonymize-mysqldump
COPY ./ .
RUN go get -d -v . \
    && go build \
    && mv go-anonymize-mysqldump /bin/anonymize-mysqldump \
    && chmod +x /bin/anonymize-mysqldump

#RUN chmod +x /bin/anonymize-mysqldump
