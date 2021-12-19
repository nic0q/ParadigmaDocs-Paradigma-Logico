%  -------------------------------------------TDA DATE--------------------------------------------------
% Hechos:
mes(1,31). mes(2,28). mes(2,29). mes(3,31). mes(4,30). mes(5,31). mes(6,30). mes(7,31). mes(8,31). mes(9,30). mes(10,31). mes(11,30). mes(12,31).
mesString(1,"Enero"). mesString(2,"Febrero"). mesString(3,"Marzo"). mesString(4,"Abril"). mesString(5,"Mayo"). mesString(6,"Junio"). mesString(7,"Julio").
mesString(8,"Agosto"). mesString(9,"Septiembre"). mesString(10,"Octubre"). mesString(11,"Noviembre"). mesString(12,"Diciembre").

% Constructor
date(Day, Month, Year, Date):-
  integer(Day), integer(Month), integer(Year),mes(Month,Dias),
  Day=<Dias,Date = [Day, Month, Year].

% Selectores
getDay([D,_,_],D).
getMonth([_,M,_],M).
getYear([_,_,Y],Y).

%  ------------------------------------------- TDA PARADIGMADOCS -------------------------------------------------
% Constructor Paradigmadocs
paradigmaDocs(Name,Date,[Name,Date,[],[],[]]):-
  string(Name).      % nota: no es necesario verificar que es una fecha, pues el predicado del TDA fecha lo verifica antes de pasarlo

% Predicado usado para construir la version anterior (Sn1) de paradigmadocs
constPdocs(Name,Date,Registrados,Logeados,Documentos,[Name,Date,Registrados,Logeados,Documentos]).

% Getters ParadigmaDocs
getNombrePdocs([Nombre|_],Nombre).
getFechaCreacionPdocs([_,Fecha|_],Fecha).
getRegistrados([_,_,ListaReg|_],ListaReg).
getLogeados([_,_,_,ListaLog|_],ListaLog).
getDocumentos([_,_,_,_,ListaDocs],ListaDocs).

modificarDocs([NombrePdocs,FechaCreacion,Registrados|_],UpdateDocs,Sn2):-
   Sn2 = [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].

%  -----------------------------------------------TDA USER--------------------------------------------------------
% Getters Usuario
getUser([User,_,_],User).
getPass([_,Pass,_],Pass).
getFechaCreacionUser([_,_,DateC],DateC). % GetDateCreation

% Obtiene una lista con todos los usernames de los usuarios registrados
getUserNames([],[]).
getUserNames([H|T],[H1|T1]):-
  getUser(H,H1),
  getUserNames(T,T1).

% Obtiene una lista con todas las contraseñas de los usuarios registrados
getPasswords([],[]).
getPasswords([H|T],[H1|T1]):-
  getPass(H,H1),
  getPasswords(T,T1).

% getLogeado: Predicado que extrae al usuario con sesión activa en paradigmadocs
getLogeado(Sn1,Logeado):-
  getLogeados(Sn1,[Logeado|_]).

getRegisterUsers(Sn1,Users):-
  getRegistrados(Sn1,Registrados),
  getUserNames(Registrados,Users).

% Registrado Antes: Predicado que determina si un usuario se ha registrado antes
registradoAntes(ParadigmaDocs,User):-
  string(User),
  getRegistrados(ParadigmaDocs,ListaRegistrados),
  getUserNames(ListaRegistrados,Usernames),
  myMember(User,Usernames).

% Predicado que verifica si un usuario tiene la contraseña y el username para ser miembro de paradigmadocs
miembroPdocs(Sn1,Usuario,Password):-
  getRegistrados(Sn1,Registrados),
  getUserNames(Registrados,Usernames),
  getPasswords(Registrados,Passwords),
  indexOf(Usernames,Usuario,Index),
  nth0(Index,Passwords,Pass),
  Pass == Password.

% SesionActiva: Predicado que verifica cuando un usuario tiene sesion activa en paradigmaDocs
sesionActiva(Sn1):-
  getLogeados(Sn1,Logeados),
  \+Logeados==[].

%  -------------------------------------------TDA DOC--------------------------------------------------
% Constructor de Documento
constDoc(Id,Autor,Titulo,Shares,Historial,[[Id,Autor,Titulo,Shares,Historial]]).
% Constructor de Historial (Version)
% Getters Documento:
getIdDoc([Id|_],Id).        % Id Documento
getAutorDoc([_,Autor|_],Autor).
getTituloDoc([_,_,Titulo|_],Titulo).
getAccessesDoc([_,_,_,Shares|_],Shares).
getHistorialDoc([_,_,_,_,Historial],Historial).

setId(Sn1,Id):-
  getDocumentos(Sn1,Docs),
  length(Docs,Idd),
  Id is Idd.

getIndexElement([[Id|_]|_], Id, 0):-!.
getIndexElement([_|Tail], Id, Index):-
  getIndexElement(Tail, Id, Index1),
  Index is Index1+1.

getDocumentById(Sn1,Id,Docu):-
  getDocumentos(Sn1,Docs),
  getIndexElement(Docs,Id,Index),
  nth0(Index,Docs,Docu).

getRestantes(Id,[[Id|_]|E],E):-!.
getRestantes(_,[],[]):-!.
getRestantes(Id,[H|T],[H|T1]):-
  getRestantes(Id,T,T1).

accessByShare(_,[],[]):-!.
accessByShare(Doc,_,Doc):-!.

getSharedDocuments(_,[],[]):-!.
getSharedDocuments(Usr,[Docu|T],[H1|T1]):-
  getAccessesDoc(Docu,[_|Permisos]),
  getPermisos(Usr,Permisos,PermisosUsr),
  accessByShare(Docu,PermisosUsr,H1),
  getSharedDocuments(Usr,T,T1).

getMyDocs(_,[],[]):-!.
getMyDocs(Usr,[Docu|T],[H1|T1]):-
  getAccessesDoc(Docu,[Permisos|_]),
  getPermisos(Usr,[Permisos],PermisosUsr),
  accessByShare(Docu,PermisosUsr,H1),
  getMyDocs(Usr,T,T1).

% GetDocsCreados
getDocsCreados(User,Docs,Exit):-
  getMyDocs(User,Docs,Exit1),
  filterList([], Exit1,Exit).

% GetDocsAcceso
getDocsAcceso(User,Docs,Exit):-
  getSharedDocuments(User,Docs,Exit1),
  filterList([], Exit1, Exit).

getIdDocCreados([],[]).
getIdDocCreados([Doc|TailDoc],[H1|T1]):-
  getIdDoc(Doc,H1),
  getIdDocCreados(TailDoc,T1).
  
revokeAccesses(Doc,UpdateDoc):-
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getTituloDoc(Doc,Titulo),
  getHistorialDoc(Doc,Historial),
  UpdateDoc = [Id,Autor,Titulo,[[Autor,["W","C","R","S"]]],Historial].

% Obtiene los documentos por ID y además les revoca el acceso
revokeAllAccesses(_,[],[]):-!.
revokeAllAccesses(Sn1,[H|T],[H1|T1]):-
  getDocumentById(Sn1,H,Doc),
  getAutorDoc(Doc,Autor),
  getLogeado(Sn1,Logeado),
  Logeado == Autor,
  revokeAccesses(Doc,H1),
  revokeAllAccesses(Sn1,T,T1).

getRestantesLista(Restantes,[],Restantes):-!.
getRestantesLista(Documentos,[H|T],X):-
  getRestantes(H,Documentos,Actualizada),
  getRestantesLista(Actualizada,T,X).

%  -------------------------------------------TDA VERSION---------------------------------------------------
constVersion(Idvr,Fecha,Contenido,NuevaVersion):-
  NewId is Idvr+1,
  NuevaVersion = [NewId,Fecha,Contenido].

getIdVersion([Version,_,_],Version).
getDateVersion([_,Date,_],Date).
getContenidoVersion([_,_,Contenido],Contenido).

getVersionById(Historial,Id,Ver):-
  getIndexElement(Historial,Id,Index),
  nth0(Index,Historial,Ver).

noUnica([_|NotActive],NotActive).
% Recibe el historial de versiones
getActiveVersion([Active|_],Active):-!.

getNotActiveVersions(Historial,NotActive):-
  \+Historial==[],
  noUnica(Historial,NotActive).

aniadirActiveVersion(Historial, Version, NuevoHistorial):-
  getNotActiveVersions(Historial,NotActive),
  append([Version],[NotActive],NuevoHistorial).

deleteLast(String,Charac,StringDelet):-
  sub_string(String,0,_,Charac,StringDelet),!.

deleteLast(String,Charac,""):-
  string_length(String,Len),
  Len < Charac,!.
%  -------------------------------------------TDA ACCESS---------------------------------------------------
% TODOS LOS ACCESOS SOLO DEBEN SER DE LA FORMA "R", "W", "C"
% Los accessos solo pueden ser "W", "R" o "C"
isAccess(Access):-
  myMember(Access,["W","R","C","S"]).

isAccessList([]):-!.
isAccessList([H|T]):-
  isAccess(H),
  isAccessList(T).

isEditor(Usuario,Accesses):-
  getPermisos(Usuario,Accesses,PermisosUsuario),
  myMember("W",PermisosUsuario).

isShareAdmin(Usuario,Accesses):-
  getPermisos(Usuario,Accesses,PermisosUsuario),
  myMember("S",PermisosUsuario).

% Predicado que crea los accessos del documento,  otorgando a cada usuario los
createAccesses(_,_,[],[]):-!.   % Base Case 1
createAccesses(Sn1,Permisos,[U1|T1],[[U1,Permisos]|TF]):-
  isAccessList(Permisos),
  registradoAntes(Sn1,U1),
  createAccesses(Sn1,Permisos,T1,TF).

getNombrePermiso([Nombre,_],Nombre).
getTipoPermiso([_,Permiso],Permiso).

% UserName, [AccessList], ["W"]
getPermisos(UserName,[[UserName,Permisos]|_],Permisos):-!.
getPermisos(_,[],[]):-!.
getPermisos(UserName,[_|T],T1):-
getPermisos(UserName,T,T1).

% Elimina la primera coincidencia de un acceso del tipo ["user1",["W"]]
filtraAccess(Usuario,[[Usuario|_]|Tail],Tail):-!.     % Doble operador de corte, elimina la primera coincidencia
filtraAccess(_,[],[]):-!.                  % Doble operador de corte
filtraAccess(Usuario,[H|T],[H|T1]):-
  filtraAccess(Usuario,T,T1).
% Eliminar duplicados
% ListaUsuarios X ListaAccesses
filtraAccesses([],Restantes,Restantes):-!.
filtraAccesses([User|TailUser],Accesses,X):-
  filtraAccess(User,Accesses,Filtrada),
  filtraAccesses(TailUser,Filtrada,X).

permisoString("W","Escritura").
permisoString("R","Lectura").
permisoString("C","Comentarios").
permisoString("S","Compartir").

%  -------------------------------------------OTROS PREDICADOS / HECHOS---------------------------------------------------
% AddHead:
% Añade elemento a la cabeza de la lista
addHead(E,Lista,[E|Lista]).

% IndexOf:
indexOf([Element|_], Element, 0):-!. % We found the element
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),    % Check in the tail of the list
  Index is Index1+1.                 % and increment the resulting index

% MyMember:
% Realiza exactamente lo mismo que member pero detiene el backtracking cuando encuentra el elemento (true)
myMember(E,[E|_]):-!.
myMember(E,[_|T]):-
  myMember(E,T).

equal(X, Y) :-
    X == Y.
filterList(A, In, Out) :-
    exclude(equal(A), In, Out).

% ****************** TO STRING ************************
dateString(Date,DateString):-
  getDay(Date,Day),
  getMonth(Date,Month),
  getYear(Date,Year),
  mesString(Month,MonthString),atomics_to_string([Day,"de",MonthString,Year]," ",DateString).
  
registradosToString([],[]).
registradosToString([Usuario|TailUser],[H1|T1]):-
  getUser(Usuario,User),
  getPass(Usuario,Pass),
  getFechaCreacionUser(Usuario,DateC), % GetDateCreation
  dateString(DateC,DateString),
  atomics_to_string(["\nUsuario: ",User,"\n","Password: ",Pass,"\n","Registrado el ",DateString,"\n"],H1),
  registradosToString(TailUser,T1).

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

permisoToString([],[]).
permisoToString([Permiso|TailPermiso],[H1|T1]):-
  permisoString(Permiso,H1),
  permisoToString(TailPermiso,T1).

accessToString([],[]).
accessToString([Access|TailAccess],[H1|T1]):-
  getNombrePermiso(Access,Nombre),
  getTipoPermiso(Access,Tipo),
  permisoToString(Tipo,StringPermisoList),atomics_to_string(StringPermisoList,", ",StringPermiso),
  atomics_to_string(["\n\t   * ",Nombre," Permiso de ",StringPermiso],H1),
  accessToString(TailAccess,T1).

historialToString([],[]).
historialToString([Version|RestoVer],[H1|T1]):-
  getIdVersion(Version,Idver),
  getDateVersion(Version,Date),
  dateString(Date,DateString),
  getContenidoVersion(Version,ContenidoVer),
  atomics_to_string(["\t\t* * * * * Version ", Idver," * * * * * \n\t\tCreada el ",DateString,"\n\t\t",ContenidoVer,"\n"],H1),
  historialToString(RestoVer,T1).

%  -------------------------------------------MAIN---------------------------------------------------
% Predicados:
% Metas Secundarias: registradoAntes, 
% ParadigmaDocsRegister:
% Dominio: Sn1, Fecha, Username, Password, Sn2
% Metas Principales: Register, Login, Share, Add, RestoreVersion, Search
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
  Sn2 = [Nombre,FechaCreacion,UpdateRegistrados,Logeados,Docs].
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
  Sn2 = [Nombre,FechaCreacion,Registrados,UpdateLogeados,Docs]. % Retorna paradigmaDocs con la lista de logeados actualizada
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
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
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
  Sn2 = [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].
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
  getRestantesLista(Docs,DocumentIds,RestantesDoc),
  append(RestantesDoc,RevokedDocuments,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2),!.
paradigmaDocsRevokeAllAccesses(Sn1,_,Sn2):-
  sesionActiva(Sn1),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),
  getDocsCreados(Logeado,Docs,DocsCreados),
  getIdDocCreados(DocsCreados,DocumentIds),
  revokeAllAccesses(Sn1,DocumentIds,RevokedDocuments),
  getRestantesLista(Docs,DocumentIds,RestantesDoc),
  append(RestantesDoc,RevokedDocuments,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2),!.

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

% EJEMPLOS:
% ------------------------------------------------------------------------------- Register -----------------------------------------------------------------------------------------
% 1. Se registran 3 usuarios unicos: saul, kim y chuck
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4).

% *************************************************************************** Excepciones(false) ***********************************************************************************
% 1. Se intenta logear un usuario con el mismo "username", el predicado:
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"chuck","1234",PD3).

% -------------------------------------------------------------------------------- Login --------------------------------------------------------------------------------------------
% 1. Se logea un usuario existente con credenciales correctas:
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5).
% ***************************************************************************** Excepciones(false) **********************************************************************************
% 1. Se intenta logear un usuario cuando ya existe una sesión activa en paradigmaDocs(false):
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsLogin(PD5,"kim","4321",X).
% 2. El usuario "saul" se intenta logear con contraseña incorrecta, el predicado, retorna false:
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"saul","qwerty",PD5).
% 3. El usuario "chuck" ya se encuentra logeado, ahora el usuario "saul" desea logearse, pero no esta permitido, retorna false:
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsLogin(PD5, "saul","1234",PD6).
% 4. Se intenta logear un usuario, no registrado en paradigmaDocs, retorna false:
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"JuanJose","qwerty",PD5).

% ------------------------------------------------------------------------------- Create ---------------------------------------------------------------------------------------------
% 1. El usuario "chuck" autenticado, crea un documento en paradigmaDocs id:0
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6).
% 2. El usuario "saul" autenticado, crea un documento en paradigmaDocs id:1
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8).
% 3. El usuario "kim" autenticado, crea un documento en paradigmaDocs id:2
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10).
% *************************************************************************** Excepciones(false) *************************************************************************************
% 1. Usuario No Logeado
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4),paradigmaDocsCreate(PD4,D2,"Titulochuck","Contenidochuck",PD5).

% ------------------------------------------------------------------------------ Share ------------------------------------------------------------------------------------------------
% 1. El usuario kim se logea y posterior a esto, aplica "Share" al documento de ID=2 el cual es dueña, y otorga los permisos de "W" "C" al usuario "chuck" y a "saul"
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12).

% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["R"],["chuck","saul"],PD14).
% ----------------------------------------------------------------------------- Add ---------------------------------------------------------------------------------------------------
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsAdd(PD13,2,D1,"blabla",PD14).
% *************************************************************************** Excepciones(false) *************************************************************************************
% ADD AND SHARE
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"chuck","qwerty",PD13), paradigmaDocsAdd(PD13,2,D1,"blabla",PD14),paradigmaDocsLogin(PD14,"kim","4321",PD15), paradigmaDocsCreate(PD15,D1,"KIMDOC2","KimCOntent2",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsShare(PD17,3,["W","C"],["chuck","saul"],PD18),
% [["kim", ["W", "C", "R"]], ["chuck", ["W", "C"]], ["saul", ["W", "C"]]
% ----------------------------------------------------------------------------- Restore Version -----------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------- Revoke All Accesses --------------------------------------------------------------------------------------------------
% date(20, 12, 2020, D1),date(21, 12, 2021, D2), date(21, 12, 2021, D3),paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"chuck","qwerty",PD13), paradigmaDocsAdd(PD13,2,D3,"blabla",PD14),paradigmaDocsLogin(PD14,"kim","4321",PD15), paradigmaDocsCreate(PD15,D1,"KIMDOC2","KimCOntent2",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsShare(PD17,3,["W","C"],["chuck","saul"],PD18),paradigmaDocsLogin(PD18,"kim","4321",PD19),paradigmaDocsRevokeAllAccesses(PD19,[3,2],PD20).

