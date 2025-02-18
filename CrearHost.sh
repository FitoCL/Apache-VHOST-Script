#!/bin/bash
# Author: Fito
#https://github.com/FitoCL copyleft 2011
######################################################## INTRUCCIONES #############################################################
#abre una consola y nos movemos ¡Recuerda como Super Usuario root!					                          #																									                              #
#Para ejecutar el script seguir el ejemplo:											  #
#																  #
#     sh crearhost midominio ipaddress /carpeta/proyecto                                                                          #
#	  Ejemplo: 	crearhost cursosdeservers.org 192.168.1.128 /$HOME/Paginas/proyecto1 					  #
#															          #															 
#Con eso el script configurará el virtual host con la ip de la máquina, el archivo hosts, así como el dominio local.              #
#1- El segundo parametro es opcional, si no envías un segundo parametro, tomará la ip actual de la máquina. 			  #	  
#2 -El tercer parametro es opcional, si no envías un tercer parametro te 							  #							  
#creará el proyecto en la carpeta default de Apache: “/var/www/”.								  #								  
###################################################################################################################################
#Comprobamos que el usuario es root.
if [ $(whoami) != "root" ]; then
	echo "Debes ser root para correr este script."
	echo "Para entrar como root, escribe \"sudo su\" sin las comillas."
	exit 1
fi

############################### CONFIGURACION;################################
if [ -z $1 ]
then
echo "WARNING: Debe ingresar el nombre del dominio"
exit 1
else
DOMINIO=$1
fi

#LAN_INTERFACE_GETIP="$LAN_INTERFACE:0"
#Tomara la interfaz  por defecto "La que estes usando para Internet".
IFAZ=`ifconfig |grep eth |cut -c1-5`
LAN_INTERFACE="$IFAZ"

if [ -z $2 ]
then
LAN_IP=`ifconfig $LAN_INTERFACE |grep inet |cut -d " " -f 12 |cut -d ":" -f 2`
else
LAN_IP=$2
fi

if [ -z $3 ]
then
RUTA="/var/www/"
else
RUTA=$3 
fi 
############################### EXIT CONFIGURACION;#########################
echo "Esta seguro de contninuar si/no:" 
read VAR
if [ "$VAR" = n ] || [ "$VAR" = no ]; then
exit 0
elif [ "$VAR" = s ] || [ "$VAR" = si ]; then
echo --------------------------------------------------------------------------------
echo ------------------------------ Version 1.0 -------------------------------------
echo --------------------------------------------------------------------------------               
echo "-------------------------...Aplicando Cambios-----------------------------------" 
#------------------------------------------------------------------------------------
echo
echo "...Capturando IP $IFAZ $LAN_IP					[ OK ]" 
#------------------------------------------------------------------------------------
echo
echo "CREANDO DIRECTORIO PARA $DOMINIO					[ OK ]"
echo "-------------------------------------------------------------------------------"
#CREAMOS EL DIRECTORIO PARA EL DOMINIO
DIR=$RUTA$DOMINIO
if [ ! -d "$DIR" ]; then
mkdir $DIR
chmod 775 $DIR
echo "...$DIR" "Ha sido creado 					[ OK ]"
else 
echo "ERROR: Se produce un error al crear $DIR 		      [ FAIL ]"
echo "ERROR: $DOMINIO Existente! 					      [ FAIL ]"	
fi

echo "-------------------------------------------------------------------------------"
#------------------------------------------------------------------------------------
echo
#CREAMOS EL DIRECTORIO PARA LA PAGINA DE ERRORES PERSONALIZADAS.
folder=/ERROR
echo "CREANDO CARPETA PAGINA $folder EN $RUTA$DOMINIO			[ OK ]"
echo "-------------------------------------------------------------------------------"
DIR2=$RUTA$DOMINIO$folder
if [ ! -d "$DIR2" ]; then
mkdir $DIR2
chmod 775 $DIR2
echo "...$folder ha sido creado 						[ OK ]"
else 
echo "ERROR: Se produce un error al crear $DIR2          [ FAIL ]"
echo "ERROR: Directorio $folder Existente!				     [ FAIL ]"	
fi

echo "-------------------------------------------------------------------------------"
#------------------------------------------------------------------------------------
echo
echo "...Configurando dominio Local $DOMINIO en /etc/hosts			[ OK ]" 
#Agregar hostname
HN=`sudo hostname |cut -c1-20`
#CREAMOS LA ENTRADA EN /ETC/HOSTS
echo "$LAN_IP	$HN.$DOMINIO	$HN" >> /etc/hosts
#------------------------------------------------------------------------------------
#CREAMOS EL ARCHIVO DE VIRTUAL HOST
touch /etc/apache2/sites-available/$DOMINIO
#------------------------------------------------------------------------------------
echo 
echo "...Configurando HostVirtual en /etc/apache2/sites-available/$DOMINIO	[ OK ]"
#CREAMOS LA ENTRADA EN /ETC/HOSTS ###################################################################
echo "NameVirtualHost *:80
<VirtualHost $LAN_IP:80>
ServerAdmin admin@$DOMINIO
ServerName  *.$DOMINIO
ServerAlias *.$DOMINIO $DOMINIO 


DocumentRoot $RUTA$DOMINIO/
<Directory />
	Options FollowSymLinks
	AllowOverride All
</Directory>

<Directory $RUTA$DOMINIO/>
	Options Indexes FollowSymLinks MultiViews
	AllowOverride All
	Order allow,deny
	allow from all
</Directory>

### Logs del Dominio ###
ErrorLog /var/log/apache2/error-$DOMINIO.log 
# Possible values include: debug, info, notice, warn, error, crit, 
# alert, emerg.
LogLevel warn 
CustomLog /var/log/apache2/access-$DOMINIO.log combined 
#######################################################

### Errores Personalizados ###
### Descomenta #ErrorDocument Para personalizar, Ejemplo: ErrorDocument 400  http://$DOMINIO$folder###
#
#HTTP_BAD_REQUEST#
#ErrorDocument 400 http://$DOMINIO$folder
#HTTP_UNAUTHORIZED#
#ErrorDocument 401 http://$DOMINIO$folder
#HTTP_FORBIDDEN#
#ErrorDocument 403 http://$DOMINIO$folder
#HTTP_NOT_FOUND#
#ErrorDocument 404 http://$DOMINIO$folder
#HTTP_METHOD_NOT_ALLOWED#
#ErrorDocument 405 http://$DOMINIO$folder
#HTTP_REQUEST_TIME_OUT#
#ErrorDocument 408 http://$DOMINIO$folder
#HTTP_GONE#
#ErrorDocument 410 http://$DOMINIO$folder
#HTTP_LENGTH_REQUIRED#
#ErrorDocument 411 http://$DOMINIO$folder
#HTTP_PRECONDITION_FAILED#
#ErrorDocument 412 http://$DOMINIO$folder
#HTTP_REQUEST_ENTITY_TOO_LARGE#
#ErrorDocument 413 http://$DOMINIO$folder
#HTTP_REQUEST_URI_TOO_LARGE#
#ErrorDocument 414 http://$DOMINIO$folder
#HTTP_UNSUPPORTED_MEDIA_TYPE#
#ErrorDocument 415 http://$DOMINIO$folder
#HTTP_INTERNAL_SERVER_ERROR#
#ErrorDocument 500 http://$DOMINIO$folder
#HTTP_NOT_IMPLEMENTED#
#ErrorDocument 501 http://$DOMINIO$folder
#HTTP_BAD_GATEWAY#
#ErrorDocument 502 http://$DOMINIO$folder
#HTTP_SERVICE_UNAVAILABLE#
#ErrorDocument 503 http://$DOMINIO$folder
#HTTP_VARIANT_ALSO_VARIES#
#ErrorDocument 506 http://$DOMINIO$folder

#####################		  Seguridad			#########################
#
# Optionally add a line containing the server version and virtual host
# name to server-generated pages (internal error documents, FTP directory
# listings, mod_status and mod_info output etc., but not CGI generated
# documents or custom error documents).
# Set to 'EMail' to also include a mailto: link to the ServerAdmin.
# Set to one of:  On | Off | EMail
#
ServerSignature Off

#Certificado
#Descomentar para habilitar el uso de certificado
#
#	SSL Engine Switch:
#   Enable/Disable SSL for this virtual host.
#SSLEngine on
#SSLCertificateFile /etc/apache2/ssl/apache.pem
#SSLCertificateFile /etc/ssl/certs/www.fitoes.cl.crt
#SSLCertificateKeyFile /etc/ssl/private/www.fitoes.cl.key


#   SSL Engine Switch:
	#   Enable/Disable SSL for this virtual host.
	#SSLEngine on

	#   A self-signed (snakeoil) certificate can be created by installing
	
	#   SSLCertificateFile directive is needed.
	SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
	SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

</VirtualHost>" > /etc/apache2/sites-available/$DOMINIO
#------------------------------------------------------------------------------------
 echo "------------------------------------------------------------------------------"
#CONFIGURAMOS APACHE
a2ensite $DOMINIO
#------------------------------------------------------------------------------------
echo "-------------------------------------------------------------------------------"
 #RECARGAMOS APACHE
/etc/init.d/apache2 reload
echo
echo "100% Hecho... 								[ OK ]"
#------------------------------------------------------------------------------------
elif [ "$VAR" = "" ]; then
echo "No puede dejarlo en blanco"
else
echo "Lo que escribió no se acepta"
fi
############################## EXIT CONFIGURACION;############################
exit 0
