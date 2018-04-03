#!/bin/bash

APP=validateadwords

RETENTION=6

# Diretorios
export D_HOME=/app/$APP
export D_LIB=$D_HOME/lib
export D_ETC=$D_HOME/etc
export D_IMPORT=$D_HOME/import
export D_LOG=$D_HOME/logs
export D_TMP=$D_HOME/tmp

# Arquivos
F_LOG=$D_LOG/validateadwords_expurgo.$(date +'%Y%m%d').log


Log()
{
	echo "$(date +'%Y/%m/%d %H:%M:%S') : $APP - $1" >> $F_LOG
}


#-----------------------------------------------------------
#
#  Remove arquivos de log de download atualizacao no ADWORDS
#
#-----------------------------------------------------------

Log "STEP 1 - Iniciou processo de expurgo arquivos de log"

cd $D_LOG
if [ $? -ne 0 ]; then
	Log "Falha no acesso ao diretorio LOGS ($D_LOG)"
	exit
fi

Log "STEP 1 - Expurgando $(pwd) - \"validateadwords_download.*.log\" ..."

for F_OLD_LOG in $(find . -name "validateadwords_download.*.log" -mtime +$RETENTION)
do
	Log "Removendo $F_OLD_LOG ..."
	rm $F_OLD_LOG
	if [ $? -ne 0 ]; then
		Log "STEP 1 - Falha na remocao do arquivo ($F_OLD_LOG)"
		exit
	fi
done

Log "STEP 1 - Finalizou processo de expurgo arquivos de log"



#-----------------------------------------------------------
#
#  Inicia processo expurgo da base de dados
#
#-----------------------------------------------------------

# Configuracoes
CLASSPATH="$D_LIB/purge_validateadwords.jar:$D_LIB/purge_validateadwords_lib/log4j-1.2.17.jar:$D_LIB/purge_validateadwords_lib/mysql-connector-java-5.1.25-bin.jar"

cd $D_LIB

Log "STEP 2 - Iniciando processo expurgo base de dados"

/usr/lib/jvm/java-6-openjdk/bin/java -Xms256M -Xmx512M -Dfile.encoding=UTF-8 -classpath $CLASSPATH com.likeit.purge.manager.PurgeManager $D_ETC/purge.properties $D_ETC/log4j.properties $D_IMPORT/ >> $F_LOG 2>> $F_LOG

Log "STEP 2 - Processo expurgo base de dados finalizado"


#-----------------------------------------------------------
#
#  Remove arquivos de log de expurgo LOG4J
#
#-----------------------------------------------------------

Log "STEP 3 - Iniciou processo de expurgo arquivos de LOG4J"

cd $D_LOG
if [ $? -ne 0 ]; then
	Log "STEP 3 - Falha no acesso ao diretorio LOGS ($D_LOG)"
	exit
fi

Log "STEP 3 - Expurgando $(pwd) - \"purge_validateadwords.log.*\" ..."

for F_OLD_LOG in $(find . -name "purge_validateadwords.log.*" -mtime +$RETENTION)
do
	Log "STEP 3 - Removendo $F_OLD_LOG ..."
	rm $F_OLD_LOG
	if [ $? -ne 0 ]; then
		Log "STEP 3 - Falha na remocao do arquivo ($F_OLD_LOG)"
		exit
	fi
done

Log "STEP 3 - Finalizou processo de expurgo arquivos de LOG4J"


#-----------------------------------------------------------
#
#  Remove arquivos de log de expurgo
#
#-----------------------------------------------------------

Log "STEP 99 - Iniciou processo de expurgo arquivos de log deste script"

cd $D_LOG
if [ $? -ne 0 ]; then
	Log "STEP 99 - Falha no acesso ao diretorio LOGS ($D_LOG)"
	exit
fi

Log "STEP 99 - Expurgando $(pwd) - \"validateadwords_expurgo.*.log\" ..."

for F_OLD_LOG in $(find . -name "validateadwords_expurgo.*.log" -mtime +$RETENTION)
do
	Log "STEP 99 - Removendo $F_OLD_LOG ..."
	rm $F_OLD_LOG
	if [ $? -ne 0 ]; then
		Log "STEP 99 - Falha na remocao do arquivo ($F_OLD_LOG)"
		exit
	fi
done

Log "STEP 99 - Finalizou processo de expurgo arquivos de log deste script"


