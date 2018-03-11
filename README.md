# infra-docker-tools
Ce dépôt contient un ensemble de scripts pour l'installation et l'administration des environnements Docker et Rancher

## Scripts docker

*   **cleanHost.sh** : nettoyage de docker (suppression de toutes les images, de tous les conteneurs, de tous les volumes) 
*   **initHost.sh** : installation et configuration d'une version spécifique de docker
 
## Scripts letsencrypt
* **installLetsencrypt.sh** : configure la demande de certificat et installe un cron de renew des certificats demandées

## Scripts rancher 1.x
* **initRancher-nha-sc.sh** : installe un serveur rancher non HA et tournant en deux conteneurs : proxy https + rancher(db in)
* **initRancher-nha-extdb.sh** : installe un serveur rancher non HA tournant avec 3 conteneurs: proxy https + rancher + db
