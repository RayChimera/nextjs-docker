FROM node:18-alpine3.15 as dev
WORKDIR /app-in-development
COPY app-in-development/ ./

EXPOSE 3000
CMD ["yarn", "dev"]

FROM node:18-alpine3.15 as dependencies
WORKDIR /app-in-development
COPY app-in-development/package.json app-in-development/yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:18-alpine3.15 as builder
WORKDIR /app-in-development
COPY app-in-development/ .
COPY --from=dependencies /app-in-development/node_modules ./node_modules
RUN yarn build

FROM node:18-alpine3.15 as runner
WORKDIR /app-in-development
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /my-project/next.config.js ./
COPY --from=builder /app-in-development/public ./public
COPY --from=builder /app-in-development/.next ./.next
COPY --from=builder /app-in-development/node_modules ./node_modules
COPY --from=builder /app-in-development/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]
