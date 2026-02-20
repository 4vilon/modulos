#!/bin/bash
##### Herramientas de busqueda de subdominios #####

subdominios() {
    # Consulta a CRT.SH para obtener los subdominios
    while IFS= read -r domain; do
            echo "Consultando crt.sh para: $domain"
            curl -s "https://crt.sh/?q=%25.${domain}&output=json" | \
                jq -r '.[].name_value' 2>/dev/null | \
                sed 's/\*\.//g' | \
                sort -u | \
                tee -a tmp/crt.txt
        done < "$1"
    # Herramienta subfinder para obtener los subdominios    
    subfinder -dL "$1" -o tmp/subfinder.txt
    # Unimos los resultados y eliminamos duplicados 
    cat tmp/*|sort -u |tee -a tmp/unicos.txt
    # Eliminamos los archivos temporales
    rm tmp/subfinder.txt tmp/crt.txt 

}
