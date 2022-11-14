#!/bin/bash
echo -e "Bienvenido $USER\nAVISO: Esto es un script automatizado para el gestor de paquetes apt utilízalo con cuidado\n\n"

deletelog () {
if [ -a ~/Documentos/Logs/apt.log ];
then
cd ~/Documentos/Logs/
rm -r apt.log
fi
}

deletelog2 () {
if [ -a ~/Documentos/Logs/update.log ];
then
cd ~/Documentos/Logs/
rm -r update.log
fi
}

clean () {
if [ -d ~/Documentos/Logs/ ];
then
deletelog
else
mkdir ~/Documentos/Logs/
fi
sudo apt autoremove --purge >> ~/Documentos/Logs/apt.log
sudo apt autoclean >> ~/Documentos/Logs/apt.log
sudo apt clean >> ~/Documentos/Logs/apt.log
}

update () {
if [ -d ~/Documentos/Logs/ ];
then
deletelog2
else
mkdir ~/Documentos/Logs/
fi
sudo apt update > ~/Documentos/Logs/apt.log
sudo apt list --upgradable > ~/Documentos/Logs/update.log
}

echo "AYUDA"
echo -e "=====\n"
echo -e "Elige Buscar para buscar cualquier paquete\nConsultar permite obtener información de las actualicaciones pendientes\nActualizar permite realizar la instalación de todas las actualizaciones pendientes\nOmitir permite mantener la versión de un determinado paquete instalado\nInstalar permite la instalación de paquetes deb externos indicando la ruta donde se encuentra el paquete\nEs posible interrumpir la ejecución del programa pulsando CTRL+C\nPara salir puedes pulsar q\n"
echo -e "Menú de opciones"
echo -e "================\n"

PS3="Indica una opción (1:Buscar 2:Consultar 3:Actualizar 4:Omitir: 5:Instalar 6:Limpiar 7:Salir): "
select app in Buscar Consultar Actualizar Omitir Instalar Limpiar Salir; 
do
	case $app in
		Buscar)
			#Permite buscar un paquete dentro de los repositorio
			read -p "indica el paquete que quieres buscar: " packagename
			apt search $packagename
			;;
		Consultar)
			#Permite consultar las actualizaciones del sistema
			update > /dev/null
			if [ -a /usr/bin/batcat ];
			then
				batcat ~/Documentos/Logs/update.log
			else
				cat ~/Documentos/Logs/update.log
			fi
			;;
		Actualizar)
			sudo apt full-upgrade -y >> ~/Documentos/Logs/apt.log
			;;
		Omitir)
			#Permite bloquear la actualización de un detrminado paquete
			read -p "indica el paquete que quieres omitir: " package
			sudo apt-mark hold $package >> ~/Documentos/Logs/apt.log
			;;
		Instalar)
			#Permite la instalación de paquetes externos
			read -p "indica la ruta donde se encuentra el paquete: " file
			if [ -a $file ];
			then
			sudo apt install $file >> ~/Documentos/Logs/apt.log
			fi
			;;
		Limpiar)
			clean > /dev/null
			;;
		Salir)
			echo "Hasta pronto $USER..."
			break
			;;
		*)
			echo "opción $REPLY no válida "
			echo "puedes seleccionar 1(Buscar) 2(Actualizar) 3(Buscar) 4(Salir)"
			;;
	esac
done
