FROM devbase

RUN sudo apt-get update 

RUN sudo apt-get install -y \
    bzip2 \
    curl 

COPY --chown=$USER build_scripts/install_nix.sh /tmp
RUN /tmp/install_nix.sh

COPY --chown=$USER build_scripts/install_miso.sh /tmp
RUN /tmp/install_miso.sh

COPY --chown=$USER build_scripts/user_installs.sh /tmp
RUN /tmp/user_installs.sh

COPY --chown=$USER build_scripts/personalize.sh /tmp
RUN /tmp/personalize.sh

COPY --chown=$USER build_scripts/haskellBashrc /tmp
RUN cp /tmp/haskellBashrc ~
RUN echo . ~/haskellBashrc | tee -a ~/.bashrc

COPY --chown=$USER build_scripts/haskellVimrc /tmp
RUN cp /tmp/haskellVimrc ~
RUN echo so ~/haskellVimrc | tee -a ~/.vimrc
