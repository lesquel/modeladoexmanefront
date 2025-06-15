# Etapa 1: Construcción
FROM node:20-alpine AS builder

# Establece el directorio de trabajo
WORKDIR /app

# Instala pnpm
RUN npm install -g pnpm

# Copia los archivos de definición de dependencias
COPY package.json pnpm-lock.yaml ./

# Instala dependencias
RUN pnpm install

# Copia el resto del proyecto
COPY . .

# Compila la aplicación Next.js
RUN pnpm run build

# Etapa 2: Producción
FROM node:20-alpine AS runner

# Establece el directorio de trabajo
WORKDIR /app

# Instala pnpm
RUN npm install -g pnpm

# Copia los archivos necesarios desde la etapa de construcción
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Establece la variable de entorno para producción
ENV NODE_ENV=production

# Expone el puerto 3000
EXPOSE 3000

# Inicia la aplicación en el puerto 3000
CMD ["pnpm", "start", "--", "-p", "3000"]
