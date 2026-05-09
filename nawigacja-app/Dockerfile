FROM node:20-alpine

WORKDIR /app

# Сначала копируем package файлы для кэширования слоя
COPY package*.json ./
RUN npm ci --omit=dev

# Копируем исходники приложения
COPY src/ ./src/
COPY public/ ./public/

EXPOSE 3000

CMD ["node", "src/server.js"]
