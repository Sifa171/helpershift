FROM splunk/fluentd-hec:1.0.1

LABEL maintainer="Sebastian Dehn <sdehn@redhat.com>"

RUN gem install -N fluent-plugin-secure-forward

ADD fluent.conf /fluentd/etc/fluent.conf

ENTRYPOINT ["/fluentd/entrypoint.sh"]
CMD ["-h"]