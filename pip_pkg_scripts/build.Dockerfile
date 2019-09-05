FROM tensorflow/tensorflow:custom-op-ubuntu16

RUN apt-get update && apt-get install -y && \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && apt-get install -y bazel && \
    rm -rf /usr/local/bin/bazel && hash -r

RUN pip install --upgrade setuptools
RUN pip3 install --upgrade setuptools

# Install tensorflow
RUN pip uninstall -y tensorflow
RUN pip3 uninstall -y tensorflow
RUN pip install tf-nightly
RUN pip3 install tf-nightly

RUN pip3 install --upgrade auditwheel
COPY pip_pkg_scripts/build.sh /

VOLUME /tmp/pip_pkg_build

ENTRYPOINT ["/build.sh"]

# The default parameters for the build.sh
CMD ["rc1.0.tf1.5.0", "3"]
