%  -------------------------------------------TDA DATE--------------------------------------------------
% Hechos:
mes(1,31). mes(2,28). mes(2,29). mes(3,31). mes(4,30). mes(5,31). mes(6,30). mes(7,31). mes(8,31). mes(9,30). mes(10,31). mes(11,30). mes(12,31).
mesString(1,"Enero"). mesString(2,"Febrero"). mesString(3,"Marzo"). mesString(4,"Abril"). mesString(5,"Mayo"). mesString(6,"Junio"). mesString(7,"Julio").
mesString(8,"Agosto"). mesString(9,"Septiembre"). mesString(10,"Octubre"). mesString(11,"Noviembre"). mesString(12,"Diciembre").

% Constructor
date(Day, Month, Year, Date):-
  integer(Day), integer(Month), integer(Year),mes(Month,Dias),
  Day=<Dias,
  Date = [Day, Month, Year].

% Selectores
getDay([D,_,_],D).
getMonth([_,M,_],M).
getYear([_,_,Y],Y).

%  ------------------------------------------- TDA PARADIGMADOCS -------------------------------------------------
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
getRegistrados([_,_,ListaReg|_],ListaReg).

% getLogeados: Predicado que obtiene la lista de logeados e paradigmaDocs
getLogeados([_,_,_,ListaLog|_],ListaLog).

% getDocumentos: Predicado que la lista de documentos de paradigmaDocs
getDocumentos([_,_,_,_,ListaDocs],ListaDocs).

% getDocumentos: Predicado que mofica la estrucutra de documentos de paradigmaDocs y retorna una version actualizada de esta
modificarDocs([NombrePdocs,FechaCreacion,Registrados|_],UpdateDocs,Sn2):-
   Sn2 = [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].

%  -----------------------------------------------TDA USER--------------------------------------------------------
% getUser: Predicado que obtine el username del usuario registrado
getUser([User,_,_],User).
% getUser: Predicado que obtine la contraseña del usuario registrado
getPass([_,Pass,_],Pass).
% getUser: Predicado que obtine la fecha de creacion de cuenta del usuario registrado
getFechaCreacionUser([_,_,DateC],DateC).

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
getLogeado(Sn1,Logeado):-
  getLogeados(Sn1,[Logeado|_]).

% getUserNames: Predicado que obtiene una lista con todos los usernames registados
getRegisterUsers(Sn1,Users):-
  getRegistrados(Sn1,Registrados),
  getUserNames(Registrados,Users).

% registrado Antes: Predicado que determina si un usuario se ha registrado antes
registradoAntes(ParadigmaDocs,User):-
  string(User),
  getRegistrados(ParadigmaDocs,ListaRegistrados),
  getUserNames(ListaRegistrados,Usernames),
  myMember(User,Usernames).

% miembroPdocs: Predicado que verifica si un usuario tiene la contraseña y el username para ser miembro de paradigmadocs
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
setId(Sn1,Id):-
  getDocumentos(Sn1,Docs),
  length(Docs,Idd),
  Id is Idd.

% getIndexElement: Predicado que obtiene el indice de un documento
getIndexElement([[Id|_]|_], Id, 0):-!.
getIndexElement([_|Tail], Id, Index):-
  getIndexElement(Tail, Id, Index1),
  Index is Index1+1.

% getDocumentById: Predicado que obtiene un documento mediante su id 
getDocumentById(Sn1,Id,Docu):-
  getDocumentos(Sn1,Docs),
  getIndexElement(Docs,Id,Index),
  nth0(Index,Docs,Docu).

% getRestantes: Predicado que obtiene los restantes que no es igual al id
getRestantes(Id,[[Id|_]|E],E):-!.
getRestantes(_,[],[]):-!.
getRestantes(Id,[H|T],[H|T1]):-
  getRestantes(Id,T,T1).

% PENDIENTE
appendDoc(_,[],[]):-!.
appendDoc(Doc,_,Doc):-!.

% getSharedDocuments: Predicado que obtiene los documentos a los que el usuario tiene acceso
getSharedDocuments(_,[],[]):-!.
getSharedDocuments(Usr,[Docu|T],[H1|T1]):-
  getAccessesDoc(Docu,[_|Permisos]),
  getPermisos(Usr,Permisos,PermisosUsr),
  appendDoc(Docu,PermisosUsr,H1),
  getSharedDocuments(Usr,T,T1).

% getMyDocs: Predicado que filtra los documentos en una lista a los que el usuario es creador
% Si no tiene acceso retorna -1 sino retorna el documento
getMyDocs(_,[],[]):-!.
getMyDocs(Usr,[Docu|T],[H1|T1]):-
  getAccessesDoc(Docu,[Permisos|_]),
  getPermisos(Usr,[Permisos],PermisosUsr),
  appendDoc(Docu,PermisosUsr,H1),
  getMyDocs(Usr,T,T1).

% GetDocsCreados: ¨red
getDocsCreados(User,Docs,Exit):-
  getMyDocs(User,Docs,Exit1),
  filterList([], Exit1,Exit).

% GetDocsAcceso: Predicado que obtiene 
getDocsAcceso(User,Docs,Exit):-
  getSharedDocuments(User,Docs,Exit1),
  filterList([], Exit1, Exit).

% getIdDocCreados: Predicado que obtiene los id's de los documentos creados por el usuario
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
revokeAllAccesses(Sn1,[Id|T],[H1|T1]):-
  getDocumentById(Sn1,Id,Doc),
  getAutorDoc(Doc,Autor),
  getLogeado(Sn1,Logeado),
  Autor == Logeado,
  revokeAccesses(Doc,H1),
  revokeAllAccesses(Sn1,T,T1).

% Predicado Pendiente para Search
% searchInDoc(_,[],[]):-!.
% searchInDoc(Sn1,[Id|T],[H1|T1]):-
%   getLogeado(Sn1,Logeado),
%   getDocumentById(Sn1,Id,Doc),
%   getAccessesDoc(Doc,Accesses),
%   tieneAcceso(Logeado,Accesses),
%   getContenidoDoc(Doc,Contenido),
%   buscarPalabra(Contenido,String),
%   searchInDoc(Sn1,T,T1).

getRestantesLista(Restantes,[],Restantes):-!.
getRestantesLista(Documentos,[H|T],X):-
  getRestantes(H,Documentos,Actualizada),
  getRestantesLista(Actualizada,T,X).

%  -------------------------------------------TDA VERSION---------------------------------------------------
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
  nth0(Index,Historial,Ver).

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
%  -------------------------------------------TDA ACCESS---------------------------------------------------
% TODOS LOS ACCESOS SOLO DEBEN SER DE LA FORMA "R", "W", "C"
% Predicado que determina si es un acceso valido los accessos solo pueden ser "W", "R", "C" o "S"
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

% TieneAcceso: Predicado que determina si un usuario tiene cualquier permiso o acceso a un documento "W" or "S" or "R" or "C"
tieneAcceso(Usuario,Accesses):-
  getPermisos(Usuario,Accesses,PermisosUsuario),
  (myMember("S",PermisosUsuario);myMember("W",PermisosUsuario);myMember("R",PermisosUsuario);myMember("C",PermisosUsuario)),!.

% Predicado que crea los accessos del documento,  otorgando a cada usuario los
createAccesses(_,_,[],[]):-!.   % Base Case 1
createAccesses(Sn1,Permisos,[U1|T1],[[U1,Permisos]|TF]):-
  isAccessList(Permisos),
  registradoAntes(Sn1,U1),
  createAccesses(Sn1,Permisos,T1,TF).

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

equal(X, X).
filterList(A, In, Out) :-
    exclude(equal(A), In, Out).

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
dateString, docsToString, getRestantesLista, revokeAccesses
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
  getRestantesLista(Docs,DocumentIds,RestantesDoc),
  append(RestantesDoc,RevokedDocuments,UpdateDocs),
  modificarDocs(Sn1,UpdateDocs,Sn2),!.
paradigmaDocsRevokeAllAccesses(Sn1,DocumentIds,Sn2):-
  DocumentIds == [],
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
% ParadigmaDocsSearch
% Dominio: Sn1, DocumentId, Date, NumberOfCharacters, Sn2
% paradigmaDocsSeach(Sn1,String,ListDocument):-
%   getLogeado(Sn1,Logeado),
%   string(String),
%   getDocsCreados(Logeado,Docs,DocsCreados),
%   getDocsAcceso(Logeado,Docs,DocsAcceso),


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
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[],PD26),paradigmaDocsLogin(PD26,"kim","4321",PD27),paradigmaDocsToString(PD27,PD28),write(PD28).

2. El usuario kim revoca el acceso al documento id:2, ingresando [2],el documento id:3 mantiene sus permisos se puede apreciar mas claramente en paradigmaDocsToString
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"kim","4321",PD25),paradigmaDocsRevokeAllAccesses(PD25,[2],PD26),paradigmaDocsLogin(PD26,"kim","4321",PD27),paradigmaDocsToString(PD27,PD28),write(PD28).

3. El usuario Saul no es dueño del documento id:0
date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsRevokeAllAccesses(PD25,[0],PD26).
----------------------------------------------------------------------------- Delete --------------------------------------------------------------------------------------------------
1. date(20, 12, 2020, D1),date(29, 10, 2021, D2),date(12, 08, 2021, D3),paradigmaDocs("Google docs", D1, PD1),paradigmaDocsRegister(PD1, D1, "chuck", "qwerty", PD2),paradigmaDocsRegister(PD2,D2,"saul","1234",PD3),paradigmaDocsRegister(PD3,D3,"kim","4321",PD4),paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D1,"DocChuck","Contenidochuck",PD6),paradigmaDocsLogin(PD6,"saul","1234",PD7),paradigmaDocsCreate(PD7,D1,"DocSaul","ContenidoSaul",PD8),paradigmaDocsLogin(PD8,"kim","4321",PD9),paradigmaDocsCreate(PD9,D1,"DocKim","ContenidoKim",PD10),paradigmaDocsLogin(PD10,"kim","4321",PD11),paradigmaDocsCreate(PD11,D1,"2DocKim2","2ContenidoKim2",PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsShare(PD13,2,["W","R","S"],["chuck","saul"],PD14),paradigmaDocsLogin(PD14,"chuck","qwerty",PD15),paradigmaDocsAdd(PD15,2,D3," Contenido Aniadido por Chuck",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsAdd(PD17,2,D3,"/Contenido Aniadido por Kim",PD18),paradigmaDocsLogin(PD18,"saul","1234",PD19),paradigmaDocsAdd(PD19,1,D3,"/Contenido Aniadido por Saul",PD20),paradigmaDocsLogin(PD20,"saul","1234",PD21),paradigmaDocsRestoreVersion(PD21,1,1,PD22),paradigmaDocsLogin(PD22,"kim","4321",PD23),paradigmaDocsShare(PD23,3,["W","R","S"],["chuck","saul"],PD24),paradigmaDocsLogin(PD24,"saul","1234",PD25),paradigmaDocsRevokeAllAccesses(PD25,[0],PD26)
*/
buscarPalabra(StringOriginal,StringBuscado):-
  sub_string(StringOriginal,_,_,_,StringBuscado),!.



