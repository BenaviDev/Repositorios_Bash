#!/bin/bash

# Verifica que se pase un argumento (URL o dominio)
if [ -z "$1" ]; then
    echo "Uso: $0 <URL o dominio>"
    exit 1
fi

URL=$1

# Función para mostrar el banner
mostrar_banner() {
    echo -e "\n"
    echo " ██████╗ ███████╗██╗███╗   ██╗████████╗   ██╗  ██╗██╗   ██╗███╗   ██╗████████╗███████╗██████╗ "
    echo "██╔═══██╗██╔════╝██║████╗  ██║╚══██╔══╝   ██║  ██║██║   ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗"
    echo "██║   ██║███████╗██║██╔██╗ ██║   ██║█████╗███████║██║   ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝"
    echo "██║   ██║╚════██║██║██║╚██╗██║   ██║╚════╝██╔══██║██║   ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗"
    echo "╚██████╔╝███████║██║██║ ╚████║   ██║      ██║  ██║╚██████╔╝██║ ╚████║   ██║   ███████╗██║  ██║"
    echo " ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝"
    echo -e "\n🔥 OSINT Scraper Avanzado 🔥"
    echo "📌 Objetivo: $URL"
    echo "----------------------------------------"
}

# Funciones de cada análisis
extraer_correos() {
    echo "📩 Buscando correos electrónicos..."
    curl -s "$URL" | grep -Eo "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" | sort -u > correos.txt
    cat correos.txt
}

extraer_telefonos() {
    echo "📞 Buscando números de teléfono..."
    curl -s "$URL" | grep -Eo "(\+57\s?3[0-9]{2}\s?[0-9]{3}\s?[0-9]{4}|\(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4})" | sort -u > telefonos.txt
    cat telefonos.txt
}

extraer_cedulas() {
    echo "🆔 Buscando posibles números de cédula..."
    curl -s "$URL" | grep -Eo "\b[1-9][0-9]{6,10}\b" | sort -u > cedulas.txt
    cat cedulas.txt
}

analizar_cabeceras() {
    echo "🔍 Analizando cabeceras HTTP..."
    curl -I "$URL" 2>/dev/null
}

detectar_tecnologias() {
    echo "💻 Detectando tecnologías utilizadas..."
    whatweb "$URL"
}

buscar_subdominios() {
    echo "🌍 Buscando subdominios..."
    assetfinder --subs-only "$URL" | tee subdominios.txt
    cat subdominios.txt
}

buscar_archivos_sensibles() {
    echo "🛑 Buscando archivos sensibles..."
    for file in robots.txt sitemap.xml .git .env .htaccess .log;
    do
        status_code=$(curl -s -o /dev/null -w "%{http_code}" "$URL/$file")
        if [ "$status_code" == "200" ]; then
            echo "⚠️ Archivo encontrado: $file"
        fi
    done
}

extraer_redes_sociales() {
    echo "📱 Buscando nombres de usuario en redes sociales..."
    curl -s "$URL" | grep -Eo "(twitter.com|facebook.com|instagram.com|linkedin.com|github.com)/[a-zA-Z0-9_-]+" | sort -u > redes_sociales.txt
    cat redes_sociales.txt
}

extraer_metadatos_imagenes() {
    echo "🖼️ Extrayendo metadatos de imágenes..."
    find . -type f -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" | while read img; do
        echo "📷 $img"
        exiftool "$img"
    done
}

analizar_javascript() {
    echo "🔗 Analizando archivos JavaScript..."
    mkdir -p js_files
    grep -oE "https?://[^\"']+\.js" <(curl -s "$URL") | sort -u | while read js_url; do
        echo "📜 Descargando: $js_url"
        curl -s "$js_url" -o "js_files/$(basename $js_url)"
        grep -E "(api|token|key|auth)" "js_files/$(basename $js_url)"
    done
}

reverso_ip() {
    echo "🕵️ Buscando dominios alojados en la IP..."
    IP=$(dig +short "$URL" | head -n 1)
    if [ -n "$IP" ]; then
        echo "🔹 IP encontrada: $IP"
        host "$IP"
    else
        echo "❌ No se pudo determinar la IP."
    fi
}

# Función para mostrar el menú
mostrar_menu() {
    while true; do
        echo -e "\n🔹 SELECCIONE UNA OPCIÓN 🔹"
        echo "1) Extraer correos electrónicos"
        echo "2) Extraer teléfonos"
        echo "3) Extraer posibles cédulas"
        echo "4) Analizar cabeceras HTTP"
        echo "5) Detectar tecnologías web"
        echo "6) Buscar subdominios"
        echo "7) Buscar archivos sensibles"
        echo "8) Extraer redes sociales"
        echo "9) Extraer metadatos de imágenes"
        echo "10) Analizar archivos JavaScript"
        echo "11) Reverso de IP"
        echo "12) Ejecutar TODO"
        echo "13) Salir"
        echo -n "👉 Opción: "
        read opcion

        case $opcion in
            1) extraer_correos ;;
            2) extraer_telefonos ;;
            3) extraer_cedulas ;;
            4) analizar_cabeceras ;;
            5) detectar_tecnologias ;;
            6) buscar_subdominios ;;
            7) buscar_archivos_sensibles ;;
            8) extraer_redes_sociales ;;
            9) extraer_metadatos_imagenes ;;
            10) analizar_javascript ;;
            11) reverso_ip ;;
            12) 
                extraer_correos
                extraer_telefonos
                extraer_cedulas
                analizar_cabeceras
                detectar_tecnologias
                buscar_subdominios
                buscar_archivos_sensibles
                extraer_redes_sociales
                extraer_metadatos_imagenes
                analizar_javascript
                reverso_ip
                ;;
            13) echo "👋 Saliendo..."; exit 0 ;;
            *) echo "❌ Opción inválida." ;;
        esac
    done
}

# Ejecutar el script con el menú
mostrar_banner
mostrar_menu

