#!/usr/bin/env bash

# Salir inmediatamente si un comando falla
set -e

# Asegurar que el script se ejecute como root
if [ "$EUID" -ne 0 ]; then
  echo "[-] Por favor, ejecuta este script como root (usando sudo)."
  exit 1
fi

THEME_NAME="hl2-theme"
GRUB_THEMES_DIR="/boot/grub/themes"
TARGET_DIR="$GRUB_THEMES_DIR/$THEME_NAME"
GRUB_CONFIG="/etc/default/grub"

echo "[+] Iniciando la instalación del tema GRUB: Half-Life 2..."

# 1. Verificar que los archivos necesarios existen en el directorio actual
if [ ! -f "theme.txt" ] || [ ! -f "background.png" ]; then
  echo "[-] Error: No se encontraron 'theme.txt' o 'background.png' en este directorio."
  echo "    Asegúrate de ejecutar el script desde la carpeta donde guardaste ambos archivos."
  exit 1
fi

# 2. Crear el directorio del tema si no existe
echo "[+] Creando el directorio del tema en $TARGET_DIR..."
mkdir -p "$TARGET_DIR"

# 3. Copiar los archivos del tema
echo "[+] Copiando archivos de configuración e imagen..."
cp theme.txt "$TARGET_DIR/"
cp background.png "$TARGET_DIR/"

# 4. Configurar /etc/default/grub
echo "[+] Modificando $GRUB_CONFIG..."

# Hacer una copia de seguridad por seguridad si no existe una ya
if [ ! -f "${GRUB_CONFIG}.bak" ]; then
  cp "$GRUB_CONFIG" "${GRUB_CONFIG}.bak"
  echo "[+] Se ha creado una copia de seguridad en ${GRUB_CONFIG}.bak"
fi

# Eliminar cualquier línea previa de GRUB_THEME existente
sed -i '/^GRUB_THEME=/d' "$GRUB_CONFIG"

# Añadir la ruta del nuevo tema
echo "GRUB_THEME=\"$TARGET_DIR/theme.txt\"" >> "$GRUB_CONFIG"

# Descomentar o asegurar que la resolución de video sea compatible (opcional pero recomendado)
if ! grep -q "^GRUB_GFXMODE=" "$GRUB_CONFIG"; then
  echo "GRUB_GFXMODE=auto" >> "$GRUB_CONFIG"
fi

# 5. Actualizar GRUB según la distribución de Linux
echo "[+] Actualizando la configuración de GRUB..."
if command -v update-grub &> /dev/null; then
  update-grub
elif command -v grub-mkconfig &> /dev/null; then
  # Para distribuciones basadas en Arch o Fedora
  if [ -f "/boot/grub/grub.cfg" ]; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif [ -f "/boot/efi/EFI/fedora/grub.cfg" ]; then
    grub-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
  else
    echo "[-] No se encontró la ruta por defecto de grub.cfg. Ejecuta manualmente grub-mkconfig."
  fi
else
  echo "[-] Error: No se encontró un comando para actualizar GRUB automáticamente."
  echo "    Por favor, ejecuta el comando de actualización correspondiente a tu distro."
  exit 1
fi

echo "[+] ¡Instalación completada con éxito! Reinicia para ver tu nuevo tema de Half-Life 2."
