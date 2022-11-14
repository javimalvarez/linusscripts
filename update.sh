#!/bin/bash
echo "Bienvenido $USER.\nAVISO: Esto es un script automatizado para el gestor de paquetes apt utilizalo con cuidado"
deletelog () {
if [ -a ~/Documentos/Logs/apt.log ] || [ -a ~/Documentos/Logs/update.log ];
then
cd ~/Documentos/Logs/
rm -r apt.log update.log
fi
}

clean () {
if [ -d ~/Documentos/Logs/ ];
then
deletelog
else
mkdir ~/Documentos/Logs/
fi
sudo apt autoremove --purge > ~/Documentos/Logs/apt.log
sudo apt autoclean >> ~/Documentos/Logs/apt.log
sudo apt clean >> ~/Documentos/Logs/apt.log
sudo apt update >> ~/Documentos/Logs/apt.log
sudo apt list --upgradable > ~/Documentos/Logs/update.log
}

clean > /dev/null

if [ -a /usr/bin/batcat ];
then
batcat ~/Documentos/Logs/update.log
else
cat ~/Documentos/Logs/update.log
fi

echo "AYUDA"
echo "====="
echo -e "Elige Buscar para buscar cualquier paquete\nActualizar para realizar la istalación de todas las actualizaciones pendientes\nOmitir permite mantener la versión de un terminado paquete instalado\nInstalar permite la instalación de paquetes deb externos indicando la ruta donde se encuentra el paquete\nSalir para salir de este programa\nEs posible interrumpir la ejecución del programa pulsando CTRL+C\nPara salir puedes pulsar q"

PS3="Indica una opción: "
select app in Buscar Actualizar Omitir Instalar Salir; 
do
	case $app in
		Buscar)
			read -p "indica el paquete que quieres buscar: " packagename
			apt search $packagename
			;;
		Actualizar)
			sudo apt full-upgrade -y >> ~/Documentos/Logs/apt.log
			;;
		Omitir)
			read -p "indica el paquete que quieres omitir: " package
			sudo apt-mark hold $package >> ~/Documentos/Logs/apt.log
			;;
		Instalar)
			read -p "indica la ruta donde se encuentra el paquete: " file
			if [ -a $file ];
			then
			sudo apt install $file >> ~/Documentos/Logs/apt.log
			fi
			;;
		Salir)
			echo "Hasta pronto..."
			break
			;;
		*)
			echo "opción $REPLY no válida "
			echo "puedes seleccionar 1(Buscar) 2(Actualizar) 3(Buscar) 4(Salir)"
			;;
	esac
done
