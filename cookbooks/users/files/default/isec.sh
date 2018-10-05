#####################################script start#############################################
#!/bin/bash
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#--
#--  This script was written to change security setting on REDHAT and CENTOS
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
ext=`date '+%Y%m%d-%H:%M:%S'`

for file in /etc/.login                                                 \
            /etc/vsftpd/banner.msg      /etc/vsftpd/ftpaccess           \
            /etc/vsftpd/ftpusers        /etc/pam.d/system-auth          \
            /etc/hosts.allow            /etc/hosts.deny                 \
            /etc/init.d/netconfig       /etc/issue                      \
            /etc/mail/sendmail.cf       /etc/motd                       \
            /etc/pam.conf               /etc/passwd                     \
            /etc/profile                /etc/rmmount.conf               \
            /etc/security/audit_class   /etc/bashrc                     \
            /etc/security/audit_control                                 \
            /etc/security/audit_event                                   \
            /etc/security/audit_startup                                 \
            /etc/security/audit_user                                    \
            /etc/security/policy.conf                                   \
            /etc/shadow         /etc/login.defs                         \
            /etc/ssh/ssh_config         /etc/ssh/sshd_config            \
            /etc/syslog.conf            /etc/sysctl.conf;
do
    [ -f $file ] && cp -p $file $file-preISEC
    [ -f $file ] && cp -p $file $file-preISEC-$ext
done



#ISEC 1.5 - TCP
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
# ISEC 1.1
cp /etc/passwd /tmp
cat /tmp/passwd | grep -v root > /tmp/passwd.1
sed 's/\:/  /' /tmp/passwd.1 > /tmp/passwd.2
for i in `cat /tmp/passwd.2 | awk '{print $1}'`;do passwd -x 9999 $i; done
for i in `cat /tmp/passwd.2 | awk '{print $1}'`;do chage -m 1 $i; done
for i in `cat /tmp/passwd.2 | awk '{print $1}'`;do /usr/bin/chage -d `date +"%Y-%m-%d"` $i;done
chage -m 1 root
rm /tmp/passwd
rm /tmp/passwd.1
rm /tmp/passwd.2

echo "auth        required      pam_listfile.so item=user sense=deny file=/etc/security/user.deny onerr=succeed" >> /etc/pam.d/system-auth
echo "auth        required      pam_tally.so deny=5" >> /etc/pam.d/system-auth
echo "account     required      pam_tally.so" >>  /etc/pam.d/system-auth
touch /etc/security/user.deny

AUTH_FILE=$(ls -l /etc/security/opasswd | grep -v grep |wc -l)
if [ "$AUTH_FILE" == "1" ]
then
	#echo "----------------------------------------------------------------------"
	echo "PASSED : /etc/security/opasswd --------------> FILE FOUND"
else
	#echo "----------------------------------------------------------------------"
	touch /etc/security/opasswd
	chmod 0600 /etc/security/opasswd
	echo "FILE CREATED : /etc/security/opasswd"
fi

touch /var/log/faillog
	
		
# ISEC 2.0

echo "
|-----------------------------------------------------------------|
| This system is for the use of authorized users only.            |
| Individuals using this computer system without authority, or in |
| excess of their authority, are subject to having all of their   |
| activities on this system monitored and recorded by system      |
| personnel.                                                      |
|                                                                 |
| In the course of monitoring individuals improperly using this   |
| system, or in the course of system maintenance, the activities  |
| of authorized users may also be monitored.                      |
|                                                                 |
| Anyone using this system expressly consents to such monitoring  |
| and is advised that if such monitoring reveals possible         |
| evidence of criminal activity, system personnel may provide the |
| evidence of such monitoring to law enforcement officials.       |
|-----------------------------------------------------------------|
" > /etc/issue
scp /etc/issue /etc/motd



# ISEC 1.1 SSH
SSH_CONFIG='/etc/ssh/ssh_config'
SSHD_CONFIG='/etc/ssh/sshd_config'
if [ -e $SSH_CONFIG ]; then
        echo "Securing $SSH_CONFIG"
        grep -v "^Host \*" /etc/ssh/ssh_config-preISEC | grep -v "# Protocol 2,1" \
                > $tmpisec/ssh_config.tmp
awk '/^#.* Host / { print "Host *"; print "Protocol 2"; next };
        /^#.*Port / { print "Port 22"; next };
{ print }' $tmpisec/ssh_config.tmp \
> $tmpisec/ssh_config.tmp2
if [ "`egrep -l ^Protocol $tmpisec/ssh_config.tmp2`" == "" ]; then
        echo 'Protocol 2' >> $tmpisec/ssh_config.tmp2
fi
/bin/cp -pf $tmpisec/ssh_config.tmp2 $SSH_CONFIG
chown root:root $SSH_CONFIG
chmod 0644 $SSH_CONFIG
echo "diff $SSH_CONFIG-preISEC $SSH_CONFIG"
          diff $SSH_CONFIG-preISEC $SSH_CONFIG
else
echo "OK - No $SSH_CONFIG to secure."
fi
if [ -e $SSHD_CONFIG ]; then
        echo "Securing $SSHD_CONFIG"
        # Had to put the " no" in for the RhostsRSAAuthentication source pattern
        # match, as otherwise the change was taking place twice so the file ended
        # up with TWO records like that. The " no" pattern made the one unique.
        # That 2nd record was a combination of comments in the default original file.
        # Some lines ARE duplicated in the original config file, one is commented
        # out, the next one isn't.

        awk '/^#.*Port / { print "Port 22"; next };
                 /^#.*Protocol / { print "Protocol 2"; next };
                 /^#.*LogLevel / { print "LogLevel VERBOSE"; next };
#                 /^#PermitRootLogin / { print "PermitRootLogin no"; next };
                 /^#LoginGraceTime / { print "LoginGraceTime 2m"; next };
#                 /^#StrictModes / { print "StrictModes yes"; next };
                 /^#MaxAuthTries / { print "MaxAuthTries 5"; next };
#                 /^#RhostsRSAAuthentication no / { print "RhostsRSAAuthentication no"; next };
#                 /^#HostbasedAuthentication / { print "HostbasedAuthentication no"; next };
                 /^#.*IgnoreRhosts / { print "IgnoreRhosts yes"; next };
#                 /^#.*PermitEmptyPasswords / { print "PermitEmptyPasswords no"; next };
                 /^#.*Banner / { print "Banner /etc/issue"; next };
                 /^#.*UsePAM / { print "UsePAM yes"; next };
                 /^#.*TCPKeepAlive / { print "TCPKeepAlive yes"; next };
                { print }' /etc/ssh/sshd_config-preISEC \
                > $SSHD_CONFIG
chown root:root $SSHD_CONFIG
chmod 0600 $SSHD_CONFIG
echo "diff $SSHD_CONFIG-preISEC $SSHD_CONFIG"
          diff $SSHD_CONFIG-preISEC $SSHD_CONFIG
else
          echo "OK - No $SSHD_CONFIG to secure."
fi

service sshd restart


#ISEC 1.1
cd /etc
cp login.defs-preISEC* login.defs-preISEC
awk '($1 ~ /^PASS_MAX_DAYS/) { $2="9999" }
         ($1 ~ /^PASS_MIN_DAYS/) { $2="1" }
         ($1 ~ /^PASS_WARN_AGE/) { $2="14" }
         ($1 ~ /^PASS_MIN_LEN/) { $2="8" }
{ print }' login.defs-preISEC > login.defs

diff login.defs-preISEC login.defs

echo "Defaults        logfile=/var/log/sudo.log" >> /etc/sudoers
echo "root" >> /etc/ftpusers
echo "umask 077" >> /etc/bashrc 

