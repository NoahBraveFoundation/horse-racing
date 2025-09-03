# ================================
# Build image
# ================================
# syntax=docker/dockerfile:1.7
FROM swift:6.1-noble AS build

# Install OS updates
RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    --mount=type=cache,id=apt-lib,target=/var/lib/apt \
    apt-get update && \
    apt-get -y dist-upgrade

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
COPY ./Package.* ./
RUN --mount=type=cache,id=spm-cache,target=/root/.swiftpm \
    swift package resolve

# Copy entire repo into container
COPY . .

# Build the application, with optimizations, with static linking
RUN --mount=type=cache,id=spm-build-cache,target=/build/.build \
    --mount=type=cache,id=spm-cache,target=/root/.swiftpm \
    swift build -c release --product HorseRacingBackend \
  && mkdir -p /staging \
  && cp "$(swift build --package-path /build -c release --show-bin-path)/HorseRacingBackend" /staging/ \
  && find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} /staging/ \;

# Switch to the staging area
WORKDIR /staging

# Copy static swift backtracer binary to staging area
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./

# Copy any resources from the resources directory if the directory exists
# Ensure that by default, neither the directory nor any of its contents are writable.
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# ================================
# Run image
# ================================
FROM swift:6.1-slim AS runtime

# Make sure all system packages are up to date, and install only essential packages.
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -q update \
 && apt-get -q install -y --no-install-recommends ca-certificates tzdata curl \
    fontconfig libjpeg-turbo-progs libxrender1 libfontconfig1 libx11-6 libxext6 libxrender1 \
    chromium zint \
 && rm -rf /var/lib/apt/lists/*

# Test that Chromium and Zint are working
RUN chromium --version || echo "Warning: Chromium not working properly"
RUN zint --version || echo "Warning: Zint not working properly"
RUN which zint && zint --version

# Create a vapor user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

# Switch to the new home directory
WORKDIR /app

# Copy built executable and any staged resources from builder
COPY --from=build --chown=vapor:vapor /staging /app

# Provide configuration needed by the built-in crash reporter and some sensible default behaviors.
ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

ENV CHROME_PATH=/usr/bin/chromium
ENV ZINT_PATH=/usr/bin/zint

# Ensure all further commands run as the vapor user
USER vapor:vapor

# Let Docker bind to port 8080
EXPOSE 8080

# Simple health check to verify the server is responding
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -fsS http://localhost:8080/health > /dev/null || exit 1

# Start the Vapor service when the image is run, default to listening on 8080 in production environment
ENTRYPOINT ["./HorseRacingBackend"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0"]
