FROM splunk/fluentd-hec:1.0.1

LABEL maintainer="Sebastian Dehn <sdehn@redhat.com>"

RUN gem install -N fluent-plugin-secure-forward

ENTRYPOINT ["/fluentd/entrypoint.sh"]
CMD ["-h"]