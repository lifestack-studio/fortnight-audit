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

# deploy/ is needed in the build context for the nginx.conf COPY above,
# but must not be publicly served — remove it from the web root.
RUN rm -rf /usr/share/nginx/html/deploy
