#!/bin/bash

#-----------------------------------------------------------
#
#  Faz backup do banco de dados da aplicacao
#
#-----------------------------------------------------------

APP=validateadwords

RETENTION=2

# Diretorios
D_HOME=/app/$APP
D_BACKUP=$D_HOME/backup
D_IMPORT=$D_HOME/import

# Arquivos
F_BACKUP=$D_BACKUP/${APP}_db_$(date +'%Y%m%d%H%M%S').sql.gz
F_LOG=$D_HOME/logs/validateadwords_db_backup.log

Log()
{
	echo "$(date +'%Y/%m/%d %H:%M:%S') : $APP - $1" >> $F_LOG
}



> $F_LOG
Log "Iniciou processo de backup do DATABASE do $APP"

if [ $(ls -l $D_IMPORT | wc -l) -gt 1 ]; then
	Log "Não é possível executar backup quando o processo de atualização está em execução."
	exit
fi

cd $D_BACKUP
if [ $? -ne 0 ]; then
	Log "Não conseguiu acessar diretorio para criação do backup"
	exit
fi


Log "Criando DATABASE Backup $F_BACKUP"

mysqldump -u root -proot@123  -h localhost validateadwords | gzip -c > $F_BACKUP
if [ $? -ne 0 ]; then
	Log "Falha ao tentar efetuar DUMP do DATABASE"
	exit
fi


Log "Expurgando DATABASE Backup - \"validateadwords_db_*\" ..."

for F_OLD in $(find . -name "validateadwords_db_*" -mtime +$RETENTION)
do

	Log "Removendo $F_OLD ..."
	rm $F_OLD
	if [ $? -ne 0 ]; then
		Log "Falha na remocao do arquivo ($F_OLD)"
		exit
	fi
done

Log "Finalizou processo de backup com sucesso"
