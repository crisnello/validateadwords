﻿# @ validateadwords leiame

1) Diretorios:

Instalacao aplicacao
/app/validateadwords

Area temporaria destinada recepcao de arquivos em tempo de download
/app/validateadwords/tmp

Logs
/app/validateadwords/logs

Backups
/app/validateadwords/backup

Configuracoes
/app/validateadwords/etc

Recepcao de arquivos externos
/app/validateadwords/import

Bibliotecas da aplicacao (jars)
/app/validateadwords/lib


2) Scripts automatizados

Download arquivo com dados para atualizacao.
/app/validateadwords/scripts/validateadwords_download.sh

Remove arquivos de log de download com mais de 7 dias, remove da base arquivos na base de dados com mais de 15 dias
/app/validateadwords/scripts/validateadwords_expurgo.sh

Inicia processo que verifica existencia de arquivos na area
import a cada 10s e processa caso exista.
/app/validateadwords/scripts/validateadwords_batch.sh

Procedimento para inicializacao:
$ cd /app/validateadwords/scripts
$ nohup validateadwords_batch.sh &

Backup do database... expurga arquivos com mais de 3 dias
/app/validateadwords/scripts/validateadwords_db_backup.sh

Backup dos arquivos do filesystem /app/validadeadwords... expurga arquivos com mais de 30 dias
/app/validateadwords/scripts/validateadwords_filesystem_backup.sh

3) Outros

Application Jar
/app/validateadwords/lib/batch_validateadwords.jar

API Jars
/app/validateadwords/lib/batch_validateadwords_lib/

Property API Google Adwords
/app/validateadwords/lib/ads.properties

Configuracao CRONTAB - downloads e expurgo
/app/validateadwords/etc/crontab.rules
