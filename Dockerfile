FROM node:14 AS build
WORKDIR /app

RUN npm install -g hugo-cli

# Install Go
RUN curl -OL https://golang.org/dl/go1.17.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz \
    && rm go1.17.linux-amd64.tar.gz
    
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Hugo
RUN curl -Ls https://github.com/gohugoio/hugo/releases/download/v0.89.4/hugo_0.89.4_Linux-64bit.tar.gz | tar -xz -C /usr/local/bin

COPY . .
RUN npm install
RUN npm run build

FROM nginx:1.21-alpine

COPY --from=build /app/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]