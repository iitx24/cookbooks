cd /var/tmp
RLOG_DIR=$(ls -l /etc/rsyslog.d | wc -l)

if [ "$RLOG_DIR" == "1" ]
	then 
		echo "RSYSLOG DIR exists!!"
		cp graylog2.conf /etc/rsyslog.d/
	else 
		mkdir /etc/rsyslog.d
		cp graylog2.conf /etc/rsyslog.d/
fi

REDHAT_VERSION=$(cat /etc/redhat-release | tr -cd '[[:digit:]]' |cut -c 1)
if [ "$REDHAT_VERSION" == "5" ]
then
	cd /var/tmp
	cp rsyslog.conf-5 /etc/rsyslog.conf
	else
		echo "It is not Redhat Version 5"
fi

REDHAT_VERSION=$(cat /etc/redhat-release | tr -cd '[[:digit:]]' |cut -c 1)
if [ "$REDHAT_VERSION" == "6" ]
then
        cd /var/tmp
        cp rsyslog.conf-6 /etc/rsyslog.conf
        else
                echo "It is not Redhat Version 6"
fi

service syslog stop

service rsyslog restart
