FROM node:22-alpine AS base

FROM base AS builder

WORKDIR /app

ADD package*.json ./

RUN npm ci --omit=dev

FROM base AS runner

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules

ADD index.js ./

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

RUN chown -R nodejs:nodejs /app

USER nodejs

ENV NODE_ENV production

CMD [ "node", "index.js" ]
