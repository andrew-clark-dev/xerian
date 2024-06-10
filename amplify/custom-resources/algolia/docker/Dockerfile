# Use the official Python runtime as the base image
FROM python:3.12-bookworm

# Set the working directory in the container
WORKDIR /app

# Install any necessary dependencies
RUN apt-get update && \
    apt-get install -y zip && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements file to the working directory
COPY requirements.txt .

# Install the Python packages listed in requirements.txt
RUN mkdir -p asset
RUN pip install --upgrade pip
RUN pip install -r requirements.txt -t /opt/python/ --target /asset

# Set the CMD to zip the installed packages into a layer
# change the `requests-layer` to the LAYER_NAME variable as per create_layer.sh file

# CMD cd /opt && zip -r9 /app/requests-layer.zip .