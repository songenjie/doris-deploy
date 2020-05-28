#/bin/bash
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

cat > deploy.yaml << EOF
---
- hosts: all
  gather_facts: no
  become: true
  tasks:
    - name: rsync ${ROLE} files to remote
      copy: src=$CODESOUCE/${ROLE}/lib/ dest=/${STORAGE}/${INSTALLDIR}/${ROLE}/deploy/lib/  owner=root group=root mode=0755
      tags:
        - prepare
    - name: start ${ROLE} service
      shell: systemctl daemon-reload ;systemctl restart ${INSTALLDIR}_${ROLE}.service ; sleep 1 ;
      tags:
        - start
EOF

	cat deploy.yaml
	ansible-playbook deploy.yaml  -i ${IPFILE} -f 100  
	\rm -rf deploy.yaml
