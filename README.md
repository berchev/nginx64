# nginx64
### Description:
Downloading the content of this repo, you will have all needed configuration files required to build a **nginx box** and to test it with tool **Kitchen**

### Files:
- `http/preseed.cfg` - file containing base configuration during the installation process
- `scripts/provision.sh` - bash script which purpose is to configure the box environment
- `template.json` - file which **Packer** use in order to create our box
- `Gemfile` - Specify the the ruby version, and all gems needed for **Kitchen** test
- `.kitchen.yml` - **Kitchen** configuration file
- `test/integration/default/check_pkg.rb` - Script needed to **Kitchen** in order to test whether nginx is installed on your box. 

### Requiered software:
In order to build your box you need to have **Packer** tool installed.

Durring the building process you will need  **Virtualbox** tool installed.

In order to use the already created box you need **Vagrant** tool installed.

Please find Install section below in order to find out how to install **Virtualbox**, **Packer** and **Vagrant**.



### Install Section:
**Note that following instructions have been tested in Ubuntu**

- **Instructions HOW to install `Virtualbox`**
1. Go to [Virtualbox downloads](https://www.virtualbox.org/wiki/Linux_Downloads) choose **Virtualbox** package
2. Type in your terminal: `sudo apt-get install -y virtualbox `

- **Instructions HOW to install `Packer`**
1. Download **Packer** from [here](https://www.packer.io/)
2. Click on following link: [Install Packer](https://www.packer.io/intro/getting-started/install.html) 

- **Instructions how to install `Vagrant`**
1. Download **Vagrant** from [here](https://www.vagrantup.com/downloads.html)
2. Click on following link: [Installing vagrant](https://www.vagrantup.com/docs/installation/)

- **Instructions HOW to build the nginx64 box**
1. Make sure you have at least 2GB free space on your drive before start building of the box.
2. Download the content of **berchev/nginx64** repository: `git clone https://github.com/berchev/nginx64.git`
3. Change to downloaded **nginx64** directory: `cd nginx64`
4. Run command: `packer build template.json` and wait the script to finish
5. Once the script finish type: `ls` and you will see the newly generated file: **ubuntu-1604-vbox.box**

- **Instructions HOW to use the already created nginx64 box**

You have two options here:
1. Option A - add and use the created box locally
2. Option B - add created box to Vagrant cloud and then use it directly from the cloud.

Note that **Option B** have one serious advantage - you can access your box from everywhere! On everyone computer with access to Internet.

**Option A** - Add and use nginx box locally
1. On your terminal type: `vagrant box add --name <box_name> ubuntu-1604-vbox.box` , where `<box_name>` is the name which you pick for your box. For example: nginx64 (it is good approach to use lowercase letters in Linux)
2. On your terminal type: `vagrant init nginx64`, where niginx is the name which we picked in step 1. 
It can be any other name!
`vagrant init nginx64` command will place to the current directory `Vagrantfile`.
3. Type: `vagrant up` in order to power on your box
4. Type: `vagrant ssh` and you will be connected to your box.
5. Type: `exit ` in order to logout
6. Type: `vagrant halt` in order to poweroff the box
7. Type: `vagrant destroy` in order to destroy the created box

**Option B** - Add and use nginx box from Vagrant cloud
1. Create account in the [Vagrant cloud](https://app.vagrantup.com/)
2. Click on **New Vagrant Box**
3. Fill in **Name** field
4. Fill in **Version** and **Description**
5. Add **Provider** and click **continue to upload**
6. Once completed **release version** and your box is ready for download
7. Go to your personal computer terminal and type: `vagrant init -m <your_vagrant_cloud_user>/<name_of_your_box>`
8. Type: `vagrant up` in order to power on your box
9. Type: `vagrant ssh` and you will be connected to your box.
10. Type: `exit ` in order to logout
11. Type: `vagrant halt` in order to poweroff the box
12. Type: `vagrant destroy` in order to destroy the created box

### Prepare your environment for **kitchen**
1. Type: `sudo apt-get install rbenv ruby-dev ruby-bundler`
2. add to your ~/.bash_profile: 
  ```
  eval "$(rbenv init -)"
  true
  export PATH="$HOME/.rbenv/bin:$PATH"
```
3. do `. ~/.bash_profile` in order to apply the changes made in .bash_profile 

4. Change to the directory with `Gemfile` and type: `bundle install` in order to install all needed gems for the test

### Test your box with **kitchen** after creation:
1. Edit `.kitchen.yml` according to your needs.
Note that if your output box file is `ubuntu-1604-vbox.box` and your box name added to vagrant is `nginx64`, you do not need to change anything
2. Type: `bundle exec kitchen list` to list the environment
3. Type: `bundle exec kitchen converge` to build environment with kitchen
4. Type: `bundle exec kitchen verify` to test the created kitchen environment
5. Type: `bundle exec kitchen destroy` in order to destroy the created kitchen environment
6. Type: `bundle exec kitchen test` in order to do steps from 3 to 5 in one command

### TODO
All tasks finished
