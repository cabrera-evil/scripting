#Download mongo image
docker pull mongo
#Creating the image container named "mongodb"
docker run -d -p 2717:27017 --name mongodb mongo:latest
#Install Mongo Compass
wget https://downloads.mongodb.com/compass/mongodb-compass_1.33.1_amd64.deb
sudo dpkg - i ./mongodb-compass_1.33.1_amd64.deb -y
