FROM archlinux/base
RUN pacman -Syyu --needed --noconfirm --noprogressbar base-devel 
RUN pacman -Scc  --noconfirm
RUN useradd --create-home --shell /bin/bash my-pkgbuild
RUN touch /etc/sudoers.d/my-pkgbuild
RUN echo "my-pkgbuild ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/my-pkgbuild
COPY build.sh /home/my-pkgbuild/build.sh
COPY check_version.sh /home/my-pkgbuild/check_version.sh
COPY pkgbuild /home/my-pkgbuild/pkgbuild
RUN chown -R my-pkgbuild:my-pkgbuild /home/my-pkgbuild
USER my-pkgbuild
WORKDIR /home/my-pkgbuild
