# flutter-web-test_app-docker

# Command
## Build the docker image
Use docker build the container image
```
docker build -t test_app_microsoft_data .
```
If you have some problem during cache, you can clean cache by this
```
docker build --no-cache -t test_app_microsoft_data .
```

## After Success building image
Run the docker image with localhost 1200 port. You can change to any other port just replace it.
```
docker run -d -p 1200:80 --name test_app test_app_microsoft_data
```

Here we go, open browser and go to http://localhost:1200/
