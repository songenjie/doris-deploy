#!/bin/bash
if [ $# != 5 ] || [ "$1" == "--help" ]
then 
	echo "
	1 fe/be/broker
	2 cluster
	3 masteip:editport
	4 build output dir
	5 deploy ips file
	"
	exit
fi

# set env 
ROOT=`dirname "$0"`
ROOT=`cd "$ROOT"; pwd`
echo  $PWD
ROLE=$1
CLUSTER=$2
HELPER=$3
ENGINEOUTDIR=$4
IPFILE=$5

if [ "$2" == "cluster sp" ]
then 
	STORAGE=data
else
	STORAGE=data0
fi
INSTALLDIR=doris

if [ "${ROLE}" == "fe" ]
then 

	cat > deploy.yaml << EOF
---
- hosts: all
  gather_facts: no
  become: true
  tasks:
    - name: start ${ROLE} service
      shell: systemctl daemon-reload ;systemctl stop ${INSTALLDIR}_${ROLE}.service ; sleep 10; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}  ;
      tags:
        - start
EOF

	cat deploy.yaml
	cat ${INSTALLDIR}_${ROLE}.service 
	ansible-playbook deploy.yaml  -i ${IPFILE} -f 100  
	\rm -rf deploy.yaml
	\rm -rf ${INSTALLDIR}_${ROLE}.service
	exit

elif [[ "${ROLE}" == "be" ]] 
then
	cat > deploy.yaml << EOF
---
- hosts: all
  gather_facts: no
  become: true
  tasks:
    - name: start ${ROLE} service
      shell: systemctl daemon-reload ;systemctl stop ${INSTALLDIR}_${ROLE}.service; sleep 10; bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE} ; /bin/rm -rf /data1/${INSTALLDIR}/${ROLE} ;/bin/rm -rf /data2/${INSTALLDIR}/${ROLE};/bin/rm -rf /data3/${INSTALLDIR}/${ROLE}/ ;/bin/rm -rf /data4/${INSTALLDIR}/${ROLE} ;/bin/rm -rf /data5/${INSTALLDIR}/${ROLE} ;/bin/rm -rf /data6/${INSTALLDIR}/${ROLE} ;/bin/rm -rf /data7/${INSTALLDIR}/${ROLE} ;
      tags:
        - start
EOF
	#--extra-vars "master=${ROLE} user=${ROLE}"
	cat deploy.yaml
	cat ${INSTALLDIR}_${ROLE}.service 
	ansible-playbook deploy.yaml  -i ${IPFILE} -f 100  
	\rm -rf deploy.yaml
	\rm -rf ${INSTALLDIR}_${ROLE}.service
	exit

elif [[ "${ROLE}" == "broker" ]] 
then 

	cat > deploy.yaml << EOF
---
- hosts: all
  gather_facts: no
  become: true
  tasks:
    - name: start ${ROLE} service
      shell: systemctl daemon-reload ;systemctl stop ${INSTALLDIR}_${ROLE}.service ; sleep 10; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}  ;
      tags:
        - start
EOF

	cat deploy.yaml
	ansible-playbook deploy.yaml  -i ${IPFILE} -f 100  
	\rm -rf deploy.yaml
	exit
else
	echo "no such method"
	exit
fi
