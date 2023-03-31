FROM mambaorg/micromamba:0.15.2
COPY --chown=micromamba:micromamba R.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes
