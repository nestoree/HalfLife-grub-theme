# Tema GRUB Half-Life 2

Este repositorio contiene un tema personalizado de GRUB inspirado en Half-Life 2. El tema usa una imagen de fondo con estilo Black Mesa y una configuracion de menu pensada para mostrar las entradas de arranque en la parte izquierda de la pantalla.

## Archivos incluidos

| Archivo | Descripcion |
| --- | --- |
| `background.png` | Imagen de fondo del tema. Es un PNG de 1920x1200 que muestra una composicion de Half-Life 2. |
| `theme.txt` | Archivo de configuracion del tema GRUB. Define la imagen de escritorio, colores, posicion del menu, etiquetas y barra de progreso del temporizador. |
| `install_hl2_theme.sh` | Script de instalacion. Copia el tema a `/boot/grub/themes/hl2-theme`, configura `GRUB_THEME` en `/etc/default/grub` y actualiza la configuracion de GRUB. |

## Instalacion

Ejecuta el script desde este mismo directorio:

```bash
sudo bash install_hl2_theme.sh
```

El script necesita permisos de administrador porque modifica archivos del sistema relacionados con GRUB.

## Que hace el script

1. Comprueba que existan `theme.txt` y `background.png`.
2. Crea el directorio `/boot/grub/themes/hl2-theme`.
3. Copia los archivos del tema a ese directorio.
4. Crea una copia de seguridad de `/etc/default/grub` en `/etc/default/grub.bak` si aun no existe.
5. Elimina cualquier configuracion previa de `GRUB_THEME`.
6. Anade la ruta del nuevo tema:

```bash
GRUB_THEME="/boot/grub/themes/hl2-theme/theme.txt"
```

7. Asegura una resolucion grafica compatible con `GRUB_GFXMODE=auto` si no estaba definida.
8. Actualiza GRUB usando `update-grub` o `grub-mkconfig`, segun la distribucion.

## Desinstalar o restaurar

Para volver a la configuracion anterior, puedes restaurar la copia de seguridad:

```bash
sudo cp /etc/default/grub.bak /etc/default/grub
sudo update-grub
```

En distribuciones que no usan `update-grub`, actualiza GRUB manualmente con el comando correspondiente, por ejemplo:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Personalizacion

Puedes editar `theme.txt` para cambiar la posicion del menu, los colores o los textos mostrados. Si cambias la imagen, manten el nombre `background.png` o actualiza la linea `desktop-image` dentro de `theme.txt`.

## Aviso

Modificar GRUB puede afectar al arranque del sistema. Revisa los cambios antes de reiniciar y conserva siempre la copia de seguridad generada por el script.
