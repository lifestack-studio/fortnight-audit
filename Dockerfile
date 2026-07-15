# The Fortnight Audit — static distribution image
# Build:  docker build -t fortnight-audit .
# Run:    docker run --rm -p 8080:80 fortnight-audit
# Then:   http://localhost:8080/  (redirects to the prompt-pack page)
#
# Everything the pages need (fonts included) is inside this folder — no external
# requests are required to render the prompt-pack or the sample report.

FROM nginx:alpine

COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html/
