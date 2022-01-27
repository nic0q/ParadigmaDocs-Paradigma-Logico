# Laboratorio2 G.Docs

#### Proyecto 2 Paradigmas de la Programación

**Lenguaje**
El presente proyecto está codificado en Swi-prolog versión 8.x.x .

**Ejecución**
Para la correcta ejecución, el proyecto se compone de un archivo llamado **main_27391503_FarfanCheneaux.pl**, el cual debe ser compilado en una versión de Swi-prolog superior o igual a 8.x.x.

**Acerca de los predicados**
El presente proyecto pertence a una saga de 3 paradigmas (Funcional en Scheme | Lógico en Prolog | Orientado a Objetos en Java)
La plataforma ParadigmaDocs es una plataforma de ofimática la cual permite añadir documentos, compartir documento, quitar permisos a un documento editar texto (añadir y eliminar) restaurar versiones de un documento, buscar caracteres en las versiones, buscar y reemplazar caracteres.

```cpp
// 1) Ubicarse en la ruta donde se encuentra el archivo
// 2) Realice una consulta en este, de la forma
consult("main_27391503_FarfanCheneaux.pl").
```

**Nota 1:** Toda la documentación necesaria se encuentra dentro del **main**, ademas cada predicado posee una descripción y en las últimas líneas de **main** se encuentran ejemplos para probar su funcionamiento.

**Nota 2:** Al ejecutar una relación requerida, al ser la lista de ParadigmaDocs muy larga, prolog lo abreviará de la siguiente forma:

```cpp
PD12 = ["Google docs", [20, 12, 2020], [["chuck", "qwerty", [20, 12|...]], ["saul", "1234", [29|...]], ["kim", "4321", [...|...]]], [], [[0, "chuck", "DocChuck"|...], [1, "saul"|...], [2|...], [...|...]]].
```
Para mostrar toda la lista de plataforma, ejecutar el siguiente comando, cada vez que ingrese a la consola de prolog
```cpp
set_prolog_flag(answer_write_options,[max_depth(0)]).
```

**Calificacion Docente (Escala del 1 al 7)**

Código: 7
Informe: 6.6

Made with <3 by Nícolas
