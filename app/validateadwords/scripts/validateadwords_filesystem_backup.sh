#!/bin/bash

#-----------------------------------------------------------
#
#  Faz backup do filesystem da aplicacao
#
#-----------------------------------------------------------

APP=validateadwords

RETENTION=30

# Diretorios
D_HOME=/app/$APP
D_BACKUP=$D_HOME/backup
D_TMP=~/tmp

# Arquivos
F_BACKUP=$D_TMP/backup/${APP}_filesystem_$(date +'%Y%m%d%H%M%S').tar.gz
F_LOG=$D_HOME/logs/validateadwords_filesystem_backup.log

Log()
{
	echo "$(date +'%Y/%m/%d %H:%M:%S') : $APP - $1" >> $F_LOG
}


> $F_LOG
Log "Iniciou processo de backup do filesystem do $APP"

cd $D_TMP
if [ $? -ne 0 ]; then
	mkdir $D_TMP
	cd $D_TMP
fi

Log "Preparando"
mv $D_BACKUP $D_TMP
if [ $? -ne 0 ]; then
	Log "Falhou ao tentar diretorio de backup para nao inclui-lo"
	exit
fi

cd $D_TMP/backup
if [ $? -ne 0 ]; then
	Log "Não conseguiu acessar diretorio para criação do backup"
	exit
fi


Log "Criando arquivo $F_BACKUP"

cd /
tar czf $F_BACKUP app/$APP/* 
if [ $? -ne 0 ]; then
	Log "Não conseguiu criar o backup"
	exit
fi

mv $D_TMP/backup $D_HOME
if [ $? -ne 0 ]; then
	Log "Falha ao tentar mover diretorio de backup de $D_TMP"
	exit
fi

cd $D_BACKUP
if [ $? -ne 0 ]; then
	Log "Não conseguiu acessar diretorio de backup"
	exit
fi

Log "Expurgando arquivos com mais de $RETENTION dias - \"validateadwords_filesystem_*\" ..."

for F_OLD in $(find . -name "validateadwords_filesystem_*" -mtime +$RETENTION)
do

	Log "Removendo $F_OLD ..."
	rm $F_OLD
	if [ $? -ne 0 ]; then
		Log "Falha na remocao do arquivo ($F_OLD)"
		exit
	fi
done

Log "Finalizou processo de backup com sucesso"
