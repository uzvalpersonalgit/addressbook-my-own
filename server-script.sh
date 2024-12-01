sudo yum install java-17-amazon-corretto-devel -y
sudo yum install git -y
sudo yum install maven -y

if [ -d "addressbook-v1-fork-repo" ]
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/addressbook-v1-fork-repo
    git pull origin master
else
    git clone https://github.com/uzvalpersonalgit/addressbook-v1-fork-repo.git
fi
cd /home/ec2-user/addressbook-v1-fork-repo
mvn package