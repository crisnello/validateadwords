#!/bin/bash

#-----------------------------------------------------------
#
#  Faz download do arquivo XML para atualizacao no ADWORDS
#
#-----------------------------------------------------------

APP=validateadwords

# Diretorios
export D_HOME=/app/$APP
export D_IMPORT=$D_HOME/import
export D_TMP=$D_HOME/tmp
export D_LOG=$D_HOME/logs

# Arquivos
F_LOG=$D_LOG/validateadwords_download.$(date +'%Y%m%d').log
F_URL=http://xml.magazineluiza.com.br/servico/comparador=25
F_DOWNLOAD=$D_TMP/$APP.wget.$(date +'%Y%m%d%H%M%S')

Log()
{
	echo "$(date +'%Y/%m/%d %H:%M:%S') : $APP - $1" >> $F_LOG
}


Log "Iniciou processo de download"

cd $D_IMPORT
if [ $? -ne 0 ]; then
	Log "Falha no acesso ao diretorio IMPORT ($D_IMPORT)"
	exit
fi

wget -O $F_DOWNLOAD -a $F_LOG $F_URL
if [ $? -ne 0 ]; then
	Log "Falha no download do arquivo ($F_URL)"
	exit
fi

mv $F_DOWNLOAD $D_IMPORT/ML_XML.xml 2>> $F_LOG
if [ $? -ne 0 ]; then
	Log "Falha na tentativa de disponizar o arquivo para processamento ($D_IMPORT/ML_XML.xml)"
	exit
fi

Log "Download efetuado com sucesso"
