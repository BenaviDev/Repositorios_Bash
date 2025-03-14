#!/bin/bash

# Verifica si jq está instalado
if ! command -v jq &> /dev/null; then
    echo "Instalando jq..."
    sudo apt-get install -y jq
fi

# Definir colores ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # Reset color

# Dibujo ASCII con el nombre "ALIASH"
ASCII_ART="
${RED}    __    __    ____    __    ___  _  _  
${RED}   /__\  (  )  (_  _)  /__\  / __)( \/ ) 
${RED}  /(__)\  )(__  _)(_  /(__)\ \__ \ )  (  
${RED} (__)(__)(____)(____)(__)(__)(___/(_/\_) 
"

# Listado de nombres (200 hombres, 200 mujeres)
NOMBRES_HOMBRES=("Alejandro" "Álvaro" "Andrés" "Antonio" "Benjamín" "Camilo" "Carlos" "Cristian" "Daniel" "David" "Diego" "Eduardo" "Emilio" "Esteban" "Felipe" "Fernando" "Francisco" "Gabriel" "Germán" "Gonzalo" "Jorge" "Juan" "Luis" "Hugo" "Jacobo" "Lucas" "Santiago" "Manuel" "Raúl" "Samuel" "Ricardo" "Simón" "Vicente" "Tomás" "Mateo" "Pablo" "Iván" "Jesús" "Martín" "Leonardo" "Óscar" "Rafael" "Víctor" "Alexis" "Elías" "Fabián" "Giovanni" "Ignacio" "Jonathan" "Kevin" "Lorenzo" "Marcelo" "Nicolás" "Orlando" "Patricio" "René" "Salvador" "Teodoro" "Ulises" "Walter" "Xavier" "Yahir" "Zacarías" "Damián" "Esteban" "Héctor" "Federico" "Ezequiel" "Luciano" "Maximiliano" "Nahuel" "Ramiro" "Bautista" "Emanuel" "Franco" "Gerardo" "Horacio" "Isaac" "Joel" "Matías" "Norberto" "Octavio" "Pancho" "Rodolfo" "Silvio" "Tristán" "Ubaldo" "Wilfredo" "Yeray" "Zenón")

NOMBRES_MUJERES=("Camila" "Valentina" "Mariana" "Daniela" "Sofía" "Isabella" "Gabriela" "Juliana" "Alejandra" "Luciana" "Paula" "Diana" "Andrea" "Karina" "Estefanía" "Lorena" "Natalia" "Vanessa" "Carolina" "Fernanda" "Ángela" "Susana" "Tatiana" "Ximena" "Rosario" "Melisa" "Cristina" "Raquel" "Fabiola" "Marisol" "Liliana" "Renata" "Florencia" "Patricia" "Verónica" "Yolanda" "Zulema" "Bárbara" "Cecilia" "Dolores" "Elsa" "Fátima" "Genoveva" "Hilda" "Inés" "Josefina" "Karla" "Leticia" "Margarita" "Nayeli" "Olga" "Penélope" "Romina" "Selena" "Tamara" "Úrsula" "Virginia" "Wendy" "Yadira" "Zaida")

# Nombres compuestos (100 hombres, 100 mujeres)
NOMBRES_COMPUESTOS_HOMBRES=("Juan Pablo" "Luis Fernando" "Carlos Andrés" "José Manuel" "Juan Sebastián" "Pedro Antonio" "Sergio Alejandro" "Miguel Ángel" "José Luis" "Andrés Felipe" "Diego Armando" "Felipe Andrés" "David Alejandro" "Sebastián Gabriel" "Tomás Eduardo" "Martín Esteban" "Hugo Rafael" "Raúl Ernesto" "Iván Ricardo" "Lucas Mateo")

NOMBRES_COMPUESTOS_MUJERES=("María José" "Ana Sofía" "María Fernanda" "Laura Isabel" "Ana María" "Diana Carolina" "Paula Andrea" "María Paula" "Camila Valentina" "Isabella Sofía" "Valeria Fernanda" "Sofía Isabel" "Clara Lucía" "Rosa Elena" "Teresa Margarita" "Gabriela Susana" "Andrea Patricia" "Verónica Juliana" "Carla Estefanía" "Ximena Alejandra")

# Listado de 400 apellidos aleatorios
APELLIDOS=("Gómez" "Rodríguez" "Martínez" "López" "González" "Hernández" "Ramírez" "Díaz" "Torres" "Vargas" "Jiménez" "Rojas" "Mendoza" "Ortega" "Guerrero" "Castillo" "Medina" "Reyes" "Cortés" "Moreno" "Navarro" "Peña" "Cardona" "Castañeda" "Bermúdez" "Quintero" "Pineda" "Cárdenas" "Mejía" "Salazar" "Villalobos" "Álvarez" "Vélez" "Bautista" "Beltrán" "Cabrera" "Chávez" "Delgado" "Escobar" "Estrada" "Aguilar" "Barrios" "Cano" "Figueroa" "Maldonado" "Padilla" "Suárez" "Tamayo" "Valencia" "Zapata" "Muñoz" "Herrera" "Santos" "Peñaloza" "Arévalo" "Bonilla" "Cepeda" "Franco" "Galindo" "Lara" "Montoya" "Naranjo" "Olaya" "Plaza" "Quesada" "Riveros" "Serrano" "Uribe" "Villegas" "Zambrano" "Espinoza" "Ortiz" "Chaparro" "Varela" "Osorio" "Salinas" "Tapia" "Zúñiga" "Valderrama" "Pizarro" "Linares" "Alarcón" "Villanueva" "Amaya" "Ferreira" "Gálvez" "Bustamante" "Coronado" "Herreros" "Arrieta" "Ferrari" "Valdés" "Monteverde" "Márquez" "Riquelme" "Montenegro")

# Tipos de sangre
TIPOS_SANGRE=("A+" "A-" "B+" "B-" "O+" "O-" "AB+" "AB-")

# Dominios realistas
DOMINIOS=("hotmail.com" "gmail.com" "outlook.com" "yahoo.com" "live.com")

# Mostrar ASCII Art
clear
echo -e "${ASCII_ART}"
echo -e "${CYAN}💀 Generador de Identidades Falsas - ALIASH 💀${NC}"
echo -e "${YELLOW}---------------------------------------------${NC}"

# Archivo donde se guardarán las identidades
OUTPUT_FILE="identidades_falsas.txt"

# Preguntar cuántas identidades generar (máximo 200)
read -p "¿Cuántas identidades falsas deseas generar? (máx 200) " NUM
if (( NUM > 200 )); then
    echo -e "${RED}Error: Solo se pueden generar hasta 200 identidades.${NC}"
    exit 1
fi

echo -e "${GREEN}Generando $NUM identidades ficticias...${NC}"

# Generar identidades en un bucle
for ((i=0; i<NUM; i++)); do
    echo -e "${BLUE}Creando identidad #$((i+1))...${NC}"
    
    # Definir género
    if (( RANDOM % 2 == 0 )); then
        GENERO="Hombre"
        if (( RANDOM % 2 == 0 )); then
            NOMBRE="${NOMBRES_COMPUESTOS_HOMBRES[$RANDOM % ${#NOMBRES_COMPUESTOS_HOMBRES[@]}]}"
        else
            NOMBRE="${NOMBRES_HOMBRES[$RANDOM % ${#NOMBRES_HOMBRES[@]}]}"
        fi
    else
        GENERO="Mujer"
        if (( RANDOM % 2 == 0 )); then
            NOMBRE="${NOMBRES_COMPUESTOS_MUJERES[$RANDOM % ${#NOMBRES_COMPUESTOS_MUJERES[@]}]}"
        else
            NOMBRE="${NOMBRES_MUJERES[$RANDOM % ${#NOMBRES_MUJERES[@]}]}"
        fi
    fi
    
    # Seleccionar dos apellidos aleatorios
    APELLIDO="${APELLIDOS[$RANDOM % ${#APELLIDOS[@]}]} ${APELLIDOS[$RANDOM % ${#APELLIDOS[@]}]}"
    
    # Generar número de cédula aleatorio único
    CEDULA=$(shuf -i 1000000000-1999999999 -n 1)

    # Seleccionar tipo de sangre aleatorio
    TIPO_SANGRE="${TIPOS_SANGRE[$RANDOM % ${#TIPOS_SANGRE[@]}]}"
    
    # Generar correo electrónico
    EMAIL="${NOMBRE// /_}.${APELLIDO// /_}$(shuf -i 10-99 -n 1)@${DOMINIOS[$RANDOM % ${#DOMINIOS[@]}]}"
    
    # Generar número de teléfono colombiano
    TELEFONO="+57 3$(shuf -i 00-99 -n 1) $(shuf -i 100-999 -n 1) $(shuf -i 1000-9999 -n 1)"
    
    # Mostrar la identidad generada
    echo -e "${CYAN}---------------------------------------------${NC}"
    echo -e "${GREEN}Identidad Falsa #$((i+1))${NC}"
    echo -e "${YELLOW}Género: ${WHITE}$GENERO${NC}"
    echo -e "${YELLOW}Nombre: ${WHITE}$NOMBRE $APELLIDO${NC}"
    echo -e "${YELLOW}Cédula: ${WHITE}$CEDULA${NC}"
    echo -e "${YELLOW}Tipo de Sangre: ${WHITE}$TIPO_SANGRE${NC}"
    echo -e "${YELLOW}Correo: ${WHITE}$EMAIL${NC}"
    echo -e "${YELLOW}Teléfono: ${WHITE}$TELEFONO${NC}"
    echo -e "${CYAN}---------------------------------------------${NC}"

    # Guardar en archivo
    echo "$GENERO, $NOMBRE $APELLIDO, $CEDULA, $TIPO_SANGRE, $EMAIL, $TELEFONO" >> "$OUTPUT_FILE"
done

echo -e "${GREEN}✅ Identidades guardadas en ${WHITE}$OUTPUT_FILE${NC}"
read -p "Presiona [ENTER] para salir..."

