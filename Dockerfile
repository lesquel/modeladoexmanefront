# Etapa de build
FROM node:20-alpine AS builder
WORKDIR /app
RUN npm install -g pnpm
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . .
RUN pnpm run build

# Etapa final
FROM node:20-alpine AS runner
WORKDIR /app
RUN npm install -g pnpm

# Solo copia /public si realmente existe
# COPY --from=builder /app/public ./public   <-- elimina o comenta esta línea si no usas /public

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
CMD ["pnpm", "start"]
