/*-------------------------------------------TDA DATE--------------------------------------------------
Dominios:
    Cantidad_dias, DD, MM, YYYY: Entero

Predicados:
  mes (MM, Cantidad_dias)     aridad: 2
  date(DD,MM,YYYY)            aridad: 3
  getDay([DD,MM,YYYY],DD)     aridad: 2
  getMonth([DD,MM,YYYY],MM)   aridad: 2
  getYear([DD,MM,YYYY],YYYY)  aridad: 2
--------------------------------------------- Representacion ------------------------------------------
El TDA Date se representa a traves de una lista de 3 enteros de la forma dia X mes X año (integer X integer X integer)
Clausulas
Hechos*/

mes(1,31). mes(2,28). mes(2,29). mes(3,31). mes(4,30). mes(5,31). mes(6,30). mes(7,31). mes(8,31). mes(9,30). mes(10,31). mes(11,30). mes(12,31).
mesString(1,"Enero"). mesString(2,"Febrero"). mesString(3,"Marzo"). mesString(4,"Abril"). mesString(5,"Mayo"). mesString(6,"Junio"). mesString(7,"Julio").
mesString(8,"Agosto"). mesString(9,"Septiembre"). mesString(10,"Octubre"). mesString(11,"Noviembre"). mesString(12,"Diciembre").

% Predicado que obtiene los dias de una fecha
getDay([D,_,_],D).
% Predicado que obtiene los meses de una fecha
getMonth([_,M,_],M).
% Predicado que obtiene los años de una fecha
getYear([_,_,Y],Y).

% Reglas:
% Predicado Constructor de fecha
date(Day, Month, Year, Date):-
  integer(Day), integer(Month), integer(Year),mes(Month,Dias),
  Day=<Dias,
  Date = [Day, Month, Year].
  

/*-------------------------------------------TDA PARADIGMADOCS--------------------------------------------------
Dominios:
    Nombre:                                           String
    Date:                                             Date
    Registrados, Logeados, Documentos, UpdateDocs     Estructura Lista

Predicados:
  paradigmaDocs(Name,Date,PDOCS).                                           aridad: 3
  constPdocs(Name,Date,Registrados,Logeados,Documentos,PDOCS).              aridad: 6
  getNombrePdocs([Nombre|_],Nombre).                                        aridad: 2
  getFechaCreacionPdocs([_,Fecha|_],Fecha).                                 aridad: 2
  getRegistrados([_,_,ListaReg|_],ListaReg).                                aridad: 2
  getLogeados([_,_,_,ListaLog|_],ListaLog).                                 aridad: 2
  getDocumentos([_,_,_,_,ListaDocs],ListaDocs).                             aridad: 2
  modificarDocs([NombrePdocs,FechaCreacion,Registrados|_],UpdateDocs,Sn2)   aridad: 3

--------------------------------------------- Representacion ------------------------------------------
El TDA ParadigmaDocs, representa la plataforma donde estan alojados los documentos y usuarios
Hechos*/
% paradigmaDocs: Predicado constructor de la estructura de paradigmaDocs
paradigmaDocs(Name,Date,[Name,Date,[],[],[]]):-
  string(Name).      % nota: no es necesario verificar que es una fecha, pues el predicado del TDA fecha lo verifica antes de pasarlo

% constPdocs: Predicado constructor de todos los elementos de la representacion propia de paradigmaDocs
constPdocs(Name,Date,Registrados,Logeados,Documentos,[Name,Date,Registrados,Logeados,Documentos]).

% getNombrePdocs: Predicado que obtiene el nombre de paradigmaDocs
getNombrePdocs([Nombre|_],Nombre).

% getFechaCreacionPdocs: Predicado que obtiene el nombre de paradigmaDocs
getFechaCreacionPdocs([_,Fecha|_],Fecha).

% getRegistrados: Predicado que obtiene la lista de registrados de paradigmaDocs
getRegistrados([_,_,Registrados|_],Registrados).

% getLogeados: Predicado que obtiene la lista de logeados e paradigmaDocs
getLogeados([_,_,_,Logeados|_],Logeados).

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
Hechos*/
% getUser: Predicado que obtine el username del usuario registrado
getUser([Usuario,_,_],Usuario).
% getUser: Predicado que obtine la contraseña del usuario registrado
getPass([_,Pass,_],Pass).
% getUser: Predicado que obtine la fecha de creacion de cuenta del usuario registrado
getFechaCreacionUser([_,_,Date],Date).

% Reglas:

% getUserNames: Predicado que obtiene una lista con todos los usernames de los usuarios
getUserNames([],[]).
getUserNames([H|T],[H1|T1]):-
  getUser(H,H1),
  getUserNames(T,T1).

% getPasswords: Predicado que una lista con todas las contraseñas de los usuarios registrados
getPasswords([],[]).
getPasswords([H|T],[H1|T1]):-
  getPass(H,H1),
  getPasswords(T,T1).

% getLogeado: Predicado que extrae al usuario con sesión activa en paradigmadocs
getLogeado(Pdocs,Logeado):-
  getLogeados(Pdocs,[Logeado|_]).

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
  myNth0(Index,Passwords,PassG),
  PassG == Pass.

% SesionActiva: Predicado que verifica cuando un usuario tiene sesion activa en paradigmaDocs
sesionActiva(Pdocs):-
  getLogeados(Pdocs,Logeados),
  \+Logeados==[].

/*-------------------------------------------TDA DOCUMENTO--------------------------------------------------
Dominios:
    Id:                                                 Integer
    Autor,Titulo,Username:                              String
    Historial, Shares, IDLIST                           Estructura Lista
    Date:                                               Date
    Pdocs:                                              ParadigmaDocs

Predicados:
  constDoc(Id,Autor,Titulo,Shares,Historial,DOC)        aridad: 6
  getIdDoc(DOC,Id)                                      aridad: 2
  getAutorDoc(DOC,Autor)                                aridad: 2
  getTituloDoc(DOC,Titulo)                              aridad: 2
  getAccessesDoc(DOC,Shares)                            aridad: 2
  getHistorialDoc(DOC,Historial)                        aridad: 2
  setId(Pdocs,Id)                                       aridad: 2
  getDocumentById(Pdocs,Id,Docu)                        aridad: 3
  getRestantes(DOCS,IDLIST,DOCS)                        aridad: 3
  getSharedDocuments(Username,DOCS,DOCS)                aridad: 3
  getMyDocs(Username,DOCS,DOCS)                         aridad: 3
  getDocsCreados(Username,DOCS,DOCS)                    aridad: 3
  getDocsAcceso(Username,DOCS,DOCS)                     aridad: 3
  getIdDocCreados(Username,DOCS,DOCS)                   aridad: 3
  revokeAccesses(DOCS,DOCS)                             aridad: 2
  revokeAllAccesses(PDocs,DOCS,DOCS)                    aridad: 3
  getIdsRestantes(DOCS,IDLIST,DOCS)                     aridad: 3

--------------------------------------------- Representacion ------------------------------------------
El TDA Documento representa la estructura completa de los documentos: Id X Autor X Titulo X Shares X Historial de forma (Integer X String X String X List X List)
Hechos*/
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

% setId: Predicado que coloca id correspondiente a un nuevo documento
setId(Pdocs,Id):-
  getDocumentos(Pdocs,Docs),
  length(Docs,Idd),
  Id is Idd.

% Reglas:

% getDocumentById: Predicado que obtiene un documento mediante su id 
getDocumentById(Pdocs,Id,Docu):-
  getDocumentos(Pdocs,Docs),
  getIndexElement(Docs,Id,Index),
  myNth0(Index,Docs,Docu).

getUserNamesAccess([],[]).
getUserNamesAccess([H|T],[H1|T1]):-
  getUserPermiso(H,H1),
  getUserNamesAccess(T,T1).

getDocsCreados(_,[],[]):-!.
getDocsCreados(AutorName,[Doc|TailDoc],[Doc|TailSalida]):-
  myMember(AutorName,Doc),
  getDocsCreados(AutorName,TailDoc,TailSalida),!.
getDocsCreados(AutorName,[_|TailDoc],A):-getDocsCreados(AutorName,TailDoc,A),!.

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

revokeAccesses(Doc,UpdateDoc):-
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getTituloDoc(Doc,Titulo),
  getHistorialDoc(Doc,Historial),
  UpdateDoc = [Id,Autor,Titulo,[[Autor,["W","C","R","S"]]],Historial].

% Obtiene los documentos por ID y además les revoca el acceso
revokeAllAccesses(_,[],[]):-!.
revokeAllAccesses(Pdocs,[Id|T],[H1|T1]):-
  getDocumentById(Pdocs,Id,Doc),
  getAutorDoc(Doc,Autor),
  getLogeado(Pdocs,Logeado),
  Autor == Logeado,
  revokeAccesses(Doc,H1),
  revokeAllAccesses(Pdocs,T,T1).

/*-------------------------------------------TDA VERSION---------------------------------------------------
Dominios:
    Id:                                                 Integer
    Autor,Titulo,Username:                              String
    Historial, Shares, IDLIST                           Estructura Lista
    Date:                                               Date
    Pdocs:                                              ParadigmaDocs
    
Predicados:
    constVersion(Idvr,Fecha,Contenido,VERSION)          aridad: 4
    getIdVersion(VERSION,Id)                            aridad: 2

*/
constVersion(Idvr,Fecha,Contenido,NuevaVersion):-
  NewId is Idvr+1,
  NuevaVersion = [NewId,Fecha,Contenido].

%getIdVersion: Predicado que obtiene el id de la version
getIdVersion([Version,_,_],Version).
%getDateVersion: Predicado que obtiene la fecha de moficacion de la version
getDateVersion([_,Date,_],Date).
%getContenidoVersion: Predicado que obtiene el contenido de la version
getContenidoVersion([_,_,Contenido],Contenido).

%getVersionById: Predicado que obtiene una version mediante su idVersion
getVersionById(Historial,Id,Ver):-
  getIndexElement(Historial,Id,Index),
  myNth0(Index,Historial,Ver).

% Recibe el historial de versiones
getActiveVersion([Active|_],Active):-!.

% getContenidoDoc: Predicado que retorna el contenido de la version activa del documento
getContenidoDoc(Doc,Contenido):-
  getHistorialDoc(Doc,Historial),
  getActiveVersion(Historial,Active),
  getContenidoVersion(Active,Contenido).

deleteLast(String,Charac,StringDelet):-
  sub_string(String,0,_,Charac,StringDelet),!.

deleteLast(String,Charac,""):-
  string_length(String,Len),
  Len < Charac,!.

% PREDICADO SEARCH

getTextoVersiones([],[]).
getTextoVersiones([Version|TailVersion],[Texto|TextT]):-
  getContenidoVersion(Version,Texto),
  getTextoVersiones(TailVersion,TextT).

buscarPalabra(StringOriginal,StringBuscado):-
  sub_string(StringOriginal,_,_,_,StringBuscado),!.

notContainsText(_,[]):-!.
notContainsText(SearchText,[Texto1|TailTexto]):-
  \+buscarPalabra(Texto1,SearchText),
  notContainsText(SearchText,TailTexto).

getDocCoincidencias(_,[],[]):-!.
getDocCoincidencias(SearchText,[Doc1|TailDoc],[Doc1|T2]):-
  getHistorialDoc(Doc1,Historial),
  getTextoVersiones(Historial,TextoHistorial),
  \+notContainsText(SearchText,TextoHistorial),
  getDocCoincidencias(SearchText,TailDoc,T2),!.
getDocCoincidencias(S,[_|T],A):-getDocCoincidencias(S,T,A).

%  -------------------------------------------TDA ACCESS---------------------------------------------------
% TODOS LOS ACCESOS SOLO DEBEN SER DE LA FORMA "R", "W", "C"
% Predicado que determina si es un acceso valido los accessos solo pueden ser "W", "R", "C" o "S"

% Predicado que crea los accessos del documento,  otorgando a cada usuario los
createAccesses(_,_,[],[]):-!.   % Base Case 1
createAccesses(Sn1,Permisos,[User|TailUser],[[User,Permisos]|TF]):-
  isAccessList(Permisos),
  registradoAntes(Sn1,User),
  createAccesses(Sn1,Permisos,TailUser,TF).

isAccess(Access):-
  myMember(Access,["W","R","C","S"]).

% Predicado que determina si una lista de accesos tiene todos los accesos permitidos 
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
getUserPermiso([Nombre,_],Nombre).
getTipoPermiso([_,Permiso],Permiso).

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

%  -------------------------------------------OTROS PREDICADOS / HECHOS---------------------------------------------------
% AddHead: Añade elemento a la cabeza de la lista
addHead(E,Lista,[E|Lista]).

% IndexOf: Predicado que obtiene el índice de un elemento
indexOf([Element|_], Element, 0):-!. % We found the element
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),    % Check in the tail of the list
  Index is Index1+1.                 % and increment the resulting index

% myMember: Verifica si un elemento esta en una lista (Detiene el backtracking al encontrar la primera coincidiencia)
myMember(E,[E|_]):-!.
myMember(E,[_|T]):-
  myMember(E,T).

myNth0(0,[H|_],H):-!.
myNth0(Index,[_|T],E):-
  Index1 is Index - 1,
  myNth0(Index1,T,E).

% getIndexElement: Predicado que obtiene el indice de un documento
getIndexElement([[Element|_]|_], Element, 0):-!.
getIndexElement([_|Tail], Element, Index):-
  getIndexElement(Tail, Element, Index1),
  Index is Index1+1.

% ****************** TO STRING ************************
%dateString: Predicado que convierte una fecha en un String
dateString(Date,DateString):-
  getDay(Date,Day),
  getMonth(Date,Month),
  getYear(Date,Year),
  mesString(Month,MonthString),atomics_to_string([Day,"de",MonthString,Year]," ",DateString).
  
%registradosToString: Predicado que convierte a los registrados en un String
registradosToString([],[]).
registradosToString([Usuario|TailUser],[H1|T1]):-
  getUser(Usuario,User),
  getPass(Usuario,Pass),
  getFechaCreacionUser(Usuario,DateC), % GetDateCreation
  dateString(DateC,DateString),
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

%permisoToString: Predicado que convierte los accesos a String
accessToString([],[]).
accessToString([Access|TailAccess],[H1|T1]):-
  getUserPermiso(Access,Nombre),
  getTipoPermiso(Access,Tipo),
  permisoToString(Tipo,StringPermisoList),atomics_to_string(StringPermisoList,", ",StringPermiso),
  atomics_to_string(["\n\t   * ",Nombre," Permiso de ",StringPermiso],H1),
  accessToString(TailAccess,T1).

%permisoToString: Predicado que convierte el historial a String
historialToString([],[]).
historialToString([Version|RestoVer],[H1|T1]):-
  getIdVersion(Version,Idver),
  getDateVersion(Version,Date),
  dateString(Date,DateString),
  getContenidoVersion(Version,ContenidoVer),
  atomics_to_string(["\t\t* * * * * Version ", Idver," * * * * * \n\t\tCreada el ",DateString,"\n\t\t",ContenidoVer,"\n"],H1),
  historialToString(RestoVer,T1).

/*------------------------------------------MAIN---------------------------------------------------
Predicados:
Metas Primarias: paradigmaDocsRegister, paradigmaDocsLogin, paradigmaDocsCreate, paradigmaDocsShare, paradigmaDocsAdd, 
paradigmaDocsRestoreVersion, paradigmaDocsToString, paradigmaDocsRevokeAllAccesses, paradigmaDocsDelete.

Metas Secundarias: registradoAntes, getNombrePdocs, getFechaCreacionPdocs, getLogeado, getDocumentos, getRegistrados,
miembroPdocs, sesionActiva, setId, constVersion, constDoc, modificarDocs, getDocumentById, getAutorDoc, getTituloDoc,
getAccessesDoc, getHistorialDoc, isShareAdmin, filtraAccesses, createAccesses, getRestantes, isEditor, getActiveVersion,
getIdVersion, getContenidoVersion, constVersion, addHead, getVersionById, getDocsCreados, getDocsAcceso, docsToString,
dateString, docsToString, getIdsRestantes, revokeAccesses
*/

%ParadigmaDocsRegister:
%Dominio: Sn1, Fecha, Username, Password, Sn2

paradigmaDocsRegister(Sn1,Fecha,Username,Password,Sn2):-
  string(Username),
  string(Password),
  \+registradoAntes(Sn1,Username),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  getRegistrados(Sn1,Registrados),
  append(Registrados,[[Username,Password,Fecha]],UpdateRegistrados),
  Sn2 = [Nombre,FechaCreacion,UpdateRegistrados,Logeados,Docs],!.

% ParadigmaDocsLogin
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
  append(Logeados,[Username],UpdateLogeados),
  Sn2 = [Nombre,FechaCreacion,Registrados,UpdateLogeados,Docs].
% ParadigmaDocsCreate
% Dominio: Sn1, Fecha, Nombre, Contenido, Sn2
paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido,Sn2):-
  string(Nombre),
  string(Contenido),
  sesionActiva(Sn1),    % Si existe sesion activa se saca al usuario
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Autor),
  setId(Sn1,Id),
  constVersion(-1,Fecha,Contenido,Version),
  constDoc(Id,Autor,Nombre,[[Autor,["W","C","R","S"]]],[Version],Doc), % al autor del documento automaticamente se le añade un permiso con todos los accesos
  append(Docs,Doc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).
% ParadigmaDocsShare
% Dominio: Sn1, DocumentId, ListaPermisos, ListaUsernames Permitidos, Sn2
paradigmaDocsShare(Sn1,DocumentId,ListaPermisos,ListaUsernamesPermitidos,Sn2):-
  sesionActiva(Sn1),
  ListaPermisos \== [],
  getDocumentos(Sn1,Docs),
  getDocumentById(Sn1,DocumentId,Doc),
  getAutorDoc(Doc,Autor),
  getTituloDoc(Doc,TituloDoc),
  getAccessesDoc(Doc,OldAcceses),
  getHistorialDoc(Doc,Historial),
  isShareAdmin(Autor,OldAcceses),
  filtraAccesses(ListaUsernamesPermitidos,OldAcceses,FilteredAccesses),
  createAccesses(Sn1,ListaPermisos,ListaUsernamesPermitidos,Accesses),
  append(FilteredAccesses,Accesses,NewAccesses),
  constDoc(DocumentId,Autor,TituloDoc,NewAccesses,Historial,NuevoDoc),
  getRestantes(DocumentId,Docs,Restantes),
  append(Restantes,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).
% ParadigmaDocsAdd
% Dominio: Sn1, DocumentId, Date, ContenidoTexto, Sn2
paradigmaDocsAdd(Sn1,DocumentId,Date,ContenidoTexto,Sn2):-
  string(ContenidoTexto),
  sesionActiva(Sn1),
  getDocumentos(Sn1,Docs),

  getLogeado(Sn1,Logeado),
  getDocumentById(Sn1,DocumentId,Doc),    % get the document
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getTituloDoc(Doc,TituloDoc),
  getAccessesDoc(Doc,Accesses), % Se busca si el usuario esta en la lista de compartidos y tiene el permiso "Write"
  getHistorialDoc(Doc,Historial),

  isEditor(Logeado,Accesses),

  getActiveVersion(Historial,ActiveVersion),  % get Active version
  getIdVersion(ActiveVersion,IdVersion),
 
  getContenidoVersion(ActiveVersion,ContenidoVersion),
  string_concat(ContenidoVersion, ContenidoTexto, NuevoContenido),
  constVersion(IdVersion,Date, NuevoContenido, NuevaVersion),
  addHead(NuevaVersion,Historial,NuevoHistorial),
  constDoc(Id,Autor,TituloDoc,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  append(RestantesDoc,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).

% ParadigmaDocRestoreVersion
% Dominio: Sn1, DocumentId, IdVersion, Sn2
paradigmaDocsRestoreVersion(Sn1,DocumentId,IdVersion,Sn2):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),

  getDocumentById(Sn1,DocumentId,Doc),    % get the document
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getAccessesDoc(Doc,Accesses), % Se busca si el usuario esta en la lista de compartidos y tiene el permiso "Write"
  getHistorialDoc(Doc,Historial),
  getTituloDoc(Doc,Titulo),
  Autor == Logeado,
  getVersionById(Historial,IdVersion,Restaurada),
  getRestantes(IdVersion,Historial,VerRestantes),
  addHead(Restaurada,VerRestantes,NuevoHistorial),
  constDoc(Id,Autor,Titulo,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  append(RestantesDoc,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).

% ParadigmaDocsToString
% Dominio: Sn1, DocumentId, Date, ContenidoTexto, Sn2
paradigmaDocsToString(Sn1,PdocsUsrString):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocsCreados(Logeado,Docs,DocsCreados),
  getDocsAcceso(Logeado,Docs,DocsAcceso),

  docsToString(DocsCreados,DocStringCreados),atomics_to_string(DocStringCreados,DocStrings1),
  docsToString(DocsAcceso,DocStringAcceso),atomics_to_string(DocStringAcceso,DocStrings2),
  atomics_to_string(["\n* * * * * * * * *  ",Logeado,"  * * * * * * * * *  \n\n*********** Es Propietario de ***********",
  DocStrings1,"\n************ Tiene acceso a *************\n",DocStrings2],PdocsUsrString),!.

paradigmaDocsToString(Sn1,PDocsString):-
  \+sesionActiva(Sn1),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),

  dateString(FechaCreacion,DateString),
  registradosToString(Registrados,RegiStringList),atomics_to_string(RegiStringList,RegiString),
  
  docsToString(Docs,DocString),atomics_to_string(DocString,DocStrings),
  atomics_to_string(["\n* * * * * * * ",Nombre," * * * * * * *","\n",
  "Creado el ",DateString,"\n\n",
  "******** Usuarios Registrados ******** ",RegiString,"\n",
  "************* Documentos ************ ",DocStrings],PDocsString),!.

% ParadigmaDocsRevokeAllAccesses
% Dominio: Sn1, DocumentIds Sn2
paradigmaDocsRevokeAllAccesses(Sn1,DocumentIds,Sn2):-
  DocumentIds \= [],
  sesionActiva(Sn1),
  getDocumentos(Sn1,Docs),
  revokeAllAccesses(Sn1,DocumentIds,RevokedDocuments),
  getIdsRestantes(Docs,DocumentIds,RestantesDoc),
  append(RestantesDoc,RevokedDocuments,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2),!.
paradigmaDocsRevokeAllAccesses(Sn1,[],Sn2):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocsCreados(Logeado,Docs,DocsCreados),
  getIdDocCreados(DocsCreados,DocumentIds),
  revokeAllAccesses(Sn1,DocumentIds,RevokedDocuments),
  getIdsRestantes(Docs,DocumentIds,RestantesDoc),
  append(RestantesDoc,RevokedDocuments,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).

% ParadigmaDocsDelete
% Dominio: Sn1, DocumentId, Date, NumberOfCharacters, Sn2
paradigmaDocsDelete(Sn1,DocumentId,Date,NumberOfCharacters,Sn2):-
  integer(NumberOfCharacters),
  sesionActiva(Sn1),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Logeado),
  getDocumentById(Sn1,DocumentId,Doc),    % get the document
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getTituloDoc(Doc,TituloDoc),
  getAccessesDoc(Doc,Accesses), % Se busca si el usuario esta en la lista de compartidos y tiene el permiso "Write"
  getHistorialDoc(Doc,Historial),
  isEditor(Logeado,Accesses),
  getActiveVersion(Historial,ActiveVersion),  % get Active version
  getIdVersion(ActiveVersion,IdVersion),
  getContenidoVersion(ActiveVersion,ContenidoVersion),
  deleteLast(ContenidoVersion,NumberOfCharacters,NuevoContenido),

  constVersion(IdVersion,Date, NuevoContenido, NuevaVersion),
  addHead(NuevaVersion,Historial,NuevoHistorial),
  constDoc(Id,Autor,TituloDoc,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  append(RestantesDoc,NuevoDoc,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2).
% ParadigmaDocsSearch
% Dominio: Sn1, DocumentId, Date, NumberOfCharacters, Sn2
paradigmaDocsSearch(Sn1,String,Documents):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocsCreados(Logeado,Docs,DocsCreados),
  getDocsAcceso(Logeado,Docs,DocsAcceso),
  append(DocsCreados,DocsAcceso,AllDocs),
  getDocCoincidencias(String,AllDocs,Documents).

/*
EJEMPLOS:
------------------------------------------------------------------------------- Register -----------------------------------------------------------------------------------------
1. Se registran 3 usuarios unicos: saul, kim y chuck
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4).

% *************************************************************************** Excepciones(false) ***********************************************************************************
2. Se intenta logear 2 usuarios con el mismo username, retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"chuck","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4).
3. Se intentan logear 3 usuarios con el mismo username, retorna (false)date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"chuck","1234",PD3),paradigmaDocsRegister(PD3,D3,"chuck","4321",PD4).

-------------------------------------------------------------------------------- Login --------------------------------------------------------------------------------------------
1. Se logea un usuario existente con credenciales correctas:
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5).

***************************************************************************** Excepciones(false) **********************************************************************************
2. Se intenta logear un usuario cuando ya existe una sesión activa en paradigmaDocs(false):
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsLogin(PD5,"kim","4321",PD6).

3. El usuario "saul" se intenta logear con contraseña incorrecta, el predicado, retorna false:
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"saul","qwerty",PD5).

4. Se intenta logear un usuario, no registrado en paradigmaDocs, retorna false:
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"mike","98415",PD5).

------------------------------------------------------------------------------- Create ---------------------------------------------------------------------------------------------
1. El usuario "chuck" autenticado, crea un nuevo documento en paradigmaDocs id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6).

2. El usuario "saul" autenticado, crea un nuevo documento en paradigmaDocs id:1
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8).

3. El usuario "kim" autenticado, crea un nuevo documento en paradigmaDocs id:2
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10).

4. El usuario "kim" autenticado, crea un nuevo documento en paradigmaDocs id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12).

*************************************************************************** Excepciones(false) *************************************************************************************
1. Usuario No Logeado
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsCreate(PD4,D1,"DocChuck","Contenidochuck",PD5).

------------------------------------------------------------------------------ Share ------------------------------------------------------------------------------------------------
1. El usuario kim se logea y posterior a esto, aplica "Share" al documento de ID=2 el cual es dueña, y otorga los permisos de ["S"] a los usuarios "chuck" y a "saul"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["S"],["chuck","saul"],PD12).

2. El usuario kim se logea y posterior a esto, aplica "Share" al documento de ID=2 el cual es dueña, y subrescribe los permisos de ["S"] otorgados anteriormente a "chuck" y a "saul" y otorga ["W","R","S"] en su lugar
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["S"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14).

3. El usuario Saul ahora posee permiso "S" de compartir otorgado por "kim" en doc id: 2, por lo tanto puede compartir y otorgar permisos sobre el documento id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["S"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"saul","1234",PD15),paradigmaDocsShare(PD15,2,["W"],["saul"],PD16).

*************************************************************************** Excepciones(false) *************************************************************************************
4. El usuario kim se logea y posterior a esto, aplica "Share" al documento de ID=0 el cual es dueño, pero otorga permisos no permitidos por paradigmaDocs, retornando (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["U","P"],["chuck","saul"],PD12).

5. El usuario chuck se logea y posterior a esto, aplica "Share" al documento de ID=0 el cual es dueño, pero otorga permisos a usuarios no registrados en paradigmaDocs (mike), retornando (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,2,["W"],["mike","saul"],PD12).

6. El usuario saul se logea y posterior a esto, aplica "Share" al documento de ID=4 el cual no existe
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsShare(PD11,4,["W"],["chuck","saul"],PD12).


----------------------------------------------------------------------------- Add ---------------------------------------------------------------------------------------------------
1. El usuario chuck es editor del documento id:2, por lo tanto puede aniadir texto a este
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16).

2. El usuario kim es duenio del documento id:2, por lo tanto puede aniadir texto a este
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18).

3. El usuario saul es duenio del documento id:1, por lo tanto puede aniadir texto a este
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3," contenido Aniadido por Saul",PD20).

*************************************************************************** Excepciones(false) *************************************************************************************
4. El usuario chuck es no es editor del documento id:1, retorna false
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,1,D3," Contenido Aniadido por Chuck",PD16).

-------------------------------------------------------------------------- Restore Version -----------------------------------------------------------------------------------------------
1. El usuario kim dueño del document id:2 con idVersion Activa 2, restaura la version id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"kim","4321",PD21),paradigmaDocsRestoreVersion(PD21,2,0,PD22).

2. El usuario saul dueño del document id:1 con idVersion Activa 1, restaura la version id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,0,PD22).

3. El usuario saul dueño del document id:1 con idVersion Activa 1, restaura la version id:1, el documento no sufre ningun cambio
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22).

*************************************************************************** Excepciones(false) *************************************************************************************
4. El usuario Saul no es dueño del documento id:2
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,2,1,PD22).

-------------------------------------------------------------------------- ParadigmaDocsToString -----------------------------------------------------------------------------------------------
1. Version de paradigmaDocsToString sin usuario logeado
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsToString(PD22,Sout),write(Sout).

2. Version de paradigmaDocsToString con un usuario logeado "kim"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"saul","1234",PD23),paradigmaDocsShare(PD23,1,["W","R","S"],["chuck","kim"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsToString(PD25,Sout),write(Sout).

3. Version de paradigmaDocsToString con un usuario logeado "chuck"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"chuck","qwerty",PD23),paradigmaDocsToString(PD23,Sout),write(Sout).

----------------------------------------------------------------------------- Revoke All Accesses --------------------------------------------------------------------------------------------------

1. El usuario kim revoca el acceso a todos sus documentos (id:3, id:2), ingresando [], se puede apreciar mas claramente en paradigmaDocsToString
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[],PD26).

2. El usuario kim revoca el acceso al documento id:2, ingresando [2], los otros documentos permanecen con accesos
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2],PD26).

3. El usuario kim revoca el acceso al documento id:2, ingresando [2,3], los otros documentos permanecen con accesos
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2,3],PD26).

4. El usuario chuck revoca el acceso al documento id:0, ingresando [0], los otros documentos permanecen con accesos
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsRevokeAllAccesses(PD25,[0],PD26).

*************************************************************************** Excepciones(false) *************************************************************************************
5. El usuario Saul no es dueño del documento id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsRevokeAllAccesses(PD25,[0],PD26).

6. Kim desea revocar los accesos [2,3,4] donde id:4 no es dueña Retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2,3,4],PD26).

7. No hay sesión activa retorna (false)
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsRevokeAllAccesses(PD24,[2],PD25).

----------------------------------------------------------------------------- Delete --------------------------------------------------------------------------------------------------
1. Se borran los ultimos 10 caracteres de la version activa del documento id:1 el cual Saul tiene acceso, quedando: "ContenidoSaul/Contenido Aniadid"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsDelete(PD25,1,D3,10,PD26).

2. Se borran los ultimos 100 caracteres el largo de la palabra es menor a la cantidad a eliminar, quedando ""
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsDelete(PD25,1,D3,100,PD26).

3. Se borran los ultimos 13 caracteres del documento id:3 al que chuck tiene acceso, quedando "2"
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsDelete(PD25,3,D3,13,PD26).  

*************************************************************************** Excepciones(false) *************************************************************************************
4. Usuario Chuck no tiene acceso al documento id:1
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsDelete(PD25,1,D3,13,PD26).  

5. Usuario no logeado (false):
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsDelete(PD24,2,D3,10,PD25). 

----------------------------------------------------------------------------- Search --------------------------------------------------------------------------------------------------
1. Se busca "Contenido" en los documentos a los que "kim" tiene acceso , se encuentra una coincidencia en doc id:2 y id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsSearch(PD25,"Contenido",Documents).
2. Se busca "Kim" en los documentos a los que Chuck tiene acceso (Tiene algun permiso), encontrando coincidencias en  los doc id:2 y id:3
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsSearch(PD25,"Kim",Documents).
3. Saul busca la palabra "Saul" en los documentos que tiene acceso, tiendo una coiencidencia en doc id:1
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsSearch(PD25,"Saul",Documents).
4. Chuck busca la palabra "Hola" en los documentos a los que tiene acceso (W,R,C,S), no se encuentran coincidencias, retorna []
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"chuck","qwerty",PD25),paradigmaDocsSearch(PD25,"Hola",Documents).

*************************************************************************** Excepciones(false) *************************************************************************************
4. Usuario no logeado
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsSearch(PD24,"Saul",Documents).
*/ 