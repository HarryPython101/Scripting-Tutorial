#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install perl --force-yes -y

sudo passwd -l root

rootExists=$(grep PermitRootLogin /etc/ssh/sshd_config|wc -l)

if [$rootExists=0]; then
    sudo bash -c 'echo "PermitRootLogin no" >> /etc/ssh/sshd_config'
else
    sudo perl -pi -e 's/.*PermitRootLogin*/PermitRootLogin no/g' /etc/ssh/sshd_config
fi

sudo bash -c 'echo "allow-guest=flase" >> /etc/lightdm/lightdm.conf'

sudo restart lightdm

sudo apt-get install libpam-cracklib --force-yes -y

if [$tallyExists = 0]; then
    sudo bash -c 'echo "auth optional pam_tally.so deny=5 unlock_time=900 onerr=fail audit even_deny_root_account silent" >> /etc/pam/common-auth'
else
    sudo perl -pi -e '/s/.*pam_tally.so.*/auth optional pam_tally.so deny = 5 unlock_time=900 onerr=fail audit even_deny_root_account silent/g' /etc/pam.d/common-auth
fi

cracklibExists=$(grep pam_cracklib.so /etc/pam.d/common-password|wc -l)

if [$cracklibExists=0]; then
    sudo bash -c 'echo "password requisite pam_cracklib.co retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1" >> /etc/pam.d/common-password'
else
    sudo perl -pi -e 's/.*pam_cracklib.so.*/password requisite pam_cracklib.co retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1/g' /etc/pam.d/common-password
fi

