# FPGA Track Lab - how to

This is a brief description of what you need to setup to work in the lab.

## Install the dedicated software

[Go to the following link](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2020-2.html) and install Vivado 2020.2 on you machine.
Free licences are available for 1 month.

## If you want to use git

If you already have git installed on your machine, please ignore this step.

If you work with Windows, download the last git version [from the following link:](https://git-scm.com/downloads).

Once the installation is complete use the dedicated Git Bash terminal to work with your git repository.
You can find it right clicking with the mouse, among the options.

From Linux or MAC, open a terminal and type: 
  > sudo apt-get install git-all

If you don't have apt-get, used the tool dedicated to your specific distribution (yum, dnf.. etc.)

### Github profile and SSH key
If you already have a gihub profile and a public ssh key, please ignore these steps.

[Signup at this link](https://github.com/) to create a new Github profile.


To generate a new SSH key, type in your Git Bash terminal:
  > $ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

On the top right of the Github page, click on your profile icon and select Settings. Go to SSH and GPG key.

In the Git Bash type the command:
  > cat ~/.ssh/id_rsa.pub
 
copy the output in the SSH dedicated space on the Github page and save it.

### Clone the repository
Navigate to the folder where you you like to have you repository.
From the terminal type:
  > git clone git@github.com:AleCamplani/FPGA_track_lab.git
 
  > cd FPGA_track_lab

You are now in the repo.

### Create your own branch
You are now on the main branch, but you will need to work on your own development branch.

To create a new branch type:
  > git checkout -b <an_appropriate_name>

To push the new branch to the remote:
  > git push -u origin <an_appropriate_name>

### Git basic command
The command:
  > git status

shows you on which branch you are, which files you have modified and which file are in the folder but not part of the repo.

The command:
  > git add <name_of_the_file>

is used to add to the repo new files or the files that you have modified

The command:
  > git commit -m "A meaningful but not too long message to explain what I am pushing"

is used to generate the commit, that can will be later shown in the timeline.

The command
  > git push

is used to push your updates to the remote (online).

The command:
> git pull 

is used to pull the updates that somebody else have pushed on the branch.

