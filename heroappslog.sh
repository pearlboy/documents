#!/system/bin/sh

# To make sure same script is not running
LastPID=$(cat /data/local/haRecoveryLastPID)
psStatus=$(ps | grep -c $LastPID)

if [ $psStatus -eq 1 ]; then
	echo "Already another instant is running"
	exit 0
fi

# Set PID for is_runnign script
echo $$ > /data/local/haRecoveryLastPID


# Create Server URL file if not exists
haSVRURL=/data/local/haserverurl
if [ ! -f "$haSVRURL" ]; then
    touch $haSVRURL
fi

# Create Recovery URL file if not exists
haRCRYURL=/data/local/harecoveryurl
if [ ! -f "$haRCRYURL" ]; then
    touch $haRCRYURL
fi

# Recovery Time delay
haRCRYDelayPath=/data/local/harecoverydelay
if [ ! -f "$haRCRYDelayPath" ]; then
    echo "60" >  $haRCRYDelayPath
fi

haRCRYDelay=$(cat $haRCRYDelayPath)

chmod 777 /data/local/ha*

cat /dev/null > /data/local/halog
echo "$(whoami) $(date) Started newly" >> /data/local/halog

# To Check if Ha SmartIPTV apk launched for recovery URL
while :
do
	FQDN=$(cat /data/local/harecoveryurl)
	echo "$(whoami) $(date) Checking for Recovery URL" >> /data/local/halog

	if [ "$FQDN" != "" ]; then
		cat /dev/null > /data/local/harecoveryurl
		echo "$(whoami) $(date) Recovery URL found" >> /data/local/halog
		break
	fi

	sleep $haRCRYDelay
done


# Recvoery action in place
while :
do
	RESP=$(wget -qO- --timeout=1 -U "herodroid" http://$FQDN/api/xhrdev/amialive)

	if [ $RESP == "alive" ]
	then
		pingfailed=0
	else
		((pingfailed+=1))
		
		if [ $pingfailed -gt 5 ]
		then
			echo "$(whoami) $(date) reboot can be called" >> /data/local/halog
			reboot
		fi
	fi

	echo "$(whoami) $(date) $FQDN $RESP TryCount $pingfailed" >> /data/local/halog
	sleep $haRCRYDelay
done