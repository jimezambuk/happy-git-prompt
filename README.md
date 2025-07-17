# happy-git-prompt

Mejora a la configuración del prompt de Bash para mostrar información de Git.

## Imágenes

_Prompt_ en directorio sin Git
![Directorio sin Git](docs/images/prompt-without-git.png)

_Prompt_ en directorio con Git
![Directorio con Git](docs/images/prompt-with-git.png)

_Prompt_ en directorio con estado de Git (archivos nuevos y _stash_)
![Directorio con Git](docs/images/prompt-with-git-untracked-stashed.png)

_Prompt_ después de la ejecución de un comando con error
![Directorio sin Git](docs/images/prompt-with-error.png)

## Instalación

Clonar el repositorio en la ubicación que se desee.

``` bash
$ cd ~/apps/

$ git clone https://github.com/jimezambuk/happy-git-prompt.git
```

Configurar el inicio del _script_ al iniciar sesión.  Para hacer esto, editar el archivo `~/.bashrc`.

``` bash
$ vi ~/.bashrc
```

Agregar las siguientes instrucciones al final del archivo `~/.bashrc`, ajustando antes que la ruta indicada por la variable `$HAPPY_GIT_PROMPT` coincida con el lugar donde se instaló el software.

``` bash
HAPPY_GIT_PROMPT=~/apps/happy-git-prompt/happy-git-prompt.sh

if [ -f "$HAPPY_GIT_PROMPT" ]; then
  . "$HAPPY_GIT_PROMPT"
else
  echo "ERROR: happy-git-prompt is missing"
fi
```

Una vez hecho este cambio, aplicará para los _shells_ que abra posteriormente.  Si desea que aplique para el _shell_ actual puede ejecutar el siguiente comando.

``` bash
$ source ~/.bashrc
```

## Solución de errores

Si hay problemas con el uso del _script_, verificar que los siguientes elementos estén correctos.

- La variable `$HAPPY_GIT_PROMPT` definida en `~/.bashrc` tenga la ruta correcta, apuntando hacia el archivo `happy-git-prompt.sh`.

- La variable `$GIT_SH_PROMPT` definida en `happy-git-prompt.sh` tenga la ruta correcta, apuntando hacia el archivo `git-sh-prompt` (por defecto `/usr/lib/git-core/git-sh-prompt`).  Este archivo debe venir con su distribución de Git.
