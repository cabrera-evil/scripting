#Download mongo image
docker pull mongo
#Creating the image container named "mongodb"
docker run -d -p 2717:27017 --name mongodb mongo:latest
