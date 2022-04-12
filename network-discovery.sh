#!/bin/bash
clear
figlet "Network Discovery"
echo "Coded By PrasiddhSaxena (@thaten3cod3dguy)"
target=$1
range=`echo $target | cut -d "/" -f 1`
submask=`echo $target | cut -d "/" -f 2`
dot="."

own_ip=`ip route get 1 | cut -d " " -f 7`
check_range=`ping -b $range -c 1 2>/dev/null`
if [ -n "$check_range" ]
then 
	first=`echo $range | cut -d "." -f 1`		
	if [ -n "$first" ]
	then
		second=`echo $range | cut -d "." -f 2`
		if [ -n "$second" ]
		then
			third=`echo $range | cut -d "." -f 3`
			if [ -n "$third" ]
			then 
				fourth=`echo $range | cut -d "." -f 4`
				if [ -n "$fourth" ]
				then 
						touch .report
						if [ "$submask" == "8" ]
						then
							# echo "class A"
							starter=`echo $range | cut -d "." -f 1`
							for (( i=0;i<=255;i++ )){
								for (( j=0;j<=255;j++)){
									for (( k=0;k<=254;k++)){
										if [ "$starter.$i.$j.$k" == "$own_ip" ]
										then 
											continue
										else
											status=`ping $starter.$i.$j.$k -c 2 -b | grep "64 bytes" | cut -d " " -f 4 | cut -d ":" -f 1`
											if [ -z "$status" ]
											then
												echo "$starter.$i.$j.$k           Not Alive"
											else
												echo "$starter.$i.$j.$k           Alive"
												arp_request=`arp $starter.$i.$j.$k | tail -n 1`
												echo "$arp_request" >> .report 
											fi
										fi 
									}
								}
							}
							cat .report | less
							rm -f .report
						elif [ "$submask" == "16" ]
						then
							# echo "Class B"
							starter_1=`echo $range | cut -d "." -f 1`
							starter_2=`echo $range | cut -d "." -f 2`
							starter="$starter_1$dot$starter_2"
							for (( i=0;i<=255;i++ )){
								for (( j=0;j<=254;j++ )){
								if [ "$starter.$i.$j" == "$own_ip" ]
								then 
									continue
								else
									status=`ping $starter.$i.$j -c 1 -b | grep "64 bytes" | cut -d " " -f 4 | cut -d ":" -f 1`
									if [ -z "$status" ]
									then
										echo "$starter.$i           Not Alive"
									else
										echo "$starter.$i.$j           Alive"
										arp_request=`arp $starter.$i.$j | tail -n 1`
										echo "$arp_request" >> .report 
									fi
								fi
								}
							}
							cat .report | less
							rm -f .report

						elif [ "$submask" == "24" ];
						then
							# echo "Class C"
							starter_1=`echo $range | cut -d "." -f 1`
							starter_2=`echo $range | cut -d "." -f 2`
							starter_3=`echo $range | cut -d "." -f 3`
							starter="$starter_1$dot$starter_2$dot$starter_3"
							for (( i=0;i<=254;i++ )){
								if [ "$starter.$i" == "$own_ip" ]
								then 
									continue
								else 
									status=`ping $starter.$i -c 1  -b| grep "64 bytes" | cut -d " " -f 4 | cut -d ":" -f 1`
									if [ -z "$status" ]
									then
										echo "$starter.$i           Not Alive"
									else
										echo "$starter.$i           Alive"
										arp_request=`arp $starter.$i | tail -n 1`
										echo "$arp_request" >> .report 
									fi
								fi
							}
							cat .report | less
							rm -f .report
						else
							echo "Enter ClassFull IP Address"
							rm -f .report
						fi
				
				else
					echo "Invalid IP"
				fi
			else
				echo "Invalid IP"
			fi
		else
			echo "Invalid IP"
		fi
	else 
		echo "Invalid IP"
	fi
else
	echo "Invalid IP Please Check your IP"
fi