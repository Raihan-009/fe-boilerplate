# --- Stage 1: Build the Vite app ---
FROM node:22-slim AS builder

WORKDIR /app

# Copy only package files first for caching
COPY package*.json ./
RUN npm ci --legacy-peer-deps

# Copy source code and build
COPY . .
RUN npm run build


# --- Stage 2: Production runtime ---
# Vite produces static files in the /dist directory,
# so we can serve them using a lightweight web server like nginx

FROM nginx:1.27-alpine AS runner

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy Vite build output
COPY --from=builder /app/dist /usr/share/nginx/html

# (Optional) Replace default nginx config to support SPA routes
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
