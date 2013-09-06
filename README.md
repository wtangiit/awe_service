awe_service
===========
Enables deployment of AWE server and clients within the kbase release environment.

The following are instructions on how to deploy the AWE service in KBase from launching a fresh KBase instance to starting the service...

- Create a security group for your AWE server (this isn't required with the test ports in the Makefile but makes it convenient if you want to change those ports later)<br />
- Using this security group and your key, launch a KBase instance
- Get the code:<br />
sudo -s<br />
cd /kb<br />
git clone kbase@git.kbase.us:dev_container.git<br />
cd dev_container/modules<br />
git clone kbase@git.kbase.us:awe_service.git<br />
cd awe_service<br />

- Edit the Makefile if you would like to configure the IP and port numbers for your AWE server.

- Create a mongo data directory on the mounted drive and symbolic link to point to it:<br />
(NOTE: mongodb is only required if you are deploying the AWE server, not the client)<br />
cd /mnt<br />
mkdir db<br />
cd /<br />
mkdir data<br />
cd data/<br />
ln -s /mnt/db .<br />

- Start mongod (preferably in screen session):<br />
cd /kb/dev_container<br />
./bootstrap /kb/runtime<br />
source user-env.sh<br />
mongod<br />

(NOTE: mongod needs a few minutes to start.  Once you can run "mongo" from the command line and connect to mongo db, then proceed with deploying AWE)
- Deploy AWE:<br />
cd /kb/dev_container<br />
./bootstrap /kb/runtime<br />
source user-env.sh<br />
make deploy<br />
/kb/deployment/services/awe_service/start_service

- After deployment has completed, if you've associated an IP with your instance you should be able to confirm that AWE is running by going to either url below (ports are defined in Makefile prior to deployment):<br />
site ->  http://[AWE Server IP]:7079/<br />
api  ->  http://[AWE Server IP]:7080/<br />
