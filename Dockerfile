FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y curl
RUN groupadd -r nixbld
RUN for n in $(seq 1 10); do useradd -c "Nix build user $n" \
    -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" \
    nixbld$n; done
RUN curl https://nixos.org/nix/install | USER=root sh
RUN echo "source /root/.nix-profile/etc/profile.d/nix.sh" >> /etc/bash.bashrc

ENV IN_DOCKER 1
ADD cmd.sh /bin/nix-env

RUN nix-env -i cabal-install-1.22.9.0
RUN nix-env -i ghc-7.10.3

ADD cmd-install.sh /bin/cmd-install
