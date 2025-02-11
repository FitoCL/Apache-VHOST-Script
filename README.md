# Apache-VHOST-Script
Crear Virtual Host automatizados en Apache


#!/bin/bash
# Author: Fito

######################################################## INTRUCCIONES #############################################################
# abre una consola y nos movemos ¡Recuerda como Super Usuario root!																                                #																					
# Para ejecutar el script seguir el ejemplo:																						                                          #
#																																                                                                  #
#     sh crearhost midominio ipaddress /carpeta/proyecto                                                                          #
#	  Ejemplo: 	crearhost cursosdeservers.org 192.168.1.128 /$HOME/Paginas/proyecto1 											                          #
#																																                                                                  #
#Con eso el script configurará el virtual host con la ip de la máquina, el archivo hosts, así como el dominio local.              #
#1- El segundo parametro es opcional, si no envías un segundo parametro, tomará la ip actual de la máquina. 					            #
#2 -El tercer parametro es opcional, si no envías un tercer parametro te 														                              #
#creará el proyecto en la carpeta default de Apache: “/var/www/”.																                                  #
###################################################################################################################################
