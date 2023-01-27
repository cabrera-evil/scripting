#Download mongo image
#docker pull mcr.microsoft.com/mssql/server
#Creating the image container named "sqldb"
sudo docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<admin@qkj2x4T@6@Xy>" \
   -p 1433:1433 --name sqlserver --hostname sqlserver \
   -d \
   mcr.microsoft.com/mssql/server:latest
