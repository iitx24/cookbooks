#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#--
#--  This script was written to create multipal ID on REDHAT and SOLARIS
#--
#------------------------------------------------------------------------------
#-- Script Change History:
#-- Script Version V1.1
#--
#--    DATE      NAME   COMMENTS
#-- ----------  ------  ------------------------------------------------
#-- 05-08-2012   Anil Mane  Original Script created, and tested.
#--
#------------------------------------------------------------------------------
#Backup config files

LDATE=`date '+%Y%m%d-%H:%M:%S'`
HOSTNAME=`hostname`
USERS=`grep cpads /etc/sudoers | wc -l`
UNAME=`uname`
GROUP="ASGOPS" #Group of users adding on server
for file in /etc/passwd                                  \
            /etc/shadow                                  \
            /etc/sudoers                                 \
            /usr/local/etc/sudoers;
do
    [ -f $file ] && cp -p $file $file-$GROUP-$LDATE
done

if [ "$USERS" == "0" ]; then


        echo "%cpads ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

else
        echo "Group already added in SUDOERS"
fi

echo "grep cpads /etc/sudoers" 
