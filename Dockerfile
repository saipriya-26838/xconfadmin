# Base image for building the Go application
FROM golang:1.20 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and download dependencies first (to leverage Docker caching)
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code into the container
COPY . .

# Build the Go application
RUN go build -o xconfadmin main.go

# Final lightweight image
FROM debian:bullseye-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/xconfadmin ./

# Copy the configuration files from the builder stage
COPY --from=builder /app/config/sample_xconfadmin.conf ./config/
COPY --from=builder /app/config/sample_xconfwebconfig.conf ./config/

# Expose the application port
EXPOSE 9000

# Run the application with the configuration files
CMD ["./xconfadmin", "-config", "./config/sample_xconfadmin.conf"]
#===============V1==============================
## Base image for building the Go application
#FROM golang:1.20 as builder
#
## Set the working directory inside the container
#WORKDIR /app
#
## Copy the Go module files and download dependencies first (to leverage Docker caching)
#COPY go.mod go.sum ./
#RUN go mod download
#
## Copy the rest of the application code into the container
#COPY . .
#
## Specify the port the application will run on
#EXPOSE 9000
#
## Build the Go application
#RUN go build -o xconfadmin main.go
#
## Final lightweight image
#FROM debian:bullseye-slim
#
## Set the working directory inside the container
#WORKDIR /app
#
## Copy the compiled binary from the builder stage
#CMD ["./xconfadmin"]
