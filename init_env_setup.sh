#!/usr/bin/env bash
while getopts p:n: option
do
case "${option}"
in
p) PROJ_GIT=${OPTARG};;
n) PROJ_NAME=${OPTARG};;
esac
done

echo "==============Initiating environment setup==============="

sudo apt-get update
sudo apt-get install nginx
sudo apt-get install git
sudo apt-get install python-pip
sudo pip install --upgrade pip
sudo pip install gunicorn
sudo pip install virtualenv
mkdir projects
cd projects
echo "=== Did you add your ssh public key to the git repository ? (Y/N) ==="
read user_response

if [[ $user_response == 'Y'  ||  $user_response == 'y' ]]; then
    echo $user_response
    git clone $PROJ_GIT $PROJ_NAME
else
    echo "====== Please add your ssh public key to the git repository ======"
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

echo "==========================ALL SET========================"
