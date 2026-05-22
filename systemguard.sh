#!/bin/bash
# ============================================
#   SystemGuard — Linux Service Auditor
#   Autor: Roxana
#   Descripción: Audita servicios del sistema
#   detectando activos, fallidos y sospechosos
# ============================================

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# ============================================
#   BANNER
# ============================================
clear
echo -e "${CYAN}"
echo "  ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗"
echo "  ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║"
echo "  ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║"
echo "  ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║"
echo "  ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║"
echo "  ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝"
echo -e "${NC}"
echo -e "${BLUE}        🛡️  Linux Service Auditor v1.0${NC}"
echo -e "${BLUE}        by Roxana | github.com/roxana${NC}"
echo ""
echo -e "${YELLOW}  Fecha: $(date '+%d/%m/%Y %H:%M:%S')${NC}"
echo -e "${YELLOW}  Host:  $(hostname)${NC}"
echo -e "${YELLOW}  User:  $(whoami)${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
# ============================================
#   BANNER
# ============================================
clear
echo -e "${CYAN}"
echo "  ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗"
echo "  ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║"
echo "  ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║"
echo "  ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║"
echo "  ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║"
echo "  ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝"
echo -e "${NC}"
echo -e "${BLUE}        🛡️  Linux Service Auditor v1.0${NC}"
echo -e "${BLUE}        by Roxana | github.com/roxana${NC}"
echo ""
echo -e "${YELLOW}  Fecha: $(date '+%d/%m/%Y %H:%M:%S')${NC}"
echo -e "${YELLOW}  Host:  $(hostname)${NC}"
echo -e "${YELLOW}  User:  $(whoami)${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
# ============================================
#   MÓDULO 1 — SERVICIOS FALLIDOS
# ============================================
echo -e "${RED}  ✖  SERVICIOS FALLIDOS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

FAILED=$(systemctl --failed --no-legend --no-pager | awk '{print $2}')

if [ -z "$FAILED" ]; then
    echo -e "  ${GREEN}✔  No se encontraron servicios fallidos${NC}"
else
    echo -e "  ${RED}⚠  Servicios con errores detectados:${NC}"
    echo ""
    while IFS= read -r service; do
        echo -e "  ${RED}✖${NC}  $service"
    done <<< "$FAILED"
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
# ============================================
#   MÓDULO 2 — SERVICIOS ACTIVOS
# ============================================
echo -e "${GREEN}  ✔  SERVICIOS ACTIVOS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

systemctl list-units --type=service --state=running --no-legend --no-pager \
| awk '{print $1}' \
| while read -r service; do
    echo -e "  ${GREEN}✔${NC}  $service"
done

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
# ============================================
#   MÓDULO 3 — SERVICIOS SOSPECHOSOS
# ============================================
echo -e "${YELLOW}  ⚠  SERVICIOS SOSPECHOSOS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Lista de servicios a vigilar
SUSPICIOUS=(
    "telnet"
    "rsh"
    "rlogin"
    "ftp"
    "vsftpd"
    "apache2"
    "nginx"
    "mariadb"
    "mysql"
    "postgresql"
    "gnome-remote-desktop"
    "sshd"
    "xrdp"
)

encontrado=0
for service in "${SUSPICIOUS[@]}"; do
    if systemctl is-active --quiet "${service}.service" 2>/dev/null; then
        echo -e "  ${YELLOW}⚠${NC}  ${service}.service — activo, revisar exposición"
        encontrado=1
    fi
done

if [ $encontrado -eq 0 ]; then
    echo -e "  ${GREEN}✔  No se detectaron servicios de riesgo activos${NC}"
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
# ============================================
#   RESUMEN FINAL + GUARDAR REPORTE
# ============================================
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT="reports/audit_${TIMESTAMP}.txt"

echo -e "${CYAN}  📋  RESUMEN${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

TOTAL_ACTIVOS=$(systemctl list-units --type=service --state=running --no-legend --no-pager | wc -l)
TOTAL_FALLIDOS=$(systemctl --failed --no-legend --no-pager | grep -c "failed" || echo 0)

echo -e "  ${GREEN}✔  Servicios activos:   ${TOTAL_ACTIVOS}${NC}"
echo -e "  ${RED}✖  Servicios fallidos:  ${TOTAL_FALLIDOS}${NC}"
echo ""
echo -e "  ${YELLOW}💾  Guardando reporte en: ${REPORT}${NC}"

# Guardar reporte en texto plano
{
    echo "SystemGuard — Reporte de Auditoría"
    echo "Fecha: $(date)"
    echo "Host:  $(hostname)"
    echo "User:  $(whoami)"
    echo "=================================="
    echo ""
    echo "SERVICIOS FALLIDOS:"
    systemctl --failed --no-legend --no-pager | awk '{print $2}'
    echo ""
    echo "SERVICIOS ACTIVOS:"
    systemctl list-units --type=service --state=running --no-legend --no-pager | awk '{print $1}'
} > "$REPORT"

echo ""
echo -e "${GREEN}  ✔  Reporte guardado correctamente${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}        SystemGuard finalizado · $(date '+%H:%M:%S')${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""