# Caprover cluster
SSH:a into server:
Run:
-sudo docker swarm join-token worker

Take the output: In my case:
-docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Logout from server:
SSH:a into runner:
Run the above output command:
-sudo docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Output
This node joined a swarm as a worker.

Working =)

Navigate to your Caprover:
In my case:
-https://captain.aras.ejo.one/#/login
Log in with your password

Navigate to cluster. You can now see that you are clustered. Se down below picture:


![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/caprover_cluster.PNG)

# Gitlab deployed on CapRover

1. Create GitLab Repository

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/aras_gitlab-repo.PNG)

2. Add sample Source code-file, Dockerfile and a .gitlab-ci.yml-file
The files can be seen in this repo.

3. Create CI/CD Variables
Go to your project page on GitLab, navigate to Settings > CI/CD. Then, under Variables add the following variables:

- Key : CAPROVER_URL , Value : https://captain.root.domain.com [replace it with your domain]
- Key : CAPROVER_PASSWORD , Value : mYpAsSwOrD [replace it with your password]
- Key : CAPROVER_APP , Value : my-test-gitlab-deploy [replace it with your app name]

4.  Create an Access Token for CapRover
Navigate to https://gitlab.com/-/profile/personal_access_tokens and create a token.

Make sure to assign read_registry and write_registry permissions for this token.

5. Add Token to CapRover
Login to your CapRover web dashboard, under Cluster click on Add Remote Registry. Then enter these fields:

- Username: your gitlab username
- Password: your gitlab Token [From the previous step]
- Domain: registry.gitlab.com
- Image Prefix: again, your gitlab username !!!!I needed this to be blanc for it to work!

6. Disable Default Push
Now that you added a registry, CapRover by default wants to push the built artifact to your registry. You do not need this for this tutorial, and it might make your deployments to fail. So go ahead and disable Default Push
!!!! I did not do this step!!!

7. Create a CapRover App
On CapRover "Apps" and create an app:
-aras-gitlab-deploy

8. Push to your repo
Wait a little bit until your build is finished and deployed automatically! After a few minutes you can see your deployed app on CapRover!!!

Open CapRover
Navigate to "Apps"
Click on open on your app.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/caprover_apps.PNG)

The output from the index.php-file can now be seen:

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/app_output.PNG)