# Newer version of micromamba with lots of features
FROM mambaorg/micromamba:0.23.0
# copy env file. must be chowned to the micromamba user
COPY --chown=micromamba:micromamba R.yaml /tmp/env.yaml
# Install the environment. This is done as the micromamba user so superuser commands will not work
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes
# Change user to root to make root directory and chown it to mamba user. Mamba env is not active here
USER root
RUN mkdir /evaladmix && \
    chown mambauser:mambauser /evaladmix
# switch user back to mambauser
USER mambauser
# you must include the below arg to activate the env within the dockerfile
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN git clone https://github.com/GenisGE/evalAdmix.git /evaladmix && \
    cd /evaladmix && \
    CPLUS_INCLUDE_PATH=$CONDA_PREFIX/include:$CPLUS_INCLUDE_PATH && \
    make clean && \
    make
# below is necessary for the env to work with shell sessions
ENV PATH "$MAMBA_ROOT_PREFIX/bin:/evaladmix:$PATH"
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh", "python3", "/evaladmix/evalAdmix"]
