# syntax=docker/dockerfile:1

ARG NODE_VERSION=24-alpine

# -----------------------------------------------------------------------------
# base
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS base
WORKDIR /app
RUN corepack enable pnpm
COPY frontend/package.json frontend/pnpm-lock.yaml ./

# -----------------------------------------------------------------------------
# dependencies: todas as deps (dev + prod)
# -----------------------------------------------------------------------------
FROM base AS dependencies
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile --ignore-scripts

# -----------------------------------------------------------------------------
# development
# -----------------------------------------------------------------------------
FROM dependencies AS development
ENV NODE_ENV=development
COPY frontend/ .
EXPOSE 3000
CMD ["pnpm", "dev", "--hostname", "0.0.0.0"]

# -----------------------------------------------------------------------------
# build: gera .next/standalone (output file tracing já traz só deps de prod)
# -----------------------------------------------------------------------------
FROM dependencies AS build
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
ENV NODE_ENV=production
COPY frontend/ .
RUN pnpm build

# -----------------------------------------------------------------------------
# production: runtime mínimo — não precisa de pnpm nem node_modules completo
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS production
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

COPY --from=build --chown=node:node /app/public ./public

RUN mkdir .next && chown node:node .next

COPY --from=build --chown=node:node /app/.next/standalone ./
COPY --from=build --chown=node:node /app/.next/static ./.next/static

USER node
EXPOSE 3000
CMD ["node", "server.js"]
