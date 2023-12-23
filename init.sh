#!/bin/bash

# * Setup KDE personal OS for artoria026
# ! Set for KDE Neon 5.27 x86

# ===================================== Funciones utilitarias ==================================== #
# Colors: defines the different text colors that will be used throughout the script. 
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
RESET="\033[0m"

# Función para verificar si un usuario existe
function check_user {
    if id "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}





# ====================== Definir parametro para la ejecución y configuracion ===================== #
echo -e "${MAGENTA}# -------------------------------- Establecer parametro iniciales -------------------------------- #${RESET}"
# Solicitar al usuario que ingrese un nombre de usuario
while true; do
    echo -ne "${BLUE}Ingrese el nombre de usuario del sistema:${RESET} "
    read USER

    # Verificar si el usuario existe
    if check_user "$USER"; then
        break
    else
        echo -e "${RED}El usuario '${BLUE}$USER${RED}' no existe. Por favor ingrese un usuario válido.${RESET}"
    fi
done

# Continuar con la ejecución
echo -e "${GREEN}El usuario '${BLUE}$USER${GREEN}' existe en el sistema. Continuando con la ejecución...${RESET}"






# Solicitar al usuario que ingrese su nombre de usuario de Git
while true; do
    echo -ne "${CYAN}Ingrese su nombre de usuario de Git:${RESET} "
    read -e GIT_USERNAME

    # Confirmar el nombre de usuario de Git
    echo -ne "${YELLOW}Su nombre de usuario de Git es '${BLUE}$GIT_USERNAME${YELLOW}'. ¿Desea continuar con este nombre? [s/n]${RESET} "
    read CONTINUE

    if [[ $CONTINUE =~ ^[sS]$ ]]; then
        break
    fi
done

# Solicitar al usuario que ingrese su dirección de correo electrónico de Git
while true; do
    echo -ne "${CYAN}Ingrese su dirección de correo electrónico de Git:${RESET} "
    read -e GIT_EMAIL

    # Confirmar la dirección de correo electrónico de Git
    echo -ne "${YELLOW}Su dirección de correo electrónico de Git es '${BLUE}$GIT_EMAIL${YELLOW}'. ¿Desea continuar con esta dirección? [s/n]${RESET} "
    read CONTINUE

    if [[ $CONTINUE =~ ^[sS]$ ]]; then
        break
    fi
done





# ==================================== Inicio de la ejecución ==================================== #
echo -e "${MAGENTA}# ------------------------------------ Inciando con el SETUP! ------------------------------------ #${RESET}"
echo -e "${CYAN}# ----------------------------- FASE 1 ==> Actualizacion de paquetes ----------------------------- #${RESET}"

# Update all the repositories to get the latest version's
echo -e "${CYAN}Actualizando todos los repositorios${RESET}"
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

# Update KDE Neon distribution pkg
echo -e "${CYAN}Actualizando los paquetes de KDE Neon${RESET}"
sudo pkcon refresh -y
sudo pkcon update -y

# Clean up old packages
echo -e "${CYAN}Limpiando paquetes no requeridos/viejos${RESET}"
sudo pkcon repair -y

# User notify of update done
echo -e "${GREEN}El sistema ha sido actualizado correctamente${RESET}"



# =============================== Fase de configuraciones iniciales ============================== #
echo -e "${CYAN}# ----------------------------- FASE 2 ==> Configuraciones generales ----------------------------- #${RESET}"
# Instalar Git
echo -e "${CYAN}Instalando Git...${RESET}"
sudo apt-get update
sudo apt-get install -y git

# Establecer la información de usuario de Git como globales
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

echo -e "${GREEN}La configuración de Git se ha completado correctamente.${RESET}"




# ================================ Fase de instalacion de recursos =============================== #
echo -e "${CYAN}# ---------------------- FASE 3 ==> Instalar recursos esteticos del sistema ---------------------- #${RESET}"



# Comprobar si la carpeta "Resources" existe en el directorio "home" del usuario
if [ -d "/home/$USER/Resources" ]; then
    echo -e "${GREEN}La carpeta 'Resources' ya existe en el directorio 'home' del usuario.${RESET}"
else
    # Crear la carpeta "Resources" en el directorio "home" del usuario
    echo -e "${YELLOW}La carpeta 'Resources' no existe en el directorio 'home' del usuario.${RESET}"
    echo -e "${CYAN}Creando la carpeta 'Resources' en el directorio 'home' del usuario...${RESET}"
    mkdir /home/$USER/Resources
    echo -e "${GREEN}La carpeta 'Resources' se ha creado correctamente en el directorio 'home' del usuario.${RESET}"
fi




# Clonar el repositorio en la carpeta "Resources"
echo -e "${CYAN}Clonando el repositorio en la carpeta 'Resources'...${RESET}"
git clone https://github.com/wsdfhjxc/virtual-desktop-bar /home/$USER/Resources/virtual-desktop-bar
echo -e "${GREEN}El repositorio se ha clonado correctamente.${RESET}"

# Instalar dependencias
echo -e "${CYAN}Instalando dependencias...${RESET}"
cd /home/$USER/Resources/virtual-desktop-bar
./scripts/install-dependencies-ubuntu.sh
echo -e "${GREEN}Las dependencias se han instalado correctamente.${RESET}"

# Instalar applet
echo -e "${CYAN}Instalando applet...${RESET}"
./scripts/install-applet.sh
echo -e "${GREEN}El applet se ha instalado correctamente.${RESET}"

# Eliminar la carpeta creada por el clone
echo -e "${CYAN}Eliminando la carpeta del repositorio clonado...${RESET}"
rm -rf /home/$USER/Resources/virtual-desktop-bar
echo -e "${GREEN}La carpeta del repositorio clonado ha sido eliminada correctamente.${RESET}"






# Clone KDE_setup_resources repository
echo -e "${CYAN}Cloning KDE_setup_resources repository...${RESET}"
cd /home/$USER/Resources
git clone https://github.com/artoria026/KDE_setup_resources.git

echo -e "${GREEN}El repositorio se ha clonado correctamente.${RESET}"





# Create Pictures directory if it does not exist
echo -e "${CYAN}Checking if Pictures directory exists...${RESET}"
if [ ! -d "/home/$USER/Pictures" ]; then
    echo -e "${YELLOW}Pictures directory does not exist, creating it...${RESET}"
    mkdir /home/$USER/Pictures
fi

# Copy Wallpapers folder to Pictures directory
echo -e "${CYAN}Copying Wallpapers folder to Pictures directory...${RESET}"
cp -r /home/$USER/Resources/KDE_setup_resources/Wallpapers /home/$USER/Pictures

echo -e "${GREEN}Wallpapers folder successfully copied to Pictures directory!${RESET}"


# ========================================== Fase final ========================================== #
sudo apt install neofetch -y
neofetch
echo -e "${MAGENTA}# ------------------------------------------ TERMINADO! ------------------------------------------ #${RESET}"