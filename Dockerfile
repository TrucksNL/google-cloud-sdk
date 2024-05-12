FROM alpine:3.19

RUN apk add --update --no-cache \
    python3 \
    openjdk21-jre

COPY --from=google/cloud-sdk:alpine /google-cloud-sdk/ /google-cloud-sdk/

RUN /google-cloud-sdk/bin/gcloud components remove bq gcloud-crc32c gsutil --quiet

RUN /google-cloud-sdk/bin/gcloud components install beta pubsub-emulator --quiet

RUN mkdir -p /var/pubsub

EXPOSE 8085

CMD ["/google-cloud-sdk/bin/gcloud", "beta", "emulators", "pubsub", "start", "--quiet", "--data-dir=/var/pubsub", "--host-port=0.0.0.0:8085", "--project=emulator-project", "--log-http", "--verbosity=debug", "--user-output-enabled"]
