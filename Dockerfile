# Use official lightweight Node.js LTS Alpine image
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy package dependency definition
COPY app/package*.json ./

# Install application dependencies
RUN npm install --production

# Copy application source code
COPY app/ ./

# Expose web server port
EXPOSE 3000

# Run the server
CMD ["node", "server.js"]
