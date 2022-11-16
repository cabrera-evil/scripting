#Login Into Oracle (Must Be Manual Or Could Have Errors)
docker login container-registry.oracle.com
#Download Oracle 19c Image
docker pull container-registry.oracle.com/database/enterprise:19.3.0.0
#Create Oracle Container
docker run -d --name oracle19c -p 1521:1521 -p 5500:5500 container-registry.oracle.com/database/enterprise:19.3.0.0
