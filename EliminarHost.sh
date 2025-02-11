#!/bin/bash
#http://www.facebook.com/fitog2 copyleft 2011
######################################################## INTRUCCIONES #############################################################
#para ejecutar:

#sudo sh quitarhost midominio

############################### CONFIGURACION;################################
#Comprobamos que el usuario es root.
if [ $(whoami) != "root" ]; then
	echo "Debes ser root para correr este script."
	echo "Para entrar como root, escribe \"sudo su\" sin las comillas."
	exit 1
fi


if [ -z $1 ]
then
echo "Debe ingresar el nombre del dominio"
exit 1
else
DOMINIO=$1
fi


###############################################################################

echo "Esta seguro de contninuar s/n:" 
read VAR
if [ "$VAR" = n ]; then
exit 0
elif [ "$VAR" = s ]; then
echo ----------------------------------------------------------------------
echo "----------------------------- Version 1.0 --------------------------- "
echo ----------------------------------------------------------------------               
echo "-------------------------...Aplicando Cambios-------------------------" 
echo
echo "...Elimininado configuarción $DOMINIO			[ OK ]"
#----------------------------------------------------------------------------
echo "----------------------------------------------------------------------" 
#REMOVEMOS DE APACHE
a2dissite $DOMINIO
#----------------------------------------------------------------------------
echo "----------------------------------------------------------------------"
echo
echo "...Borrando $DOMINIO en la configuración APACHE2"	
fil=/etc/apache2/sites-available/$DOMINIO
if [  -f "$fil" ]; then
rm "$fil"
echo
echo "...$DOMINIO" "ha sido borrado...				[ OK ]"
else 
echo "...Se produce un error al borrar $fil en la configuración APACHE2"
echo "...$DOMINIO NO existente!	   		      [ FAIL ]"
fi

echo "...Borrando $DOMINIO en la configuración APACHE2	[ OK ]" 
#BORRAMOS LA CONFIGURACION PARA APACHE
rm /etc/apache2/sites-available/$DOMINIO
echo "----------------------------------------------------------------------"
echo "...Borrando $DOMINIO en el dominio Local		[ OK ]"
#----------------------------------------------------------------------------
#BORRAMOS EL DOMINIO LOCAL
sed  "/$DOMINIO/ d" -i /etc/hosts
#----------------------------------------------------------------------------
echo "----------------------------------------------------------------------"
#RECARGAMOS APACHE
/etc/init.d/apache2 reload
echo
echo "100% Hecho...						[ OK ]"
#------------------------------------------------------------------------------------
elif [ "$VAR" = "" ]; then
echo "No puede dejarlo en blanco"
else
echo "Lo que escribió no se acepta"
fi
############################## EXIT CONFIGURACION;############################
exit 0



