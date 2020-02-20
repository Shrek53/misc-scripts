# misc-scripts
**Miscellaneous scripts**

This scripts will help to make your life easy by automating some essential installation and environment setup. 
This scripts are meant to setup the environment and your supplied django project in an UBUNTU machine.  

#Django project setup in ubuntu mechine

`init_env_setup.sh` is a script to initialize and setup the environment needed to run a django project.

To run `init_env_setup.sh` 

`./init_env_setup.sh -p [PROJ_GIT_REPO] -u [PROJ_NAME]`

It will install nginx, git, pip, gunicorn, virtualenv, Python3.6.4, pyenv

Then clone the project ( you passed as parameter ) , Create a virtual environment for that project.
Then install the requirements needed to run your project from `requirements.txt` inside the virtual environment. 
Your Project will be inside projects/ directory and virtual environment for your project will inside the venv 
directory. your virtual environment will be named as `venv_your_project_name` .

After that a service and nginx configuation for you Application will be generated in the associated directory.

#Create AWS server instances with boto3

**Install requirements**

`pip install -r requirements.txt`

**Config AWS credintials**

```
sudo apt install awscli
aws configure
```
Config with relevant info 
```
AWS Access Key ID 
AWS Secret Access Key
Default region name // In our case eu-central-1
Default output format json
```
