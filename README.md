# misc-scripts
Miscellaneous scripts

`init_env_setup.sh` is a script to initialize and setup the environment needed to run a django project.

To run `init_env_setup.sh` 

`./init_env_setup.sh -p [PROJ_GIT] -u [PROJ_NAME]`

It will inastall nginx, git, pip, gunicorn, virtualenv, Python3.6.4, pyenv

Then clone the project ( you passed as parameter ) , Create a virtual environment for that project.
Then install the requirements from requirements.txt. 