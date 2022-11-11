# Files provided for this project
- main.tf
- inventory.yml
- caprov-playbook.yml
- config.json
- README.md (pdf)

Create a directory with the above files added.

- Fork the test repo down below to be able to show the CapRover GitLab app deployed from Gitlab
    -https://gitlab.com/SaraPetre/u08_caprover_gitlab



# elastx
- Log in to your account with your email and provided password
- Go into API Access.
- Go to Download Openstack RC files

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/api.PNG)

- Move your downloaded RC-file into your file-directory

# VScode
-open VScode in your directory with the above files.
- open your config.json-file and add your personal Domain, new password, email and caproverName.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/config.PNG)

In terminal:
- source 'chasacademy-petre-openrc.sh' (your downloaded file)
- copy and add your elastx password in the terminal

## Terraform

In terminal:
- terraform init
- terraform apply
    - yes (to approve the plan an go ahead with apply)
- chmod 600 (on your keypair-file just created)

# elastx
- Go back into elastx and see that your setup is completed
- Under instances copy your ipadresses from your server and worker and insert them into the server and worker in **inventory.yml**.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/instances.PNG)

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/inventory.PNG)

## Caprover cluster

- Navigate to CapRover and log in. (in my case https://captain.aras.ejo.one/)
- Go to Cluster and scroll down to "Alternative Method:
- Follow the instructions and run the commands in your terminal in VScode.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/cluster.PNG)

In terminal.

SSH:a into server:
Run:
- sudo docker swarm join-token worker

Take the output: In my case:
- docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Logout from server:

SSH:a into runner:

Run the above output command:
- sudo docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Output
- T- his node joined a swarm as a worker.

Working =)

Navigate back to your Caprover:
In my case:
https://captain.aras.ejo.one/#/login
- Log in with your password

Navigate to cluster. You can now see that you are clustered. Se down below picture:


![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/caprover_cluster.PNG)

# Gitlab deployed on CapRover
https://caprover.com/docs/ci-cd-integration/deploy-from-gitlab.html

**!!! In this project a test repo is added to use, which is to be forked, with the files needed. You can therefore yump to part 3. !!!**

1. Create GitLab Repository

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/aras_gitlab-repo.PNG)

2. Add sample Source code-file, Dockerfile and a .gitlab-ci.yml-file. The content ara copied from the documnet:
https://caprover.com/docs/ci-cd-integration/deploy-from-gitlab.html

The files and content can be seen in this repo.

3. Create CI/CD Variables
Go to your project page on GitLab.
Navigate to Settings > CI/CD.
In Variables add the following variables:

- Key : CAPROVER_URL , Value : https://captain.root.domain.com [replace it with your domain]
- Key : CAPROVER_PASSWORD , Value : mYpAsSwOrD [replace it with your password]
- Key : CAPROVER_APP , Value : my-test-gitlab-deploy [replace it with the app name you want to create]

4.  Create an Access Token for CapRover
Navigate to https://gitlab.com/-/profile/personal_access_tokens and create a token.

Make sure to assign read_registry and write_registry permissions for this token.


5. Add Token to CapRover

Login to your CapRover web dashboard, under Cluster click on Add Remote Registry. Then enter these fields:

- Username: your gitlab username
- Password: your gitlab Token [From the previous step]
- Domain: registry.gitlab.com
- Image Prefix: again, your gitlab username !!!**I needed this to be blanc for it to work**!!!

6. Disable Default Push
Now that you added a registry, CapRover by default wants to push the built artifact to your registry. You do not need this for this project, and it might make your deployments to fail. So go ahead and disable Default Push
**!!!! I did not disable Default push and it worked!**

7. Create a CapRover App
On CapRover "Apps" and create an app:
- aras-gitlab-deploy (in my case. You need to add the name that you set up in part 3. CAPROVER_APP value)

8. Push to your repo
From VSCode and terminal:

- Make some changes in the index.php-file to trigger the push.
- commit and push to your repo. Make sure to commit to master

Wait a little bit until your build is finished and deployed automatically! After a few minutes you can be able to see your deployed app on CapRover!

Open CapRover. Log in if needed.
- Navigate to "Apps"
- Click on open on your app.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/caprover_apps.PNG)

The output from the index.php-file can now be seen:

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/app_output.PNG)