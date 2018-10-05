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
USERS=`grep asgapp /etc/sudoers | wc -l`
UNAME=`uname`
GROUP="ASGAPP" #Group of users adding on server
for file in /etc/passwd                                  \
            /etc/shadow                                  \
            /etc/sudoers                                 \
            /usr/local/etc/sudoers;
do
    [ -f $file ] && cp -p $file $file-$GROUP-$LDATE
done

if [ "$USERS" == "0" ]; then


        echo "%asgapp ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

else
        echo "Group exists in sudoers"
fi

A
echo "Password change for ASGOPS users"
sleep 1


grep "Application Users" /etc/passwd > /var/tmp/pw1

sed 's/\:/  /' /var/tmp/pw1 > /var/tmp/pw2
cat /var/tmp/pw2 | awk '{print $1}' > /var/tmp/UIDList

FILE1='/var/tmp/UIDList'

if [ "Linux" = "$UNAME" ]; then
        for i in `cat $FILE1`
                do
                        for pw1 in `grep $i $FILE1|cut -c1-2`;do  echo $pw1"#7Gs8a" | passwd --stdin "$i";done
                        echo "User $username password changed!"
                done

else
        echo "This is not Valide OS"


fi

#Force user to set password on first login
#if [ "Linux" = "$UNAME" ]; then
#       for i in `cat /var/tmp/UIDList`; do chage -d 0  $i;done
#else
#       for i in `cat /tmp/UIDList`; do passwd -f $i;done
#fi

echo "-------------------------------------------------------"
echo "Following Users PASSWORDS reset to Default "
for i in `cat /var/tmp/UIDList`; do grep $i /etc/passwd;done

rm /var/tmp/UIDList

