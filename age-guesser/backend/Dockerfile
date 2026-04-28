FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 5000 for the backend API
EXPOSE 5000

# Start the Node.js server
CMD ["node", "server.js"]
