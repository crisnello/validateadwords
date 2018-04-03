#!/bin/bash

#-----------------------------------------------------------
#
#  Inicia processo batch que faz atualizacoes no ADWORDS
#  baseado nos arquivos recebidos no diretorio D_IMPORT
#
#-----------------------------------------------------------

APP=validateadwords

RETENTION=29

# Diretorios
export D_HOME=/app/$APP
export D_LIB=$D_HOME/lib
export D_IMPORT=$D_HOME/import
export D_LOG=$D_HOME/logs

# Arquivos
F_LOG=$D_LOG/validateadwords_batch.$(date +'%Y%m%d').log

# Configuracoes
CLASSPATH="$D_LIB/batch_validateadwords.jar:$D_LIB/new_validateadwords_lib/mail.jar:$D_LIB/new_validateadwords_lib/mysql-connector-java-5.1.8-bin.jar:$D_LIB/new_validateadwords_lib/xstream-1.4.3.jar:$D_LIB/new_validateadwords_lib/ads-lib-1.27.0.jar:$D_LIB/new_validateadwords_lib/ads-lib-axis-1.27.0.jar:$D_LIB/new_validateadwords_lib/adwords-axis-1.27.0.jar:$D_LIB/new_validateadwords_lib/aopalliance-1.0.jar:$D_LIB/new_validateadwords_lib/axis-1.4.jar:$D_LIB/new_validateadwords_lib/commons-beanutils-1.8.3.jar:$D_LIB/new_validateadwords_lib/commons-codec-1.3.jar:$D_LIB/new_validateadwords_lib/commons-collections-3.2.1.jar:$D_LIB/new_validateadwords_lib/commons-configuration-1.7.jar:$D_LIB/new_validateadwords_lib/commons-digester-1.8.1.jar:$D_LIB/new_validateadwords_lib/commons-discovery-0.4.jar:$D_LIB/new_validateadwords_lib/commons-lang-2.5.jar:$D_LIB/new_validateadwords_lib/commons-logging-1.1.1.jar:$D_LIB/new_validateadwords_lib/google-api-client-1.18.0-rc.jar:$D_LIB/new_validateadwords_lib/google-http-client-1.18.0-rc.jar:$D_LIB/new_validateadwords_lib/google-http-client-jackson2-1.18.0-rc.jar:$D_LIB/new_validateadwords_lib/google-oauth-client-1.18.0-rc.jar:$D_LIB/new_validateadwords_lib/guava-jdk5-17.0-rc2.jar:$D_LIB/new_validateadwords_lib/guice-3.0.jar:$D_LIB/new_validateadwords_lib/guice-assistedinject-3.0.jar:$D_LIB/new_validateadwords_lib/guice-multibindings-3.0.jar:$D_LIB/new_validateadwords_lib/httpclient-4.0.1.jar:$D_LIB/new_validateadwords_lib/httpcore-4.0.1.jar:$D_LIB/new_validateadwords_lib/jackson-core-2.1.3.jar:$D_LIB/new_validateadwords_lib/javax.inject-1.jar:$D_LIB/new_validateadwords_lib/jaxrpc-api-1.1.jar:$D_LIB/new_validateadwords_lib/joda-time-1.6.jar:$D_LIB/new_validateadwords_lib/jsr305-1.3.9.jar:$D_LIB/new_validateadwords_lib/log4j-1.2.16.jar:$D_LIB/new_validateadwords_lib/opencsv-1.8.jar:$D_LIB/new_validateadwords_lib/slf4j-api-1.6.1.jar:$D_LIB/new_validateadwords_lib/slf4j-log4j12-1.6.2.jar:$D_LIB/new_validateadwords_lib/wsdl4j-1.6.2.jar"

Log()
{
	echo "$(date +'%Y/%m/%d %H:%M:%S') : $APP - $1" >> $F_LOG
}

Log "Iniciando processo de expurgo"

cd $D_LOG
if [ $? -ne 0 ]; then
        Log "Falha no acesso ao diretorio LOGS ($D_LOG)"
        exit
fi

Log "Expurgando $(pwd) - \"validateadwords_batch*.log\" ..."

for F_OLD_LOG in $(find . -name "validateadwords_batch.*.log" -mtime +$RETENTION)
do

        Log "Removendo $F_OLD_LOG ..."
        rm $F_OLD_LOG
        if [ $? -ne 0 ]; then
                Log "Falha na remocao do arquivo ($F_OLD_LOG)"
                exit
        fi
done

Log "Finalizado processo de expurgo"

cd $D_LIB

Log "Iniciando processo batch"

/usr/lib/jvm/java-6-openjdk/bin/java -Xms256M -Xmx512M -Dfile.encoding=UTF-8 -classpath $CLASSPATH com.validateadwords.batch.inicio.Inicio $D_IMPORT/ >> $F_LOG 2>> $F_LOG

Log "Processo batch finalizado"
