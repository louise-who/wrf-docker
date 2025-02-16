#!/bin/bash

############### Configuracao manual pelo usuario ##########################
export RODADA=00               #Horario da rodada do GFS
export PREV=10                 #Quantidade de dias de previsao
export NPROC=4                 #Quantidade de nucleos para processamento
export CONJUNTO=1             #reservado para futuros testes para ensemble
export RAIZ=/paralelo
export GFS=$RAIZ/WRF/GFS
export MPIRUN=/usr/local/mpich/bin/mpirun
#export GRADS=/opt/grads-2.0.2/bin/grads

#%%%%%%%%%%%%%%%%% configura os dias de previsao %%%%%%%%%%%%%%%%%%%%%%%%%%
#PREVISAO_DATA=`date --date "$PREV days" +"%Y-%m-%d"`
#export DATA=$(date +%Y-%m-%d)-00Z
#echo $PREVISAO_DATA
export RUN_HOURS=`expr $PREV \* 24`
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% configura os diretorios complementares %%%%%%%%%%%%%%%%%
export SCRIPTS=$RAIZ/namelists/operacional
export WRF=$RAIZ/WRF
export WPS=$RAIZ/WPS
export RELATORIOS=$RAIZ/relatorios
export ARWPOST=$RAIZ/ARWpost
#export FIGURAS=$RAIZ/figuras
#export FIGTEMPORARIO=$RAIZ/figuras/temporario
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% configura as datas necessarias %%%%%%%%%%%%%%%%%%%%%%%%%
ano=`grep "start_year" $WRF/run/namelist.input | awk '{ print $3 }'`
ANO_HOJE=`echo $ano | cut -d',' -f1`
mes=`grep "start_month" $WRF/run/namelist.input | awk '{ print $3 }'`
MES_HOJE=`echo $mes | cut -d',' -f1`
dia=`grep "start_day" $WRF/run/namelist.input | awk '{ print $3 }'`
DIA_HOJE=`echo $dia | cut -d',' -f1`

export ANO_HOJE=$ANO_HOJE
export MES_HOJE=$MES_HOJE
export DIA_HOJE=$DIA_HOJE

anofut=`grep "end_year" $WRF/run/namelist.input | awk '{ print $3 }'`
ANO_FUTURO=`echo $anofut | cut -d',' -f1`
mesfut=`grep "end_month" $WRF/run/namelist.input | awk '{ print $3 }'`
MES_FUTURO=`echo $mesfut | cut -d',' -f1`
diafut=`grep "end_day" $WRF/run/namelist.input | awk '{ print $3 }'`
DIA_FUTURO=`echo $diafut | cut -d',' -f1`

export ANO_FUTURO=$ANO_FUTURO
export MES_FUTURO=$MES_FUTURO
export DIA_FUTURO=$DIA_FUTURO
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chmod 777 -R $RELATORIOS
#WRF_F=$(date +"%Y-%m-%d-%T")
cd $WRF/run
#cp rsl.out.0000 $RELATORIOS/$DATA.relatorio.wrf
#echo -n " e finalizou em $WRF_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
#sleep 2
#TESTE_WRF=`cat $RELATORIOS/$DATA.relatorio.wrf | grep "SUCCESS" | awk {'print $3, $4, $5, $6'}`
 # if [ "$TESTE_WRF" == "wrf: SUCCESS COMPLETE WRF" ]; then
  #   echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
 # else
  #   echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
 # fi
chmod 777 -R $WRF/WRF_out
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
##%%%%%%%%%%%%%%%% Gera arquivos ctl e dat para o Grads %%%%%%%%%%%%%%%%%%%%

#### d02 ######
#echo -n "Alterando namelist.ARWpost d02"  >> $RELATORIOS/$DATA.relatorio.geral.txt
cat $SCRIPTS/namelist.ARWpost_d02.base | sed "s/ANO_HOJE/$ANO_HOJE/g;s/MES_HOJE/$MES_HOJE/g;s/DIA_HOJE/$DIA_HOJE/g;s/RODADA/$RODADA/g;s/ANO_FUTURO/$ANO_FUTURO/g;s/MES_FUTURO/$MES_FUTURO/g;s/DIA_FUTURO/$DIA_FUTURO/g" > $SCRIPTS/namelist.ARWpost_d02
cd $SCRIPTS && cp namelist.ARWpost_d02 ../../ARWpost
cd $ARWPOST && mv namelist.ARWpost_d02 namelist.ARWpost
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt
ulimit -s unlimited
#ARWPOST_I=$(date +"%Y-%m-%d-%T")
#echo -n "ARWpost.exe    : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $ARWPOST
#echo -n "iniciou em $ARWPOST_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$ARWPOST/ARWpost.exe # > $RELATORIOS/$DATA.relatorio.arwpost
#ARWPOST_F=$(date +"%Y-%m-%d-%T")
#echo -n " e finalizou em $ARWPOST_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
#TESTE_ARWPOST=`cat $RELATORIOS/$DATA.relatorio.arwpost | grep "Successful" | awk {'print $2, $3, $4, $5'}`
 # if [ "$TESTE_ARWPOST" == "Successful completion of ARWpost" ]; then
  #   echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  #else
   #  echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  #fi

#### d01 ######
#echo -n "Alterando namelist.ARWpost d01"  >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $SCRIPTS
cat $SCRIPTS/namelist.ARWpost_d01.base | sed "s/ANO_HOJE/$ANO_HOJE/g;s/MES_HOJE/$MES_HOJE/g;s/DIA_HOJE/$DIA_HOJE/g;s/RODADA/$RODADA/g;s/ANO_FUTURO/$ANO_FUTURO/g;s/MES_FUTURO/$MES_FUTURO/g;s/DIA_FUTURO/$DIA_FUTURO/g" > $SCRIPTS/namelist.ARWpost_d01
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $SCRIPTS && cp namelist.ARWpost_d01 ../../ARWpost
cd $ARWPOST && mv namelist.ARWpost_d01 namelist.ARWpost

ulimit -s unlimited
#ARWPOST_I=$(date +"%Y-%m-%d-%T")
#echo -n "ARWpost.exe    : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $ARWPOST
#echo -n "iniciou em $ARWPOST_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$ARWPOST/ARWpost.exe  #> $RELATORIOS/$DATA.relatorio.arwpost
#ARWPOST_F=$(date +"%Y-%m-%d-%T")
#echo -n " e finalizou em $ARWPOST_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
#TESTE_ARWPOST=`cat $RELATORIOS/$DATA.relatorio.arwpost | grep "Successful" | awk {'print $2, $3, $4, $5'}`
 # if [ "$TESTE_ARWPOST" == "Successful completion of ARWpost" ]; then
  #   echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
 # else
  #   echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  #fi
chmod 777 -R $WRF/WRF_out
########## Gerando figuras ############################
#####ajuste de nome dos arquivos para o site
#export DATA_HOJE=$(date --date "0 days" +"%Y%m%d")
#export DATA_2=$(date --date "1 days" +"%Y%m%d")
#export DATA_3=$(date --date "2 days" +"%Y%m%d")
#export DATA_4=$(date --date "3 days" +"%Y%m%d")

#cd $SCRIPTS
#echo -n " Gerando figuras para d03" >> $RELATORIOS/$DATA.relatorio.geral.txt
#cd $SCRIPTS
#$SCRIPTS/figuras_d03.sh
#$GRADS -lbcx "figuras_d03.gs"
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

#cd $SCRIPTS
#echo -n " Gerando figuras para d02" >> $RELATORIOS/$DATA.relatorio.geral.txt
#$SCRIPTS/figuras_d02.sh
#$GRADS -lbcx "figuras_d02.gs"
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

#cd $SCRIPTS
#echo -n " Gerando figuras para d01" >> $RELATORIOS/$DATA.relatorio.geral.txt
#$SCRIPTS/figuras_d01.sh
#$GRADS -lbcx "figuras_d01.gs"
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt


