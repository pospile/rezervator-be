for ((n=1;n<2;n++))
do
    echo "node-${n}";
    docker-machine create --driver "digitalocean" --digitalocean-image "ubuntu-16-04-x64" --digitalocean-region "FRA1" --digitalocean-access-token $DO_TOKEN "node-${n}";
done;

docker-machine create --driver "digitalocean" --digitalocean-image  "ubuntu-16-04-x64" --digitalocean-region "fra1" --digitalocean-access-token $DOTOKEN manager-1
