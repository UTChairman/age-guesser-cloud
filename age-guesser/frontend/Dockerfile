FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 8080 for the frontend web server
EXPOSE 8080

# Start the Node.js server
CMD ["node", "server.js"]
