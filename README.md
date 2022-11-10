# Caprover cluster
SSH:a in i server:
Kör:
-sudo docker swarm join-token worker

Ta med output kommandot: I mitt fall:
-docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Logga ut ur server:
SSH:a in i runner:
Kör ovan output
-sudo docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Output
This node joined a swarm as a worker.

Working =)

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/caprover_cluster.PNG)
![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/aras_gitlab-repo.PNG)