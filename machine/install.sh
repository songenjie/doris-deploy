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

if [ "$2" == "yn0" ]
then 
	STORAGE=data
else
	STORAGE=data0
fi
INSTALLDIR=doris

# judge if has cluser conf
if [ ! -d "${ROOT}/../cluster/${CLUSTER}" ]
then 
	"no such cluster of $CLUSTER conf"
	exit
else
	cp ${ROOT}/../cluster/${CLUSTER}/${ROLE}.conf  ${ENGINEOUTDIR}/${ROLE}/conf/
fi

if [ "${ROLE}" == "fe" ]
then
	cp ${ROOT}/../cluster/${CLUSTER}/start_fe.sh  ${ENGINEOUTDIR}/${ROLE}/bin/

	cat > ${INSTALLDIR}_${ROLE}.service << EOF
[Unit]
Description=${INSTALLDIR}_${ROLE}

[Service]
ExecStart=/${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/bin/start_${ROLE}.sh --{HELPER}  ${HELPER}
Restart=always
StartLimitInterval=0
RestartSec=10
LimitNOFILE=100000000

[Install]
WantedBy=multi-user.target

EOF

	cat > deploy.yaml << EOF
---
- hosts: all
  gather_facts: no
  become: true
  tasks:
    - name: rsync ${ROLE} files to remote
      copy: src=$ENGINEOUTDIR/${ROLE}/ dest=/${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/ owner=root group=root mode=0755
      tags:
        - prepare
    - name: rsync ${ROLE} files to remote
      copy: src=${INSTALLDIR}_${ROLE}.service  dest=/etc/systemd/system/${INSTALLDIR}_${ROLE}.service  owner=root group=root mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/${STORAGE}/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: start ${ROLE} service
      shell: systemctl daemon-reload ;systemctl stop ${INSTALLDIR}_${ROLE}.service ; sleep 10; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/temp_dir ; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/log/* ; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}/storage/* ;  systemctl enable ${INSTALLDIR}_${ROLE}.service ;systemctl start ${INSTALLDIR}_${ROLE}.service ; sleep 1 ;
      tags:
        - start
EOF
	cat deploy.yaml
	cat ${INSTALLDIR}_${ROLE}.service 
	ansible-playbook deploy.yaml  -i $IPFILE -f 100  
	\rm -rf deploy.yaml
	\rm -rf ${INSTALLDIR}_${ROLE}.service
	exit

elif [[ "${ROLE}" == "be" ]] 
then

	cat > ${INSTALLDIR}_${ROLE}.service << EOF
[Unit]
Description=${INSTALLDIR}_${ROLE}

[Service]
ExecStart=/${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/bin/start_${ROLE}.sh
Restart=always
StartLimitInterval=0
RestartSec=10
LimitNOFILE=100000000

[Install]
WantedBy=multi-user.target

EOF
	cat > deploy.yaml << EOF
---
- hosts: all
  gather_facts: no
  become: true
  tasks:
    - name: rsync ${ROLE} files to remote
      copy: src=$ENGINEOUTDIR/${ROLE}/ dest=/${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/ owner=root group=root mode=0755
      tags:
        - prepare
    - name: rsync ${ROLE} files to remote
      copy: src=${INSTALLDIR}_${ROLE}.service  dest=/etc/systemd/system/${INSTALLDIR}_${ROLE}.service  owner=root group=root mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/${STORAGE}/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/data1/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/data2/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/data3/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/data4/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/data5/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/data6/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: create deploy directory
      file: path=/data7/${INSTALLDIR}/${ROLE}/storage state=directory mode=0755
      tags:
        - prepare
    - name: start ${ROLE} service
      shell: systemctl daemon-reload ;systemctl stop ${INSTALLDIR}_${ROLE}.service; sleep 10; bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/log/* ; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}/storage/* ; /bin/rm -rf /data1/${INSTALLDIR}/${ROLE}/storage/* ;/bin/rm -rf /data2/${INSTALLDIR}/${ROLE}/storage/* ;/bin/rm -rf /data3/${INSTALLDIR}/${ROLE}/storage/* ;/bin/rm -rf /data4/${INSTALLDIR}/${ROLE}/storage/* ;/bin/rm -rf /data5/${INSTALLDIR}/${ROLE}/storage/* ;/bin/rm -rf /data6/${INSTALLDIR}/${ROLE}/storage/* ;/bin/rm -rf /data7/${INSTALLDIR}/${ROLE}/storage/* ;systemctl enable ${INSTALLDIR}_${ROLE}.service ;systemctl start ${INSTALLDIR}_${ROLE}.service ; sleep 1 ;
      tags:
        - start
EOF
	#--extra-vars "master=${ROLE} user=${ROLE}"
	cat deploy.yaml
	cat ${INSTALLDIR}_${ROLE}.service 
	ansible-playbook deploy.yaml  -i $IPFILE -f 100  
	\rm -rf deploy.yaml
	\rm -rf ${INSTALLDIR}_${ROLE}.service
	exit

elif [[ "${ROLE}" == "broker" ]] 
then 
	cat > ${INSTALLDIR}_${ROLE}.service << EOF
[Unit]
Description=${INSTALLDIR}_${ROLE}

[Service]
ExecStart=/${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/bin/start_${ROLE}.sh
Restart=always
StartLimitInterval=0
RestartSec=10
LimitNOFILE=100000000

[Install]
WantedBy=multi-user.target

EOF

	cat > deploy.yaml << EOF
---
- hosts: all
  gather_facts: no
  become: true
  tasks:
    - name: rsync ${ROLE} files to remote
      copy: src=$ENGINEOUTDIR/${ROLE}/ dest=/${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/ owner=root group=root mode=0755
      tags:
        - prepare
    - name: rsync ${ROLE} files to remote
      copy: src=${INSTALLDIR}_${ROLE}.service  dest=/etc/systemd/system/${INSTALLDIR}_${ROLE}.service  owner=root group=root mode=0755
      tags:
        - prepare
    - name: start ${ROLE} service
      shell: systemctl daemon-reload ;systemctl stop ${INSTALLDIR}_${ROLE}.service ; sleep 10; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/log/* ; /bin/rm -rf /${STORAGE}/${INSTALLDIR}/${ROLE}/storage/* ;  systemctl enable ${INSTALLDIR}_${ROLE}.service ;systemctl start ${INSTALLDIR}_${ROLE}.service ; sleep 1 ;
      tags:
        - start
EOF

	cat deploy.yaml
	cat ${INSTALLDIR}_${ROLE}.service 
	ansible-playbook deploy.yaml  -i ${IPFILE} -f 100  
	\rm -rf deploy.yaml
	\rm -rf ${INSTALLDIR}_${ROLE}.service
	exit
else
	echo "no such role :${ROLE} in doris cluster"
	exit
fi
