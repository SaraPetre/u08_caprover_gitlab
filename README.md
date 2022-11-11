# u08: Iac, CMT & Continuous Deployment
This project have been a teamwork between Daniel Goldmann Lapington, Erik Olsson, Nicklas Thor and Sara Petré

# Files provided for this project
- main.tf
- inventory.yml
- caprov-playbook.yml
- config.json
- README.md (pdf)

Create a directory with the above files, main.tf, inventory.yml, caprov-playbook.yml, config.json, README.md (pdf) added.
From this point we will call this directory (path/to/your/directory)

- Fork the test repo down below to be able to show the CapRover GitLab app deployed from Gitlab
    - https://gitlab.com/SaraPetre/u08_caprover_gitlab

# Installation nedded
### Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Use the installation guide for your operator system.

Verify the installation
- terraform --version

### Ansible
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

Depending of the operating system you are using, choose the right installation from the above guide.

Verify the installation
- ansible --version

# elastx
- Log in to your account with your email and provided password
- Go into API Access.
- Go to Download Openstack RC files

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/api.PNG)

- Move your downloaded RC-file into your file-directory(path/to/your/directory)

'chasacademy-petre-openrc.sh' (example of file name)

# VScode
Open VScode in your path/to/your/directory with the above files.

In terminal:
- source 'chasacademy-petre-openrc.sh' (your downloaded file)
- Write your elastx password, when asked for it, in the terminal

## Terraform

In terminal:
- terraform init
- terraform apply
    - yes (to approve the plan an go ahead with apply)
- chmod 600 caprov_keypair_rsa

# Ansible

- Go back into your elastx account to verify that your setup is completed. Do that by checking under 'Compute Overview'. All your setups should now be seen. 
- Under instances copy your ipadresses from your server and worker, see picture below, and replace the IP-adresses in the inventory.yml-file  **inventory.yml**. Save your changes. See picture down below.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/instances.PNG)

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/inventory.PNG)

Make sure you can ssh into server and worker.
In terminal
SSH into server:
- ssh -i caprov_keypair_rsa ubuntu@xxx.xxx.xxx.xxx (use server ip)
- exit

SSH into worker:
- ssh -i caprov_keypair_rsa ubuntu@xxx.xxx.xxx.xxx (use runner ip)
- exit

Set up your DNS:
- https://developers.cloudflare.com/dns/manage-dns-records/reference/wildcard-dns-records/
- https://www.namecheap.com/support/knowledgebase/article.aspx/597/2237/how-can-i-set-up-a-catchall-wildcard-subdomain/

- To set up the wildcard you need to use your public server IP-adress

- open your config.json-file and add your personal Domain, new password and email.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/config.PNG)

Run ansible:
- ansible-playbook -i inventory.yml caprov-playbook.yml

## CapRover cluster

- In your browser. Navigate to CapRover with your domain name. The domain name can be found in your config.json file "caproverRootDomain" (in my case https://captain.aras.ejo.one/) and log in. 
- Go to Cluster and add 'Add Self-Hosted Registry', see picture down below.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/cluster_2.PNG)

-  scroll down to "Alternative Method:
- Follow the instructions and run the commands in your terminal in VScode.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/cluster.PNG)

In terminal.

SSH:a into server:
Run:
- sudo docker swarm join-token worker

Copy the output: In my case:
- docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Logout from server:
- exit

SSH:a into worker:

Run the above output command that we have copied. Run with sudo!

Example:
- sudo docker swarm join --token SWMTKN-1-4mp0om0q2vxzvjq4zlaitcqm19hh6vwf4uxm1oxlklsuucxkj4-1eepwoybp0iih0kknle9fjugu 91.197.41.163:2377

Output
- T- his node joined a swarm as a worker.

Working =)

Logout from worker:
- exit

Navigate back to your Caprover:
In my case:
https://captain.aras.ejo.one/#/login
- Log in with your password

Navigate to cluster. You can now see that you are clustered. Se down below picture:


![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/caprover_cluster.PNG)

# Gitlab deployed on CapRover

We have based this Gitlab deployment on CapRover on the down below documentation.

https://caprover.com/docs/ci-cd-integration/deploy-from-gitlab.html

**Since this project used a forked repo (https://gitlab.com/SaraPetre/u08_caprover_gitlab), you can jump to part 3, down below!!!**

### 1. Create GitLab Repository

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/aras_gitlab-repo.PNG)

### 2. Add sample Source code-file, Dockerfile and a .gitlab-ci.yml-file. The content ara copied from the documnet:
https://caprover.com/docs/ci-cd-integration/deploy-from-gitlab.html

The files and content can be seen in this repo.

### 3. Create CI/CD Variables

Go to your forked project page on GitLab.

Navigate to Settings > CI/CD.

In Variables add the following variables:

- Key : CAPROVER_URL , Value : https://captain.root.domain.com [replace it with your domain]
- Key : CAPROVER_PASSWORD , Value : mYpAsSwOrD [replace it with your password specified in config.json-file, "newPassword"]
- Key : CAPROVER_APP , Value : my-test-gitlab-deploy [replace it with the app name you want to create]

### 4.  Create an Access Token for CapRover
Navigate to https://gitlab.com/-/profile/personal_access_tokens and create a token. Give it a appropriate name.

Make sure to assign read_registry and write_registry permissions for this token.


### 5. Add Token to CapRover

Login to your CapRover web dashboard, under Cluster click on Add Remote Registry. Then enter these fields:

- Username: your gitlab username
- Password: your gitlab Token [From the previous step]
- Domain: registry.gitlab.com
- Image Prefix: Leave this blank


### 6. Create a CapRover App
On CapRover go to "Apps" and create a new app:
- You need to name the app with the name that you set up in part 3. CAPROVER_APP value.


### 7. Push to your repo
From VSCode and terminal:

- Make some changes in the index.php-file that will be pushed from Gitlab to Caprover app.
- commit and push to your repo, master or main branch. This will trigger the pipeline, CI/CD.

Wait a little bit until your build is finished and deployed automatically! After a few minutes you can be able to see your deployed app on CapRover!

Open CapRover. Log in if needed.
- Navigate to "Apps"
- Click on open on your app.

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/caprover_apps.PNG)

The output from the index.php-file can now be seen:

![steg1](https://gitlab.com/SaraPetre/u08_caprover_gitlab/-/raw/master/images/app_output.PNG)