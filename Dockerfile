# ── Stage 1: Build the React app ─────────────────────────────────────────
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files first (Docker layer caching)
COPY package.json package-lock.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build optimized production bundle
RUN npm run build
# Output: /app/build  (static HTML, CSS, JS)

# ── Stage 2: Serve with nginx ─────────────────────────────────────────────
FROM nginx:alpine

# Copy built static files into nginx serving directory
COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom nginx config for React Router support
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# nginx starts automatically
