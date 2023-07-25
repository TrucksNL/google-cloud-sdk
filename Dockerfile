FROM alpine:3.18

RUN apk add --update --no-cache \
    python3 \
    py3-crcmod \
    py3-openssl \
    openjdk16-jre

COPY --from=google/cloud-sdk:alpine /google-cloud-sdk/ /google-cloud-sdk/

RUN /google-cloud-sdk/bin/gcloud components install pubsub-emulator beta \
    && /google-cloud-sdk/bin/gcloud components update \
    && mkdir -p /var/pubsub

EXPOSE 8085

CMD ["/google-cloud-sdk/bin/gcloud", "beta", "emulators", "pubsub", "start", "--quiet", "--data-dir=/var/pubsub", "--host-port=0.0.0.0:8085", "--project=emulator-project", "--log-http", "--verbosity=debug", "--user-output-enabled"]
