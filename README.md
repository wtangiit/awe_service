awe_service
===========
Enables deployment of AWE server and clients within the kbase release environment

The following are instructions on how to deploy the AWE service in KBase from launching a fresh KBase instance to starting the service...

- Create a security group for your AWE server (this isn't required with the test ports in the Makefile but makes it convenient if you want to change those ports later)<br />
- Using this security group and your key, launch a KBase instance
- Get the awe_service code:<br />
sudo -s<br />
cd /kb<br />
git clone kbase@git.kbase.us:dev_container.git<br />
cd dev_container/modules<br />
(NOTE: currently using https://github.com/jaredbischof/awe_service.git in next command until I get admin rights to github.com/kbase/awe_service repo)<br />
git clone https://github.com/kbase/awe_service.git<br />
cd awe_service<br />

- Need to edit Makefile to configure at least IP and port numbers for your AWE server.

- Deploy AWE:<br />
cd /kb/dev_container<br />
./bootstrap /kb/runtime<br />
source user-env.sh<br />
make deploy<br />
service awe restart<br />

- After deployment has completed, if you've associated an IP with your instance you should be able to confirm that AWE is running by going to either url below (ports are defined in shock.cfg):<br />
site ->  http://[AWE Server IP]:7079/<br />
api  ->  http://[AWE Server IP]:7080/<br />
