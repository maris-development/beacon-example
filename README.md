# Beacon Example Setup

This repository contains various examples on how to setup Beacon for different environments.
There are also [example notebooks](notebooks/) that show how to use the Python client to query data from Beacon and perform some basic analysis.

## Requirements

Beacon currently runs solely via Docker as an image. This is the easiest way to get started with Beacon. Make sure you have Docker installed on your machine.
Make sure to also have installed docker-compose, which currently comes by default with docker itself.

## Setup Instructions

To run a local instance of Beacon with a local file system backend:
1. Clone the repository:
   ```bash
   git clone https://github.com/maris-development/beacon-example.git
   cd local-file-system
   ```

2. Start the Beacon services using Docker Compose:
   ```bash
   docker-compose up -d
   ```

3. Access the Beacon API at `http://localhost:8080`.

To run a local instance of Beacon with an S3 backend (using MinIO):
1. Clone the repository:
   ```bash
   git clone https://github.com/maris-development/beacon-example.git
   cd cloud-storage-minio
   ```

2. Start the Beacon services using Docker Compose:
   ```bash
   docker-compose up -d
   ```

3. Access the Beacon API at `http://localhost:8080`.
