# syntax=docker/dockerfile:1

ARG NODE_VERSION=24-alpine

# -----------------------------------------------------------------------------
# base: só o necessário para resolver dependências (bom cache de layers)
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS base
WORKDIR /app
RUN corepack enable pnpm
COPY api/package.json api/pnpm-lock.yaml ./

# -----------------------------------------------------------------------------
# dependencies: instala TODAS as deps (incl. dev) — usada por dev e build
# -----------------------------------------------------------------------------
FROM base AS dependencies
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile --ignore-scripts

# -----------------------------------------------------------------------------
# dependencies-prod: instala só as deps de produção — usada pela imagem final
# -----------------------------------------------------------------------------
FROM base AS dependencies-prod
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile --prod --ignore-scripts

# -----------------------------------------------------------------------------
# development: código chega via bind mount (ver docker-compose.override.yml)
# -----------------------------------------------------------------------------
FROM dependencies AS development
ENV NODE_ENV=development
COPY api/ .
EXPOSE 3001 9229
CMD ["pnpm", "run", "start:dev"]

# -----------------------------------------------------------------------------
# build: compila TypeScript -> dist/
# -----------------------------------------------------------------------------
FROM dependencies AS build
ENV NODE_ENV=production
COPY api/ .
RUN pnpm run build

# -----------------------------------------------------------------------------
# production: imagem final mínima, sem pnpm/devDeps, usuário não-root
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS production
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3001

COPY --from=dependencies-prod --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/package.json ./package.json

USER node
EXPOSE 3001
CMD ["node", "dist/main.js"]
