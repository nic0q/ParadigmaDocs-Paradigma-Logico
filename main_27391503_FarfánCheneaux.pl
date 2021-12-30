/*__           ___      .______        ___   
 |  |         /   \     |   _  \      |__ \  
 |  |        /  ^  \    |  |_)  |        ) | 
 |  |       /  /_\  \   |   _  <        / /  
 |  `----. /  _____  \  |  |_)  |  __  / /_  
 |_______|/__/     \__\ |______/  (__)|____|                                           
   _______       _______    ______     ______      _______.
  /  _____|     |       \  /  __  \   /      |    /       |
 |  |  __       |  .--.  ||  |  |  | |  ,----'   |   (----`
 |  | |_ |      |  |  |  ||  |  |  | |  |         \   \    
 |  |__| |  __  |  '--'  ||  `--'  | |  `----..----)   |   
  \______| (__) |_______/  \______/   \______||_______/    

-> Nícolas Farfán Cheneaux, sección RG 2021/2
-> Breve Descripción:
  * Proyecto N°2 del Ramo Paradigmas de la Programacion, el cual consiste en crear una plataforma de ofimatica o de manejo de documentos compartidos, en los cuales un usuario 
  debe antes registrarse en la plataforma llamada ParadigmaDocs, para realizar cualquiera de estas operaciones, ademas sobre estos documentos se pueden realizar operaciones colaborativas 
  como ver los cambios hechos en una version anterior, restaurar esta como activa, otorgar diversos permisos a otros usuarios miembros de ParadigmaDocs del tipo: escritura, lectura, 
  comentarios, compartir, tambien se puede editar el texto/contenido de cualquier version de este, añadiendo o eliminando caracteres, además sobre estos documentos es posible buscar 
  palabras/caracteres en específico y ver en que documento se encontró coincidencias, incluso reemplazar todas las coincidencias por otro caracter automaticamente tambien es posible 
  visualizar una version string mas estructurada, entendible y didactica que muestra todo el contenido de ParadigmaDocs o de un usuario en particular.

-------------------------------------------TDA DATE--------------------------------------------------
Dominios:
    Cantidad_dias, DD, MM, YYYY:      Entero

Predicados:
    mes (MM, Cantidad_dias)           aridad: 2
    date(DD,MM,YYYY)                  aridad: 3
    getDay([DD,MM,YYYY],DD)           aridad: 2
    getMonth([DD,MM,YYYY],MM)         aridad: 2
    getYear([DD,MM,YYYY],YYYY)        aridad: 2
--------------------------------------------- Representacion ------------------------------------------
El TDA Date se representa a traves de una lista de 3 enteros de la forma dia X mes X año (integer X integer X integer)
Clausulas:
  Hechos:*/

mes(1,31). mes(2,28). mes(2,29). mes(3,31). mes(4,30). mes(5,31). mes(6,30). mes(7,31). mes(8,31). mes(9,30). mes(10,31). mes(11,30). mes(12,31).
mesString(1,"Enero"). mesString(2,"Febrero"). mesString(3,"Marzo"). mesString(4,"Abril"). mesString(5,"Mayo"). mesString(6,"Junio"). mesString(7,"Julio").
mesString(8,"Agosto"). mesString(9,"Septiembre"). mesString(10,"Octubre"). mesString(11,"Noviembre"). mesString(12,"Diciembre").

% getDay: Predicado que obtiene los dias de una fecha
getDay([DD,_,_],DD).
% getMonth: Predicado que obtiene los meses de una fecha
getMonth([_,MM,_],MM).
% getYear: Predicado que obtiene los años de una fecha
getYear([_,_,YYYY],YYYY).

% Reglas:

% date: Predicado Constructor de fecha
date(DD, MM, YYYY, Date):-
  integer(DD), integer(MM), integer(YYYY),mes(MM,DDs),
  DD=<DDs,
  Date = [DD, MM, YYYY].
  
/*-------------------------------------------TDA PARADIGMADOCS--------------------------------------------------
Dominios:
    Nombre:                                                                   String
    Date:                                                                     Date
    Registrados, Logeados, Documentos, UpdateDocs                             Estructura Lista

Predicados:
    paradigmaDocs(Name,Date,PDOCS).                                           aridad: 3
    constPdocs(Name,Date,Registrados,Logeados,Documentos,PDOCS).              aridad: 6
    getNombrePdocs([Nombre|_],Nombre).                                        aridad: 2
    getFechaCreacionPdocs([_,Fecha,_,_,_],Fecha).                             aridad: 2
    getRegistrados([_,_,Registrados|_],Registrados).                          aridad: 2
    getLogeados([_,_,_,Logeado|_],Logeado).                                   aridad: 2
    getDocumentos([_,_,_,_,ListaDocs],ListaDocs).                             aridad: 2
    modificarDocs([NombrePdocs,FechaCreacion,Registrados|_],UpdateDocs,Sn2)   aridad: 3

--------------------------------------------- Representacion ------------------------------------------
El TDA ParadigmaDocs, representa la plataforma donde estan alojados los documentos y usuarios

Clausulas:
  Hechos:*/

% paradigmaDocs: Predicado constructor de la estructura de paradigmaDocs
paradigmaDocs(Name,Date,[Name,Date,[],[],[]]):-
  string(Name).      % nota: no es necesario verificar que es una fecha, pues el predicado del TDA fecha lo verifica antes de pasarlo

% constPdocs: Predicado constructor de todos los elementos de la representacion propia de paradigmaDocs
constPdocs(Name,Date,Registrados,Logeados,Documentos,[Name,Date,Registrados,Logeados,Documentos]).

% getNombrePdocs: Predicado que obtiene el nombre de paradigmaDocs
getNombrePdocs([NombreP,_,_,_,_],NombreP).
% getFechaCreacionPdocs: Predicado que obtiene el nombre de paradigmaDocs
getFechaCreacionPdocs([_,Fecha,_,_,_],Fecha).
% getRegistrados: Predicado que obtiene la lista de registrados de paradigmaDocs
getRegistrados([_,_,Registrados,_,_],Registrados).
% getLogeados: Predicado que obtiene la lista de logeados e paradigmaDocs
getLogeados([_,_,_,Logeado,_],Logeado).
% getDocumentos: Predicado que la lista de documentos de paradigmaDocs
getDocumentos([_,_,_,_,Documentos],Documentos).

% modificarDocs: Predicado que mofica la estrucutra de documentos de paradigmaDocs y retorna una version actualizada de esta
modificarDocs([Nombre,Fecha,Registrados|_],UpdateDocs,[Nombre,Fecha,Registrados,[],UpdateDocs]).

/*-------------------------------------------TDA USER--------------------------------------------------
Dominios:
    Username,Pass,Logeado:                              String
    Date:                                               Date
    Pdocs:                                              ParadigmaDocs
    Registrados, Logeados, Documentos, UpdateDocs       Estructura Lista

Predicados:
    getUser([Username,_,_],Username).                     aridad: 2
    getPass([_,Pass,_],Pass).                             aridad: 2
    getFechaCreacionUser([_,_,Date],Date).                aridad: 2
    getUserNames([[Username,Pass,Date]...],[Username...]).aridad: 2
    getPasswords([[Username,Pass,Date]...],[Pass..]).     aridad: 2
    getLogeado(Pdocs,Logeado).                            aridad: 2
    registradoAntes(Pdocs,Username)                       aridad: 2
    miembroPdocs(Pdocs,Usuario,Pass)                      aridad: 3
    sesionActiva(Pdocs)                                   aridad: 1

--------------------------------------------- Representacion ------------------------------------------
El TDA User, representa al elemento "usuario" dentro de paradigmaDocs, su estructura es de la forma User XX Pass X Date (String X String X Date)
Clausulas:
  Hechos:*/

% constUser: Predicado constructor de la estructura del TDA Usuario
constUser(Username,Password,Fecha,[Username,Password,Fecha]):-
  string(Username),string(Password).

% getUser: Predicado que obtine el username del usuario registrado
getUser([Usuario,_,_],Usuario).
% getUser: Predicado que obtine la contraseña del usuario registrado
getPass([_,Pass,_],Pass).
% getUser: Predicado que obtine la fecha de creacion de cuenta del usuario registrado
getFechaCreacionUser([_,_,Date],Date).

% Reglas:

% getUserNames: Predicado que obtiene una lista con todos los usernames de los usuarios
getUserNames([],[]).
getUserNames([User|TUser],[Username|TUsername]):-
  getUser(User,Username),
  getUserNames(TUser,TUsername).

% getPasswords: Predicado que una lista con todas las contraseñas de los usuarios registrados
getPasswords([],[]).
getPasswords([User|TUsername],[Pass|TPass]):-
  getPass(User,Pass),
  getPasswords(TUsername,TPass).

% getLogeado: Predicado que extrae al usuario con sesión activa en paradigmadocs
getLogeado(Pdocs,Logeado):-
  getLogeados(Pdocs,[Logeado|_]).

% setUsuario: Predicado que añade un usuario a los usuarios registrados de paradigmadocs
setUsuario(Registrados,Usuario,Res):-
  append(Registrados,[Usuario],Res).

% registrado Antes: Predicado que determina si un usuario se ha registrado antes
registradoAntes(ParadigmaDocs,User):-
  string(User),
  getRegistrados(ParadigmaDocs,ListaRegistrados),
  getUserNames(ListaRegistrados,Usernames),
  myMember(User,Usernames).

% miembroPdocs: Predicado que verifica si un usuario tiene la contraseña y el username para ser miembro de paradigmadocs
miembroPdocs(Pdocs,Username,Pass):-
  getRegistrados(Pdocs,Registrados),
  getUserNames(Registrados,Usernames),
  getPasswords(Registrados,Passwords),
  indexOf(Usernames,Username,Index),
  myNth0(Index,Passwords,Pass).

% sesionActiva: Predicado que verifica cuando un usuario tiene sesion activa en paradigmaDocs, retornando true/false
sesionActiva(Pdocs):-
  getLogeados(Pdocs,Logeados),
  \+Logeados==[].

/*-------------------------------------------TDA DOCUMENTO--------------------------------------------------
Dominios:
    Id:                                                 Integer
    Autor,Titulo,Username:                              String
    Historial, Shares, IDLIST                           Estructura Lista
    DOCS:                                               Estructura Lista
    Date:                                               Date
    Pdocs:                                              ParadigmaDocs

Predicados:
    constDoc(Id,Autor,Titulo,Shares,Historial,DOC)      aridad: 6
    getIdDoc(DOC,Id)                                    aridad: 2
    getAutorDoc(DOC,Autor)                              aridad: 2
    getTituloDoc(DOC,Titulo)                            aridad: 2
    getAccessesDoc(DOC,Shares)                          aridad: 2
    getHistorialDoc(DOC,Historial)                      aridad: 2
    setId(Pdocs,Id)                                     aridad: 2
    getDocumentById(Pdocs,Id,Docu)                      aridad: 3
    getRestantes(DOCS,IDLIST,DOCS)                      aridad: 3
    getSharedDocuments(Username,DOCS,DOCS)              aridad: 3
    getMyDocs(Username,DOCS,DOCS)                       aridad: 3
    getDocsCreados(Username,DOCS,DOCS)                  aridad: 3
    getDocsAcceso(Username,DOCS,DOCS)                   aridad: 3
    getIdDocCreados(Username,DOCS,DOCS)                 aridad: 3
    revokeAccesses(DOCS,DOCS)                           aridad: 2
    revokeAllAccesses(PDocs,DOCS,DOCS)                  aridad: 3
    getIdsRestantes(DOCS,IDLIST,DOCS)                   aridad: 3

--------------------------------------------- Representacion ------------------------------------------
El TDA Documento representa la estructura completa de los documentos: Id X Autor X Titulo X Shares X Historial de forma (Integer X String X String X List X List)
Clausulas:
  Hechos:*/

% constDoc: Predicado constructor de Documento
constDoc(Id,Autor,Titulo,Shares,Historial,[[Id,Autor,Titulo,Shares,Historial]]).

% getIdDoc: Predicado que obtiene el id del documento
getIdDoc([Id|_],Id).
% getAutorDoc: Predicado que obtiene el autor del documento
getAutorDoc([_,Autor|_],Autor).
% getIdDoc: Predicado que obtiene el titulo del documento
getTituloDoc([_,_,Titulo|_],Titulo).
% getAccessesDoc:  Predicado que obtiene la lista de accesos del documento
getAccessesDoc([_,_,_,Shares|_],Shares).
% getHistorialDoc: Predicado que obtiene el historial del documento
getHistorialDoc([_,_,_,_,Historial],Historial).

% Reglas:

% setId: Predicado que coloca id correspondiente a un nuevo documento
setId(Pdocs,Id):-
  getDocumentos(Pdocs,Docs),
  length(Docs,Id).

% setDocumento: Predicado que añade un documento a paradigmadocs
setDocumento(Restantes,Documento,Docs):-
  append(Restantes,Documento,Docs).

% getDocumentById: Predicado que obtiene un documento mediante su id 
getDocumentById(Pdocs,Id,Docu):-
  getDocumentos(Pdocs,Docs),
  getSubIndexElement(Docs,Id,Index),
  myNth0(Index,Docs,Docu).

% getUserNamesAccess: Predicado que obtiene todos los usernames de los que tienen algun acceso al documento
getUserNamesAccess([],[]).
getUserNamesAccess([H|T],[H1|T1]):-
  getUserPermiso(H,H1),
  getUserNamesAccess(T,T1).

% getDocsCreados: Predicado que obtiene todos los documentos creados por un usuario
getDocsCreados(_,[],[]):-!.
getDocsCreados(AutorName,[Doc|TailDoc],[Doc|TailSalida]):-
  myMember(AutorName,Doc),
  getDocsCreados(AutorName,TailDoc,TailSalida),!.
getDocsCreados(AutorName,[_|TailDoc],A):-getDocsCreados(AutorName,TailDoc,A),!.

% getDocsCreados: Predicado que obtiene todos los documentos a los que el usuario tiene acceso
getDocsAcceso(_,[],[]):-!.
getDocsAcceso(Username,[Doc|TailDoc],[Doc|TailSalida]):-
  getAccessesDoc(Doc,[_|Accesses]),
  getUserNamesAccess(Accesses,DocUsrAccess),
  myMember(Username,DocUsrAccess),
  getDocsAcceso(Username,TailDoc,TailSalida),!.
getDocsAcceso(Username,[_|TailDoc],A):-getDocsAcceso(Username,TailDoc,A),!.

% getIdDocCreados: Predicado que obtiene los id's de los documentos creados por el usuario
getIdDocCreados([],[]).
getIdDocCreados([Doc|TailDoc],[H1|T1]):-
  getIdDoc(Doc,H1),
  getIdDocCreados(TailDoc,T1).

% getRestantes: Predicado que obtiene los restantes que no es igual al id
getRestantes(Id,[[Id|_]|E],E):-!.
getRestantes(_,[],[]):-!.
getRestantes(Id,[H|T],[H|T1]):-
  getRestantes(Id,T,T1).

% getIdsRestantes: Predicado que obtiene los documentos restantes de dada una lista de id's
getIdsRestantes(Restantes,[],Restantes):-!.
getIdsRestantes(Documentos,[H|T],X):-
  getRestantes(H,Documentos,Actualizada),
  getIdsRestantes(Actualizada,T,X).

% revokeAccess: Contructor del predicado RevokeAllAccesses que construye un nuevo documento con todos los permisos revocados
revokeAccesses(Doc,UpdateDoc):-
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getTituloDoc(Doc,Titulo),
  getHistorialDoc(Doc,Historial),
  UpdateDoc = [Id,Autor,Titulo,[[Autor,["W","C","R","S"]]],Historial].

% revokeAllAccesses: Predicado que obtiene una lista de Id's de los documentos que se quieren revocar acceso y a cada uno de ellos les revoca el acceso, si es propietario(Autor) es el logeado
revokeAllAccesses(_,[],[]):-!.
revokeAllAccesses(Pdocs,[Id|T],[H1|T1]):-
  getDocumentById(Pdocs,Id,Doc),
  getAutorDoc(Doc,Autor),
  getLogeado(Pdocs,Autor),
  revokeAccesses(Doc,H1),
  revokeAllAccesses(Pdocs,T,T1).

/*-------------------------------------------TDA VERSION---------------------------------------------------
Dominios:
    IdVr,IdDoc:                                               Integer
    Autor,Titulo,Username,Contenido,Texto1,SearchText:        String
    Historial, Shares, IDLIST                                 Estructura Lista
    Date:                                                     Date
    Doc:                                                      Documento
    Pdocs:                                                    ParadigmaDocs

Predicados:
    constVersion(Idvr,Fecha,Contenido,VERSION)                aridad: 4
    getIdVersion(VERSION,IdVr)                                aridad: 2
    getDateVersion(VERSION,Date)                              aridad: 2
    getContenidoVersion(VERSION,Contenido)                    aridad: 2
    getVersionById(Historial,IdVr,VERSION)                    aridad: 3
    getActiveVersion(Historial,VERSION)                       aridad: 2
    getTextoVersiones(VERSION,[Contenido...])                 aridad: 2
    notContainsText(Texto1,[Contenido...])                    aridad: 2
    getDocCoincidencias(SearchText,[Docs,...],[Docs,...])     aridad: 3

-------------------------------------------------- Representacion ------------------------------------------
El TDA Version Representa una lista de cada version que un documento tiene, creada a partir de hacer un cambio en el contenido (texto) de este, generalmente atribuido a los predicados
Add y Delete, cada vez que hace un cambio se debe atribuir a la version activa, por lo tanto la nueva version activa es la modificada, el predicado Restore Version tambien utiliza la lista
de versiones para "Restaurar" o convertir en activa una version, la cual no era activa.
Esta representado de esta forma
[ Version Activa XX Version NO Activa1 XX Version NO Activa 2 . . . ]
Cada version esta representada de la forma:
[idVersion(integer) XX date(Date) XX contenido(String)]

Hechos*/
% constVersion: Predicado constructor de una version la cual lleva la estructura [IdVr XX Date XX Contenido XX VERSION]
constVersion(Idvr,Fecha,Contenido,NuevaVersion):-
  NewId is Idvr+1,
  NuevaVersion = [NewId,Fecha,Contenido].

%getIdVersion: Predicado que obtiene el id de la version
getIdVersion([Version,_,_],Version).
%getDateVersion: Predicado que obtiene la fecha de moficacion de la version
getDateVersion([_,Date,_],Date).
%getContenidoVersion: Predicado que obtiene el contenido de la version
getContenidoVersion([_,_,Contenido],Contenido).

% Reglas:

%getVersionById: Predicado que obtiene una version mediante su idVersion
getVersionById(Historial,Id,Ver):-
  getSubIndexElement(Historial,Id,Index),
  myNth0(Index,Historial,Ver).

% getActiveVersion: Recibe el historial de versiones y obtiene la version activa
getActiveVersion([Active|_],Active).

% getTextoVersiones: Predicado que obtiene el texto de todas las versiones del historial
getTextoVersiones([],[]).
getTextoVersiones([Version|TailVersion],[Texto|TextT]):-
  getContenidoVersion(Version,Texto),
  getTextoVersiones(TailVersion,TextT).

% notContainsText: Predicado que determina si en una version activa de un documento
notContainsText(_,[]):-!.
notContainsText(SearchText,[Texto1|TailTexto]):-
  \+searchSubstring(Texto1,SearchText),
  notContainsText(SearchText,TailTexto).

% getDocCoincidencias: Predicado que extrae los documentos que tienen coincidencias con el texto buscado
getDocCoincidencias(_,[],[]):-!.
getDocCoincidencias(SearchText,[Doc1|TailDoc],[Doc1|T2]):-
  getHistorialDoc(Doc1,Historial),
  getTextoVersiones(Historial,TextoHistorial),
  \+notContainsText(SearchText,TextoHistorial),
  getDocCoincidencias(SearchText,TailDoc,T2),!.
getDocCoincidencias(SearchText,[_|T],Coincidencias):-getDocCoincidencias(SearchText,T,Coincidencias).

/*  -------------------------------------------TDA ACCESS---------------------------------------------------
Dominios:
    Permiso,Username,AccessString:                                    String
    Permisos,ListaUsuariosPermitidos,Accesses                         Estructura Lista
    Date:                                                             Date
    PDocs:                                                            ParadigmaDocs
Predicados:
    createAccesses(PDocs,Permisos,ListaUsuariosPermitidos,Accesses)   aridad: 4
    isAccess(Permiso)                                                 aridad: 1
    isAccessList(Permisos)                                            aridad: 1
    isEditor(Username,Accesses)                                       aridad: 2
    getUserPermiso(Permiso)                                           aridad: 1
    getTipoPermiso(Permiso)                                           aridad: 1
    isShareAdmin(Username,Accesses)                                   aridad: 2
    getPermisos(Username,Accesses)                                    aridad: 2
    filtraAccess(Username,Accesses,Permiso)                           aridad: 3
    filtraAccesses(ListaUsuariosPermitidos,Accesses,Accesses)         aridad: 3
    permisoString(Permiso,AccessString)                               aridad: 2

--------------------------------------------- Representacion ------------------------------------------
El TDA Version Representa una lista de permisos que cada documento posee, cada elemento (permiso, access) de esta lista esta representado de la forma: (Username [Permisos]),
los usuarios deben estar previamente registrados para poder ser añadidos a esta lista, y los permisos otorgados solo pueden ser "W";"R";"S";"C" (write, read, share, comment)

Hechos*/
% createAcccess: Predicado constructor de accesos, el cual recibe 2 listas ["W","R"] y ["U1""U2"], y construye permisos de la forma [["U1",["W","R"]],["U2",["W","R"]]]
createAccesses(_,_,[],[]):-!.   % Base Case 1
createAccesses(Sn1,Permisos,[User|TailUser],[[User,Permisos]|TF]):-
  isAccessList(Permisos),
  registradoAntes(Sn1,User),
  createAccesses(Sn1,Permisos,TailUser,TF).

% getUserPermiso: Predicado que obtiene el nombre del usuario que tiene el acceso
getUserPermiso([Nombre,_],Nombre).
% getTipoPermiso: Predicado que obtiene el permiso de un acceso
getTipoPermiso([_,Permiso],Permiso).

% Reglas:

% setAccess: Predicado que añade un acceso a la los accesos existentes
setAccess(Accesses,Access,Res):-
  append(Accesses,Access,Res).

% isAccess: Predicado que determina si un permiso es del tipo "W", "R", "C" o "S", si se cumple es un acceso permitido
isAccess(Access):-
  myMember(Access,["W","R","C","S"]).

% isAccessList: Predicado que determina si una lista de accesos tiene todos los accesos permitidos 
isAccessList([]):-!.
isAccessList([H|T]):-
  isAccess(H),
  isAccessList(T).

% isEditor: Predicado que determina si un usuario es editor de un documento
isEditor(Usuario,Accesses):-
  getPermisos(Usuario,Accesses,PermisosUsuario),
  myMember("W",PermisosUsuario).

% isShareAdmin: Predicado que determina si un usuario tiene el permiso de compartir en un documento
isShareAdmin(Usuario,Accesses):-
  getPermisos(Usuario,Accesses,PermisosUsuario),
  myMember("S",PermisosUsuario).

% getPermisos: Predicado que obtiene los permisos ["W"] de un usuario
getPermisos(UserName,[[UserName,Permisos]|_],Permisos):-!.
getPermisos(_,[],[]):-!.
getPermisos(UserName,[_|T],T1):-
getPermisos(UserName,T,T1).

% filtraAccess: Predicado que elimina la primera coincidencia de un acceso del tipo ["user1",["W"]]
filtraAccess(Usuario,[[Usuario|_]|Tail],Tail):-!.     % Doble operador de corte, elimina la primera coincidencia
filtraAccess(_,[],[]):-!.                  % Doble operador de corte
filtraAccess(Usuario,[H|T],[H|T1]):-
  filtraAccess(Usuario,T,T1).

% filtraAccesses: Predicado que elimina todas las coincidencias de un acceso del tipo ["user1",["W"]]
filtraAccesses([],Restantes,Restantes):-!.
filtraAccesses([User|TailUser],Accesses,X):-
  filtraAccess(User,Accesses,Filtrada),
  filtraAccesses(TailUser,Filtrada,X).

%permisoString: Predicado que convierte los permisos "W", "R", "C", "S" a un string entendible por el usuario
permisoString("W","Escritura").
permisoString("R","Lectura").
permisoString("C","Comentarios").
permisoString("S","Compartir").

/*  -------------------------------------------OTROS PREDICADOS / HECHOS---------------------------------------------------
Dominios:
    E:                                                                       Cualquier tipo de dato
    T, Lista,Registrados,Docs,Permisos,Accesses,Historial:                   Estructura Lista
    Index, Charac:                                                           Integer
    StringOriginal,StringBuscado,StringDelet,SearchStr,ReplaceStr,ResultStr: String
    Date:                                                                    Date
Predicados:
    addHead(E,Lista,[E|Lista])                                               aridad: 3
    indexOf([E|_], E, 0)                                                     aridad: 3
    myMember(E,[E|_])                                                        aridad: 2
    myNth0(0,[H|_],H)                                                        aridad: 3
    getSubIndexElement([[E|_]|_], E, 0)                                      aridad: 3
    deleteLast(StringOriginal,Charac,StringDelet)                            aridad: 3
    searchSubstring(StringOriginal,StringBuscado)                            aridad: 2
    strinReplaceAll(StringOriginal,SearchStr,ReplaceStr,ResultStr)           aridad: 4
    dateString(Date,DateString)                                              aridad: 2
    registradosToString(Registrados,[ResultStr])                             aridad: 2
    docsToString(Docs,[H1|T1])                                               aridad: 2
    permisoToString(Permisos,[ResultStr])                                    aridad: 2
    accessToString(Accesses,[ResultStr])                                     aridad: 2
    historialToString(Historial,[ResultStr])                                 aridad: 2
    

*/
% AddHead: Añade elemento a la cabeza de la lista
addHead(E,Lista,[E|Lista]).

% IndexOf: Predicado que obtiene el índice de un elemento
indexOf([E|_], E, 0):-!.
indexOf([_|Tail], E, Index):-
  indexOf(Tail, E, Index1),
  Index is Index1+1.

% myMember: Verifica si un elemento esta en una lista (Detiene el backtracking al encontrar la primera coincidiencia)
myMember(E,[E|_]):-!.
myMember(E,[_|T]):-
  myMember(E,T).

% myNth0: Obtiene un elemento dado una posición, parte en 0
myNth0(0,[H|_],H):-!.
myNth0(Index,[_|T],E):-
  Index1 is Index - 1,
  myNth0(Index1,T,E).

% getSubIndexElement: Predicado que obtiene el indice de un elemento buscado
getSubIndexElement([[E|_]|_], E, 0):-!.
getSubIndexElement([_|T], E, Index):-
  getSubIndexElement(T, E, Index1),
  Index is Index1+1.

% ******************* STRING OPERATORS ******************
% deleteLast: Predicado que elimina los utlimos caracteres de un string, se obtiene "" en caso el largo del string sea menor a lo que se quiere recortar
deleteLast(StringOriginal,Charac,StringDelet):-
  sub_string(StringOriginal,0,_,Charac,StringDelet),!.
deleteLast(StringOriginal,Charac,""):-
  string_length(StringOriginal,Len),
  Len < Charac,!.

% searchSubstring: Predicado que determina si un String(StringBuscado) es subString de otro String(String Original)
searchSubstring(StringOriginal,StringBuscado):-
  sub_string(StringOriginal,_,_,_,StringBuscado),!.

% strinReplaceAll: Predicado recursivvo que reemplaza todas las coincidencias de un texto
strinReplaceAll(StringOriginal,SearchStr,ReplaceStr,ResultStr):-
  searchSubstring(StringOriginal,SearchStr),
  re_replace(SearchStr,ReplaceStr,StringOriginal,Replaced),
  strinReplaceAll(Replaced,SearchStr,ReplaceStr,ResultStr),!.
strinReplaceAll(Replaced,_,_,Replaced).

% ****************** TO STRING ************************
%dateString: Predicado que convierte una fecha en un String
dateString([Day,Month,Year],DateString):-
  mesString(Month,MonthString),atomics_to_string([Day,"de",MonthString,Year]," ",DateString).
  
%registradosToString: Predicado que convierte a los registrados en un String
registradosToString([],[]).
registradosToString([[User,Pass,DateC]|TailUser],[H1|T1]):-
  dateString(DateC,DateString), % GetDateCreation
  atomics_to_string(["\nUsuario: ",User,"\n","Password: ",Pass,"\n","Registrado el ",DateString,"\n"],H1),
  registradosToString(TailUser,T1).

%docsToString: Predicado que convierte una documento a String
docsToString([],[]).
docsToString([Doc|TailDoc],[H1|T1]):-
  getAutorDoc(Doc,Autor),
  getIdDoc(Doc,Id),
  getHistorialDoc(Doc,Historial),
  getTituloDoc(Doc,Titulo),
  getAccessesDoc(Doc,[_|Accesses]),
  accessToString(Accesses,StringPermiso),atomics_to_string(StringPermiso,StringAccesses),
  historialToString(Historial,StringVer),atomics_to_string(StringVer,StringVers),
  atomics_to_string(["\n> > > > > ",Titulo," id ",Id," < < < < <\n","* Creado por ",Autor,"\n\t-> Usuarios Con Accesso",StringAccesses,
  "\n\t-> Historial\n\t\t------> Version Activa <------\n",StringVers],H1),
  docsToString(TailDoc,T1).

%permisoToString: Predicado que convierte un permiso a String
permisoToString([],[]).
permisoToString([Permiso|TailPermiso],[H1|T1]):-
  permisoString(Permiso,H1),
  permisoToString(TailPermiso,T1).

%accessToString: Predicado que convierte los accesos a String
accessToString([],[]).
accessToString([Access|TailAccess],[H1|T1]):-
  getUserPermiso(Access,Nombre),
  getTipoPermiso(Access,Tipo),
  permisoToString(Tipo,StringPermisoList),atomics_to_string(StringPermisoList,", ",StringPermiso),
  atomics_to_string(["\n\t   * ",Nombre," Permiso de ",StringPermiso],H1),
  accessToString(TailAccess,T1).

%historialToString: Predicado que convierte el historial a String
historialToString([],[]).
historialToString([Version|RestoVer],[H1|T1]):-
  getIdVersion(Version,Idver),
  getDateVersion(Version,Date),
  dateString(Date,DateString),
  getContenidoVersion(Version,ContenidoVer),
  atomics_to_string(["\t\t* * * * * Version ", Idver," * * * * * \n\t\tCreada el ",DateString,"\n\t\t",ContenidoVer,"\n"],H1),
  historialToString(RestoVer,T1).

/*------------------------------------------------------------------MAIN----------------------------------------------------------------------
Seccion principal donde todos los TDA son usados para realizar operaciones sobre los documentos de paradigmaDocs, por lo tanto estos se convierten
en metas secundaris y las operaciones principales son primarias.

Dominios:
    Username,PassWord,Contenido,PDocsString,Nombre,ContenidoTexto,String,Text1,Text2:         String
    DocumentId,NumberOfCharacters:                                                            Integer
    Documents,ListaPermisos,ListaUsernamesPermitidos:                                         Estructura Lista
    Fecha:                                                                                    Date
    Sn1,Sn2:                                                                                  ParadigmaDocs

Predicados:
    paradigmaDocsRegister(Sn1,Fecha,Username,Password,Sn2)                                    aridad: 5
    paradigmaDocsLogin(Sn1,Username,Password,Sn2)                                             aridad: 4
    paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido,Sn2)                                    aridad: 5
    paradigmaDocsShare(Sn1,DocumentId,ListaPermisos,ListaUsernamesPermitidos,Sn2)             aridad: 5
    paradigmaDocsAdd(Sn1,DocumentId,Fecha,ContenidoTexto,Sn2)                                 aridad: 5
    paradigmaDocsRestoreVersion(Sn1,DocumentId,IdVersion,Sn2)                                 aridad: 4
    paradigmaDocsToString(Sn1,PDocsString)                                                    aridad: 2
    paradigmaDocsRevokeAllAccesses(Sn1,DocumentIds,Sn2)                                       aridad: 3
    paradigmaDocsDelete(Sn1,DocumentId,Fecha,NumberOfCharacters,Sn2)                          aridad: 5
    paradigmaDocsSearch(Sn1,String,Documents)                                                 aridad: 3
    paradigmaDocsSearchAndReplace(Sn1,DocumentId,Text1,Fecha,Text2,Sn2)                       aridad: 6

Metas:
  Metas Primarias: paradigmaDocsRegister, paradigmaDocsLogin, paradigmaDocsCreate, paradigmaDocsShare, paradigmaDocsAdd, paradigmaDocsRestoreVersion, 
  paradigmaDocsToString, paradigmaDocsRevokeAllAccesses, paradigmaDocsDelete, paradigmaDocsSearch, paradigmaDocsSearchAndReplace

  Metas Secundarias: registradoAntes, getNombrePdocs, getFechaCreacionPdocs, getLogeado, getDocumentos, getRegistrados,
  miembroPdocs, sesionActiva, setId, constVersion, constDoc, modificarDocs, getDocumentById, getAutorDoc, getTituloDoc,
  getAccessesDoc, getHistorialDoc, isShareAdmin, filtraAccesses, createAccesses, getRestantes, isEditor, getActiveVersion,
  getIdVersion, getContenidoVersion, constVersion, addHead, getVersionById, getDocsCreados, getDocsAcceso, docsToString,
  dateString, getIdsRestantes, revokeAccesses,getDocCoincidencias,searchSubstring,strinReplaceAll

Clausulas:
Reglas:*/

% ParadigmaDocsRegister: Predicado que permite a un usuario registrarse en paradigmaDocs
% Dominio: Sn1, Fecha, Username, Password, Sn2
paradigmaDocsRegister(Sn1,Fecha,Username,Password,Sn2):-
  \+registradoAntes(Sn1,Username),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  getRegistrados(Sn1,Registrados),
  constUser(Username,Password,Fecha,Usuario),
  setUsuario(Registrados,Usuario,UpdateRegistrados),
  Sn2 = [Nombre,FechaCreacion,UpdateRegistrados,Logeados,Docs],!.

% ParadigmaDocsLogin: Predicado que inicia sesion a un usuario registrado y le permite hacer cualquier operacion permitida
% Dominio: Sn1, Fecha, Username, Password, Sn2
paradigmaDocsLogin(Sn1,Username,Password,Sn2):-
  \+sesionActiva(Sn1),
  string(Username),
  string(Password),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  miembroPdocs(Sn1,Username,Password),
  setUsuario(Logeados,Username,UpdateLogeados),
  Sn2 = [Nombre,FechaCreacion,Registrados,UpdateLogeados,Docs].
% ParadigmaDocsCreate: Predicado que permite al usuario con sesion activa crear un nuevo documento
% Dominio: Sn1, Fecha, Nombre, Contenido, Sn2
paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido,Sn2):-
  string(Nombre),string(Contenido),
  sesionActiva(Sn1),    % Si existe sesion activa se saca al usuario
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Autor),
  setId(Sn1,Id),
  constVersion(-1,Fecha,Contenido,Version),
  constDoc(Id,Autor,Nombre,[[Autor,["W","C","R","S"]]],[Version],Doc), % al autor del documento automaticamente se le añade un permiso con todos los accesos
  setDocumento(Docs,Doc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).
% ParadigmaDocsShare: Predicado que permite al usuario con sesion activa, compartir un documento con otros usuarios registrados en paradigmaDocs
% Dominio: Sn1, DocumentId, ListaPermisos, ListaUsernamesPermitidos, Sn2
paradigmaDocsShare(Sn1,DocumentId,ListaPermisos,ListaUsernamesPermitidos,Sn2):-
  sesionActiva(Sn1),
  ListaPermisos \== [],
  ListaUsernamesPermitidos \== [],
  getDocumentos(Sn1,Docs),
  getDocumentById(Sn1,DocumentId,[_,Autor,TituloDoc,OldAcceses,Historial]),
  filtraAccesses(ListaUsernamesPermitidos,OldAcceses,FilteredAccesses),
  createAccesses(Sn1,ListaPermisos,ListaUsernamesPermitidos,Accesses),
  setAccess(FilteredAccesses,Accesses,NewAccesses),
  constDoc(DocumentId,Autor,TituloDoc,NewAccesses,Historial,NuevoDoc),
  getRestantes(DocumentId,Docs,Restantes),
  setDocumento(Restantes,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).
% ParadigmaDocsAdd: Predicado que permite al usuario con sesion activa añadir texto en la sesion activa de un documento, pasando esta actualizacion como sesion activa
% Dominio: Sn1, DocumentId, Fecha, ContenidoTexto, Sn2
paradigmaDocsAdd(Sn1,DocumentId,Fecha,ContenidoTexto,Sn2):-
  sesionActiva(Sn1),
  string(ContenidoTexto),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Logeado),
  getDocumentById(Sn1,DocumentId,[Id,Autor,TituloDoc,Accesses,Historial]),
  isEditor(Logeado,Accesses),
  getActiveVersion(Historial,[IdVersion,_,ContenidoVersion]),
  string_concat(ContenidoVersion, ContenidoTexto, NuevoContenido),
  constVersion(IdVersion,Fecha, NuevoContenido, NuevaVersion),
  addHead(NuevaVersion,Historial,NuevoHistorial),
  constDoc(Id,Autor,TituloDoc,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  setDocumento(RestantesDoc,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).

% ParadigmaDocRestoreVersion: Predicado que permite al usuario con sesion activa, colocar como version activa una version anterior, registrada en el historial
% Dominio: Sn1, DocumentId, IdVersion, Sn2
paradigmaDocsRestoreVersion(Sn1,DocumentId,IdVersion,Sn2):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocumentById(Sn1,DocumentId,[Id,Logeado,Titulo,Accesses,Historial]),
  getVersionById(Historial,IdVersion,Restaurada),
  getRestantes(IdVersion,Historial,VerRestantes),
  addHead(Restaurada,VerRestantes,NuevoHistorial),
  constDoc(Id,Logeado,Titulo,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  setDocumento(RestantesDoc,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).

% ParadigmaDocsToString: Predicado que muestra informacion de paradigmaDocs en formato string, para que sea entendible por el usuario
% Dominio: Sn1, PDocsString
% Version 1: Cuando se muestra información todos los documentos que tiene acceso un usuario logeado
paradigmaDocsToString(Sn1,PDocsString):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocsCreados(Logeado,Docs,DocsCreados),
  getDocsAcceso(Logeado,Docs,DocsAcceso),
  docsToString(DocsCreados,DocStringCreados),atomics_to_string(DocStringCreados,DocStrings1),
  docsToString(DocsAcceso,DocStringAcceso),atomics_to_string(DocStringAcceso,DocStrings2),
  atomics_to_string(["\n* * * * * * * * *  ",Logeado,"  * * * * * * * * *  \n\n*********** Es Propietario de ***********",
  DocStrings1,"\n************ Tiene acceso a *************\n",DocStrings2],PDocsString),!.
% Version 2: Se muestra toda la información de la plataforma
paradigmaDocsToString(Sn1,PDocsString):-
  \+sesionActiva(Sn1),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  dateString(FechaCreacion,DateString),
  registradosToString(Registrados,RegiStringList),atomics_to_string(RegiStringList,RegiString),
  docsToString(Docs,DocString),atomics_to_string(DocString,DocStrings),
  atomics_to_string(["\n* * * * * * * ",Nombre," * * * * * * *","\n","Creado el ",DateString,"\n\n",
  "******** Usuarios Registrados ******** ",RegiString,"\n","************* Documentos ************ ",DocStrings],PDocsString),!.

% ParadigmaDocsRevokeAllAccesses: Predicado que permite al usuario con sesion activa, eliminar todos los permisos de una lista de Ids a los que el usuario es autor, si se ingresa [], se elimina todos los accesos a los documentos creados
% Dominio: Sn1, DocumentIds, Sn2
% Version 1: (paradigmaDocsRevokeAllAccesses) cuando la lista de IdsDocumentos no es [], se revocan los documentos seleccionados
paradigmaDocsRevokeAllAccesses(Sn1,DocumentIds,Sn2):-
  sesionActiva(Sn1),
  DocumentIds \== [],
  getDocumentos(Sn1,Docs),
  revokeAllAccesses(Sn1,DocumentIds,RevokedDocuments),
  getIdsRestantes(Docs,DocumentIds,RestantesDoc),
  setDocumento(RestantesDoc,RevokedDocuments,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2),!.
% Version 2: (paradigmaDocsRevokeAllAccesses) cuando la lista de IdsDocumentos es [], se revocan todos los documentos donde el usuario es autor
paradigmaDocsRevokeAllAccesses(Sn1,[],Sn2):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocsCreados(Logeado,Docs,DocsCreados),
  getIdDocCreados(DocsCreados,DocumentIds),
  revokeAllAccesses(Sn1,DocumentIds,RevokedDocuments),
  getIdsRestantes(Docs,DocumentIds,RestantesDoc),
  setDocumento(RestantesDoc,RevokedDocuments,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).

% ParadigmaDocsDelete: Predicado que permite al usuario con sesion activa, eliminar los ultimos "n" caracteres del contenido de la version activa, si el "n" a eliminar es mayor a largo, se elimina todo la cadena quedando ""
% Dominio: Sn1, DocumentId, Fecha, NumberOfCharacters, Sn2
paradigmaDocsDelete(Sn1,DocumentId,Fecha,NumberOfCharacters,Sn2):-
  sesionActiva(Sn1),
  integer(NumberOfCharacters),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Logeado),
  getDocumentById(Sn1,DocumentId,[Id,Autor,TituloDoc,Accesses,Historial]),    % get the document
  isEditor(Logeado,Accesses),
  getActiveVersion(Historial,[IdVersion,_,ContenidoVersion]),  % get Active version
  deleteLast(ContenidoVersion,NumberOfCharacters,NuevoContenido),
  constVersion(IdVersion,Fecha, NuevoContenido, NuevaVersion),
  addHead(NuevaVersion,Historial,NuevoHistorial),
  constDoc(Id,Autor,TituloDoc,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  setDocumento(RestantesDoc,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).
% ParadigmaDocsSearch: Predicado que permite al usuario con sesion activa buscar texto en los documentos en los todos los documentos a los que el usaurio logeado  tiene acceso, retorna los documentos donde hay coincidencias, si no las hay retorna []
% Dominio: Sn1, String, Documents, Sn2
paradigmaDocsSearch(Sn1,String,Documents):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocsCreados(Logeado,Docs,DocsCreados),
  getDocsAcceso(Logeado,Docs,DocsAcceso),
  setDocumento(DocsCreados,DocsAcceso,AllDocs),
  getDocCoincidencias(String,AllDocs,Documents).
% ParadigmaDocsSearchAndReplace: Predicado que permite al usuario buscar texto en la version activa de un documento mediante su "id" y reemplaza las ocurrencias por otro texto ingrado
% Dominio: Sn1, DocumentIds, String, Fecha, String, Sn2
% Version 1: (paradigmaDocsSearchAndReplace) Cuando el texto buscado se encuetra, se duelve paradigmaDocs con el texto reemplazado
paradigmaDocsSearchAndReplace(Sn1,DocumentId,Text1,Text2,Fecha,Sn2):-
  sesionActiva(Sn1),
  string(Text1),
  string(Text2),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocumentById(Sn1,DocumentId,[Id,Autor,TituloDoc,Accesses,Historial]),    % get the document
  isEditor(Logeado,Accesses),
  getActiveVersion(Historial,[IdVersion,_,ContenidoVersion]),  % get Active version
  searchSubstring(ContenidoVersion,Text1),
  strinReplaceAll(ContenidoVersion,Text1,Text2,StringReplaced),
  constVersion(IdVersion,Fecha,StringReplaced,NuevaVersion),
  addHead(NuevaVersion,Historial,NuevoHistorial),
  constDoc(Id,Autor,TituloDoc,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  setDocumento(RestantesDoc,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2),!.
% Version 2: (paradigmaDocsSearchAndReplace) Cuando no se encuentra el texto buscado, se envia un mensaje mediante el predicado write y todo el documento de entrada
paradigmaDocsSearchAndReplace(Sn1,DocumentId,Text1,Text2,_,_):-
  sesionActiva(Sn1),
  string(Text1),
  string(Text2),
  getLogeado(Sn1,Logeado),
  getDocumentById(Sn1,DocumentId,Doc),
  getAccessesDoc(Doc,Accesses),
  getHistorialDoc(Doc,Historial),
  isEditor(Logeado,Accesses),
  getActiveVersion(Historial,[_,_,ContenidoVersion]),
  \+searchSubstring(ContenidoVersion,Text1),
  docsToString([Doc],StringDoc),
  atomics_to_string(StringDoc,StringsDoc),
  write("\n>>> No se encuentran coicidencias en el documento, se retorna el documento original <<<\n"),
  write(StringsDoc).

/*> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > EJEMPLOS < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >  Register < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. Se registran 3 usuarios unicos: saul, kim y chuck
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4).

************************************************************* Excepciones(false) ***********************************************************************************
2. Se intenta logear 2 usuarios con el mismo username, retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"chuck","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4).

3. Se intentan logear 3 usuarios con el mismo username, retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"chuck","1234",PD3),paradigmaDocsRegister(PD3,D3,"chuck","4321",PD4).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Login < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. Se logea un usuario existente con credenciales correctas:
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5).

************************************************************* Excepciones(false) **********************************************************************************
2. El usuario "saul" se intenta logear con contraseña incorrecta, el predicado, retorna false:
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"saul","qwerty",PD5).

3. Se intenta logear un usuario, no registrado en paradigmaDocs, retorna false:
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"mike","98415",PD5).

4. Se intenta logear un usuario cuando ya existe una sesión activa en paradigmaDocs(false):
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsLogin(PD5,"kim","4321",PD6).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Create < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. El usuario "chuck" autenticado, crea un nuevo documento en paradigmaDocs id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6).

2. El usuario "saul" autenticado, crea un nuevo documento en paradigmaDocs id:1
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8).

3. El usuario "kim" autenticado, crea un nuevo documento en paradigmaDocs id:2
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10).

4. El usuario "kim" autenticado, crea un nuevo documento en paradigmaDocs id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12).

*********************************************************** Excepciones(false) *************************************************************************************
1. No hay sesion activa, retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsCreate(PD4,D1,"DocChuck","Contenidochuck",PD5).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Share < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. El usuario kim se logea y posterior a esto, aplica "Share" al documento de ID=2 el cual es dueña, y otorga los permisos de ["S"] a los usuarios "chuck" y a "saul"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["S"],["chuck","saul"],PD12).

2. El usuario kim se logea y posterior a esto, aplica "Share" al documento de ID=2 el cual es dueña, y subrescribe los permisos de ["S"] otorgados anteriormente a "chuck" y a "saul" y otorga ["W","R","S"] en su lugar
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["S"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14).

3. El usuario Saul ahora posee permiso "S" de compartir otorgado por "kim" en doc id: 2, por lo tanto puede compartir y otorgar permisos sobre el documento id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["S"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"saul","1234",PD15),paradigmaDocsShare(PD15,2,["W"],["saul"],PD16).

********************************************************** Excepciones(false) *************************************************************************************
4. El usuario kim se logea y posterior a esto, aplica "Share" al documento de ID=0 el cual es dueño, pero otorga permisos no permitidos por paradigmaDocs, retornando (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["U","P"],["chuck","saul"],PD12).

5. El usuario chuck se logea y posterior a esto, aplica "Share" al documento de ID=0 el cual es dueño, pero otorga permisos a usuarios no registrados en paradigmaDocs (mike), retornando (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["W"],["mike","saul"],PD12).

6. El usuario saul se logea y posterior a esto, aplica "Share" al documento de ID=4 el cual no existe
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,4,["W"],["chuck","saul"],PD12).

7. No hay sesion activa, retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["S"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsShare(PD14,2,["W"],["saul"],PD15).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Add < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. El usuario chuck es editor del documento id:2, por lo tanto puede aniadir texto a este
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16).

2. El usuario kim es duenio del documento id:2, por lo tanto puede aniadir texto a este
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18).

3. El usuario saul es duenio del documento id:1, por lo tanto puede aniadir texto a este
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3," contenido Aniadido por Saul",PD20).

*********************************************************** Excepciones(false) *************************************************************************************
4. El usuario chuck es no es editor del documento id:1, retorna false
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,1,D3," Contenido Aniadido por Chuck",PD16).

5. No hay sesion activa, retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsAdd(PD18,1,D3," contenido Aniadido por Saul",PD19).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Restore Version < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. El usuario kim dueño del document id:2 con idVersion Activa 2, restaura la version id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"kim","4321",PD21),paradigmaDocsRestoreVersion(PD21,2,0,PD22).

2. El usuario saul dueño del document id:1 con idVersion Activa 1, restaura la version id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,0,PD22).

3. El usuario saul dueño del document id:1 con idVersion Activa 1, restaura la version id:1, el documento no sufre ningun cambio
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22).

**************************************************************** Excepciones(false) *************************************************************************************
4. No hay sesion activa retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsRestoreVersion(PD20,1,1,PD21).

5. El usuario Saul no es dueño del documento id:2
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,2,1,PD22).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > ParadigmaDocsToString < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. Version de paradigmaDocsToString sin usuario logeado
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsToString(PD22,Sout),write(Sout).

2. Version de paradigmaDocsToString con un usuario logeado "kim"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"saul","1234",PD23),paradigmaDocsShare(PD23,1,["W","R","S"],["chuck","kim"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsToString(PD25,Sout),write(Sout).

3. Version de paradigmaDocsToString con un usuario logeado "chuck"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"chuck","qwerty",PD23),paradigmaDocsToString(PD23,Sout),write(Sout).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Revoke All Accesses < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. El usuario kim revoca el acceso a todos sus documentos (id:3, id:2), ingresando [], se puede apreciar mas claramente en paradigmaDocsToString
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[],PD26).

2. El usuario kim revoca el acceso al documento id:2, ingresando [2], los otros documentos permanecen con accesos
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2],PD26).

3. El usuario kim revoca el acceso al documento id:2,3, ingresando [2,3], los otros documentos permanecen con accesos
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2,3],PD26).

-> Este ejemplo se puede comprobar, realizando revokeAllAccesses[2,3] y realizando revokeAllAccesses[], donde se puede apreciar que los paradigmaDocs son iguales (PD26=PD28)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2,3],PD26),paradigmaDocsLogin(PD26,"kim","4321",PD27),paradigmaDocsRevokeAllAccesses(PD27,[],PD28).

4. El usuario chuck revoca el acceso al documento id:0, ingresando [0], los otros documentos permanecen con accesos
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsRevokeAllAccesses(PD25,[0],PD26).

******************************************************************* Excepciones(false) *************************************************************************************
5. El usuario Saul no es dueño del documento id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsRevokeAllAccesses(PD25,[0],PD26).

6. Kim desea revocar los accesos [2,3,4] donde id:1 no es dueña Retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2,3,1],PD26).

7. No hay sesión activa retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsRevokeAllAccesses(PD24,[2],PD25).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Delete < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. Se borran los ultimos 10 caracteres de la version activa del documento id:1 el cual Saul tiene acceso, quedando: "ContenidoSaul/Contenido Aniadid"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsDelete(PD25,1,D3,10,PD26).

2. Se borran los ultimos 100 caracteres el largo de la palabra es menor a la cantidad a eliminar, quedando ""
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsDelete(PD25,1,D3,100,PD26).

3. Se borran los ultimos 13 caracteres del documento id:3 al que chuck tiene acceso, quedando "2"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsDelete(PD25,3,D3,13,PD26).

*************************************************************** Excepciones(false) *************************************************************************************
4. Usuario Chuck no tiene acceso al documento id:1
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsDelete(PD25,1,D3,13,PD26).  

5. No hay sesion activa, retorna (false):
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsDelete(PD24,2,D3,10,PD25). 

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Search < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. Se busca "Contenido" en los documentos a los que "kim" tiene acceso , se encuentra una coincidencia en doc id:2 y id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsSearch(PD25,"Contenido",Documents).

2. Se busca "Kim" en los documentos a los que Chuck tiene acceso (Tiene algun permiso), encontrando coincidencias en  los doc id:2 y id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsSearch(PD25,"Kim",Documents).

3. Saul busca la palabra "Saul" en los documentos que tiene acceso, tiendo una coiencidencia en doc id:1
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsSearch(PD25,"Saul",Documents).

4. Chuck busca la palabra "Hola" en los documentos a los que tiene acceso (W,R,C,S), no se encuentran coincidencias, retorna []
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsSearch(PD25,"Hola",Documents).

***************************************************************** Excepciones(false) *************************************************************************************
4. No hay sesion activa, retorna (false):
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsSearch(PD24,"Saul",Documents).

> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > Search And Replace < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

1. El usuario "kim" se logea y ejecuta search and Replace, luego busca la palabra "Contenido" en sus documentos y es reemplazada por "HOLA" (Todas las coincidencias)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsSearchAndReplace(PD23,2,"Contenido","HOLA",D3,PD24).

2. El usuario "chuck" tiene acceso de escritura al documento de id:2 por lo tanto puede reemplazar texto, en este caso la palabra "Aniadido", la cual es reemplazada por " Reemplazando texto :) "
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"chuck","qwerty",PD23),paradigmaDocsSearchAndReplace(PD23,2,"Aniadido"," Reemplazando texto :) ",D3,PD24).

3. El texto buscado no se encuentra, por lo tanto se imprime mediante el predicado write(">>>> No se encuentran coicidencias en el documento <<<<") y el documento donde no hay coincidencias
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"chuck","qwerty",PD23),paradigmaDocsSearchAndReplace(PD23,2,"Palabra Distinta"," Reemplazando texto :) ",D2,PD24).

******************************************************************** Excepciones(false) *************************************************************************************
4. El usuario no tiene acceso a tal documento
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"chuck","qwerty",PD23),paradigmaDocsSearchAndReplace(PD23,1,"Aniadido"," Reemplazando texto :) ",D2,PD24).

5. No hay sesion activa, retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsSearchAndReplace(PD22,1,"Aniadido"," Reemplazando texto :) ",D3,PD23).

6. El documento id:5 no existe
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"chuck","qwerty",PD23),paradigmaDocsSearchAndReplace(PD23,10,"Reemplazar"," Reemplazando texto :) ",D2,PD24).
*/