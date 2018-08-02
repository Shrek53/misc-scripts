#!/usr/bin/env bash
while getopts p:n: option
do
case "${option}"
in
p) PROJ_GIT=${OPTARG};;
n) PROJ_NAME=${OPTARG};;
esac
done

#........................Helper Functions......................#
function find_wsgi_application
{
	val=$(pwd)$(find . \( -name 'settings.py' -or -name 'local.py' -or -name 'development.py' -or -name 'production.py' \) | cut -b 3-)
	val1=$(cat $val | grep WSGI_APPLICATION | cut -d "=" -f 2)
	val2=$(echo $val1 | cut -b 1-)
	val3=($val2)
	val4=$(echo $val3 | cut -c 2- | sed -e "s/.application'//g")":application"
	eval "$1=$val4"
}

echo "=========================Initiating environment setup============================="
sudo apt-get update
sudo apt-get install nginx
sudo apt-get install git
sudo apt-get install python-pip
sudo pip install --upgrade pip
sudo pip install gunicorn
sudo pip install virtualenv
mkdir projects
cd projects
echo "========= Did you add your ssh public key to the git repository ? (Y/N) =========="
read user_response

if [[ $user_response == 'Y'  ||  $user_response == 'y' ]]; then
    echo $user_response
    git clone $PROJ_GIT $PROJ_NAME
    cd $PROJ_NAME
    proj_loc=$(pwd)
    wsgi_application=find_wsgi_application
    cd ..
else
    echo "========== Please add your ssh public key to the git repository ============"
    sleep 1
    exit
fi

cd ~
sudo apt-get install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
export PATH="/home/shrek53/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.6.4

if [ ! -d "venv" ]; then
    mkdir venv
fi

cd venv
venv_name=venv_$PROJ_NAME
pyenv local 3.6.4
if [ ! -d $venv_name ]; then
    virtualenv -p python3.6 $venv_name
fi

cd $venv_name
venv_loc=$(pwd)
pip install -r requirements.txt

cd ~

echo "==================== Create a service for your project ==================="
echo "enter service name"
read service_name
user_name=$(whoami)
echo "enter number of worker"
read number_of_workers

find_wsgi_application wsgi_application

##-----------------------------creating service file-----------------------------##

service_file_name=/etc/systemd/system/$service_name'.service'
sudo touch $service_file_name

sudo echo "
[Unit]
Description = $service_name
After = network.target

[Service]
Restart=on-failure
User = $user_name
Group = www-data
WorkingDirectory = $proj_loc
Environment=\"PATH=$venv_loc/bin\"
ExecStart = $venv_loc/bin/gunicorn --workers $number_of_workers --bind unix:$proj_loc/server.sock $wsgi_application --timeout 180

[Install]
WantedBy = multi-user.target
" | sudo tee -a $service_file_name

echo "==========================ALL SET========================"