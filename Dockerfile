# Dockerfile for econsocart.cls bug demonstrations
# Provides a self-contained environment for reproducing bugs and testing workarounds
#
# Build:  docker build -t econsocart-bug-mwes .
# Run:    docker run -it --rm -v $(pwd):/workspace econsocart-bug-mwes
# Jupyter: docker run -p 8888:8888 --rm econsocart-bug-mwes jupyter notebook --ip=0.0.0.0 --allow-root

FROM ubuntu:22.04

LABEL maintainer="Christopher Carroll <ccarroll@jhu.edu>"
LABEL description="Environment for demonstrating econsocart.cls bugs with workarounds"
LABEL version="1.0"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install LaTeX and required packages
RUN apt-get update && apt-get install -y \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    latexmk \
    ghostscript \
    python3 \
    python3-pip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages for Jupyter notebook support
RUN pip3 install --no-cache-dir \
    jupyter \
    notebook \
    ipykernel

# Create workspace directory
WORKDIR /workspace

# Copy repository contents
COPY . /workspace/

# Make compile scripts executable
RUN chmod +x font-shape-bug/compile.sh headers-draft-bug/compile.sh

# Display welcome message
RUN echo '#!/bin/bash' > /usr/local/bin/welcome && \
    echo 'cat << "EOF"' >> /usr/local/bin/welcome && \
    cat >> /usr/local/bin/welcome << 'EOF'
╔════════════════════════════════════════════════════════════╗
║  econsocart.cls Bug Demonstrations                         ║
║  Docker Container Environment                              ║
╚════════════════════════════════════════════════════════════╝

This container provides a complete LaTeX environment for
reproducing two modest bugs in econsocart.cls.

┌────────────────────────────────────────────────────────────┐
│ Bug 1: Font Shape Error (Compilation Failure)             │
├────────────────────────────────────────────────────────────┤
│   cd font-shape-bug/                                       │
│   ./compile.sh                                             │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ Bug 2: Garbled Headers (Visual Defect)                    │
├────────────────────────────────────────────────────────────┤
│   cd headers-draft-bug/                                    │
│   ./compile.sh                                             │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ Interactive Notebook                                       │
├────────────────────────────────────────────────────────────┤
│   jupyter notebook --ip=0.0.0.0 --port=8888 \            │
│                     --no-browser --allow-root              │
└────────────────────────────────────────────────────────────┘

Documentation:
  - README.md (overview)
  - font-shape-bug/README.md
  - headers-draft-bug/README.md
  - EMAIL-TEMPLATE.md (for reporting bugs)

EOF
    echo 'EOF' >> /usr/local/bin/welcome && \
    chmod +x /usr/local/bin/welcome

# Display welcome on container start
RUN echo 'welcome' >> /root/.bashrc

# Default command: interactive shell
CMD ["/bin/bash"]

