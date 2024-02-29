# Use Fedora as the base image
FROM fedora:latest

# Define ARG variables
ARG RELEASE

# Set environment variables
ENV USER=gitpod \
  HOME=/home/gitpod \
  PATH=/home/gitpod/.local/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create the $USER user. UID must be 33333.
RUN useradd -l -u 33333 -G wheel -m -d /home/$USER -s /bin/bash $USER

# Add the user to the sudoers file without password prompt
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER

# Create necessary directories for environment setup
RUN mkdir -p $HOME/.config/direnv $HOME/.bashrc.d && \
  chmod 700 $HOME/.config/direnv $HOME/.bashrc.d

# Install necessary packages
RUN dnf update -y && \
  dnf install -y tigervnc-server sudo git rlwrap curl && \
  dnf clean all

# # Copy configuration files and scripts
# COPY novnc-index.html /opt/novnc/index.html
# COPY gp-vncsession /usr/bin/
# COPY .xinitrc $HOME/
# COPY default.gitconfig /etc/gitconfig
# COPY default.gitconfig $HOME/.gitconfig
# COPY nvm-lazy.sh $HOME/.nvm/nvm-lazy.sh
# COPY userbase.bash $HOME/.gp_pyenv.d/
# COPY python_hook.bash $HOME/.bashrc.d/60-python
# COPY avoid_userbase_hook.bash $HOME/.pyenv/pyenv.d/exec

# # Set permissions
# RUN chmod 0755 /usr/bin/gp-vncsession $HOME/.xinitrc

# Switch to non-root user
USER $USER

# # Set the default command to start the VNC server
# CMD ["/usr/bin/gp-vncsession"]
