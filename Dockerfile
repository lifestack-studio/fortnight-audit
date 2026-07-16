# The Fortnight Audit — static distribution image
# Production deploy: see docker-compose.yml (Traefik on tools.lifestack.studio).
# Local test:  docker build -t fortnight-audit . && docker run --rm -p 8080:80 fortnight-audit
#              → http://localhost:8080/  (lands on the prompt-pack page)
#
# The app is a static site served by nginx, listening on port 80 inside the
# container. Everything the pages need (fonts included) is in this folder —
# no external requests are required to render the prompt-pack or the sample
# report.

FROM nginx:alpine

COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html/

# Strip everything non-servable from the web root. This RUN is the
# authoritative mechanism: BuildKit does NOT apply .dockerignore to remote
# git build contexts (verified on the Hostinger VPS 2026-07-16), so every
# file tracked in the repo lands in the COPY above. The private names are
# included defensively — rm -rf on an absent path is a no-op.
RUN cd /usr/share/nginx/html && rm -rf \
    deploy README.md README-internal.md docker-compose.yml Dockerfile \
    .dockerignore .gitignore _src _export proofs assets/report-template.html
