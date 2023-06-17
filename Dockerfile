# 1. Building the App
FROM python:3.8-slim-buster as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create a non-root user, create the /app directory and set the user as owner
RUN useradd appuser && mkdir /app && chown -R appuser /app

# Set the working directory to /app
WORKDIR /app

# Install pip requirements
COPY requirements.txt .
RUN pip3 install --upgrade pip -r requirements.txt 

# Copy the current directory contents into the container at /app
COPY --chown=appuser:appuser . .

# 2. Running the App
FROM python:3.8-slim-buster as runner

COPY --from=builder /usr/local /usr/local
COPY --from=builder /app /app

# Create a non-root user
RUN useradd appuser && chown -R appuser /app

USER appuser

WORKDIR /app

# Make port 80 available to the world outside this container
EXPOSE 5000

# Run the command to start uWSGI
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]
