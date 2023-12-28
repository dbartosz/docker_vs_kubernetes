######## MULTI-STAGE BUILDS ########

# Set arguments that can be overriden
ARG PORT=8080
ARG NODE_ENV=production

######## DEVELOPMENT STAGE ########
FROM node:20.10.0-alpine3.18 as development

# At each stage arguments have to be redeclared to use default value that were set on outside of the stages
ARG PORT
ARG NODE_ENV=development

# Set stage scope variables
ENV PORT=${PORT}
ENV NODE_ENV=${NODE_ENV}

RUN apk add --no-cache --update npm

# Set up user as non-root
WORKDIR /usr/src/app
RUN chown node:node ./
USER node

# Install dependencies in two steps so it can be cached by the Docker Engine
COPY package*.json ./
RUN npm ci && npm cache clean --force

# Copy source files
COPY ./src ./src

EXPOSE ${PORT}

CMD npm run start:dev -- localhost ${PORT}

# Set up builder stage to build the app for production use
# ######## BUILDER STAGE ########
FROM development as builder

WORKDIR /usr/src/app
USER node

ENV NODE_ENV=production

COPY --chown=node:node webpack*.js ./

RUN npm run build

# # Set up production stage so it will copy the built app with minimum size of an image
# ######## PRODUCTION STAGE ########
FROM alpine:3.18.5 as production

ARG PORT
ARG NODE_ENV

ENV PORT=${PORT}
ENV NODE_ENV=${NODE_ENV}

RUN apk --no-cache add nodejs ca-certificates dumb-init
WORKDIR /root/

COPY --from=builder /usr/src/app/dist ./

EXPOSE ${PORT}

CMD ["dumb-init", "node", "./main.js"]
