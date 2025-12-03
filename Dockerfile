FROM node:18-slim

WORKDIR /app

# 1. Install dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# 2. Copy source code
COPY . .

# 3. EXPOSE the port
EXPOSE 3000

# 4. Build & Run at Startup
# We chain these commands so the build happens AFTER the container connects to the DB.
# We use 'npm install' again just in case, then build, then run the node server.
CMD ["/bin/sh", "-c", "npm run sources && npm run dev -- --host 0.0.0.0"]