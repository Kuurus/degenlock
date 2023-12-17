# Use a Node base image
FROM node:18.17.0

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json, yarn.lock, and package-lock.json if available
COPY package*.json ./
COPY yarn.lock* ./

# Install dependencies using Yarn
RUN yarn install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# The command to run when the container starts
CMD ["npm", "run", "start"]