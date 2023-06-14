# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster as builder

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Creates a non-root user and creates the /app directory and sets the user as owner
RUN useradd appuser && mkdir /app && chown -R appuser /app

# Set the working directory to /app
WORKDIR /app

# Install pip requirements
COPY requirements.txt .
RUN pip3 install --upgrade pip -r requirements.txt 

# Switch to non-root user
USER appuser

# Copy the current directory contents into the container at /app
COPY --chown=appuser:appuser . .

# Make port 80 available to the world outside this container
EXPOSE 5000

# Run the command to start uWSGI
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]
