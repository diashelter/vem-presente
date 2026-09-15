# vem-presente

## Sobre o projeto

O VemPresente é um sistema para gerenciar a lista de presente do seu evento/celebração. Através dele você cadastra links de produtos de lojas onde os convidados podem presentear com produto ou presentear com PIX. Os valores recebidos podem ser resgatados após o recebimento.

## Tecnologias

- **API**: NestJS
- **Banco de dados**: PostgreSQL
- **Front**: Next.js
- **Cache**: Redis
- **Testes**: Vitest
- **Teste de carga**: k6

## Infraestrutura (Docker)

O projeto sobe via Docker Compose, com um container por serviço:

- Container da **API**
- Container do **banco de dados** (PostgreSQL)
- Container do **frontend**
- Container do **cache** (Redis)
- Container de **teste de carga** (k6) — já configurado no `docker-compose.yml`, atrás do profile `load-test`, então não sobe por padrão junto com os demais

## Versões

Versões verificadas diretamente nos arquivos do projeto (`package.json`, Dockerfiles e `docker-compose.yml`):

| Tecnologia | Versão | Origem |
|---|---|---|
| Node.js | 24 (Alpine) | `.docker/api/Dockerfile`, `.docker/frontend/Dockerfile` |
| TypeScript | 6.0.x | `api/package.json`, `frontend/package.json` |
| Next.js | 16.3.5 | `frontend/package.json` |
| NestJS | 12.0.x | `api/package.json` |
| Redis | 8.10 (Alpine) | `docker-compose.yml` |
| PostgreSQL | 18.6 (Alpine) | `docker-compose.yml` |

## Como subir o projeto em desenvolvimento

1. Copie o arquivo de variáveis de ambiente de exemplo e ajuste se necessário:

   ```bash
   cp .env.example .env
   ```

   Variáveis principais: `NODE_ENV`, `API_PORT`, `FRONTEND_PORT`, `NEXT_PUBLIC_API_URL`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, `POSTGRES_PORT`, `REDIS_PORT`, `REDIS_PASSWORD`, `K6_TARGET_URL`.

2. Suba os containers a partir da raiz do projeto:

   ```bash
   docker compose up --build
   ```

   Isso usa automaticamente o `docker-compose.override.yml`, que configura o modo desenvolvimento (hot reload) para API (`nest start --watch`) e frontend (`next dev`), além de subir PostgreSQL e Redis. O container de k6 não sobe por padrão.

## Como executar os testes

### API (Vitest)

```bash
pnpm --dir api test          # testes unitários
pnpm --dir api run test:cov  # testes unitários com cobertura
pnpm --dir api run test:e2e  # testes end-to-end
```

### Frontend

Ainda não há testes configurados no frontend.

### Teste de carga (k6)

```bash
docker compose --profile load-test up k6
```

Executa o script `.docker/k6/scripts/smoke-test.js` contra a API (requer o container da API em execução).
