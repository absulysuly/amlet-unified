FROM node:20-slim
WORKDIR /usr/src/app

# Install production dependencies only
COPY backend/package.json backend/package-lock.json* ./
RUN npm ci --only=production || npm install --only=production

# Copy source
COPY backend/ .

ENV NODE_ENV=production
ENV PORT=4001

EXPOSE 4001

CMD [ "node", "server.mjs" ]
