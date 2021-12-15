%  -------------------------------------------TDA DATE--------------------------------------------------
% Hechos:
mes(1,31).
mes(2,28).
mes(2,29).
mes(3,31).
mes(4,30).
mes(5,31).
mes(6,30).
mes(7,31).
mes(8,31).
mes(9,30).
mes(10,31).
mes(11,30).
mes(12,31).
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

paradigmaDocs(Name,Date,SOut):-
  string(Name),
  SOut = [Name,Date,[],[],[]].
  
% Predicado usado para construir la version anterior (Sn1) de paradigmadocs
constPdocs(Name,Date,Registrados,Logeados,Documentos,[Name,Date,Registrados,Logeados,Documentos]).

% Getters ParadigmaDocs
getNombrePdocs([Nombre,_,_,_,_],Nombre).
getFechaCreacionPdocs([_,Fecha,_,_,_],Fecha).
getRegistrados([_,_,ListaReg,_,_],ListaReg).
getLogeados([_,_,_,ListaLog,_],ListaLog).
getDocumentos([_,_,_,_,ListaDocs],ListaDocs).

%  -------------------------------------------TDA USER-------------------------------------------------
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
  getLogeados(Sn1,Logeados),
  \+vacia(Logeados,[]),
  head(Logeados,Logeado).

getRegisterUsers(Sn1,Users):-
  getRegistrados(Sn1,Registrados),
  getUserNames(Registrados,Users).

% Registrado Antes: Predicado que determina si un usuario se ha registrado antes
registradoAntes(ParadigmaDocs,User):-
  string(User),
  getRegistrados(ParadigmaDocs,ListaRegistrados),
  getUserNames(ListaRegistrados,Usernames),
  \+member(User,Usernames).

% SesionActiva: Predicado que verifica cuando un usuario tiene sesion activa en paradigmaDocs 
sesionActiva(Sn1):-       
  getLogeados(Sn1,Logeados),
  \+vacia(Logeados,[]).

%  -------------------------------------------TDA DOC--------------------------------------------------
% Constructor de Documento
constDoc(Id,Autor,Shares,Historial,[[Id,Autor,Shares,Historial]]).
% Constructor de Historial (Version)
% Getters Documento:
getIdDoc([Id,_,_,_],Id).        % Id Documento
getAutorDoc([_,Autor,_,_],Autor).
getAccessesDoc([_,_,Shares,_],Shares).
getHistorialDoc([_,_,_,Historial],Historial).

% SetId: Genera Id
setId(Sn1,Id):-
  getDocumentos(Sn1,Docs),
  length(Docs,Idd),
  Id is Idd.

getIndexDocument([[Id|_]|_], Id, 0). % we've found the element
getIndexDocument([_|Tail], Id, Index):- % we've found the element
  getIndexDocument(Tail, Id, Index1),
  Index is Index1+1.

getDocumentById(Sn1,Id,Docu):-
  getDocumentos(Sn1,Docs),
  getIndexDocument(Docs,Id,Index),
  nth0(Index,Docs,Docu).

constLista(H,H).

% FilterRestantes
getRestantes(Id,[[Id|_]|E],E):-!.
getRestantes(_,[],[]).
getRestantes(Id,[H|T],[H1|T1]):- 
  constLista(H,H1),
  getRestantes(Id,T,T1).
%  -------------------------------------------TDA VERSION---------------------------------------------------
%  Constructor

constVersion(Idvr ,Fecha ,Nombre ,Contenido,NuevaVersion):-
  NewId is Idvr+1,
  NuevaVersion = [NewId ,Fecha ,Nombre ,Contenido].

getIdVersion([Version,_,_,_],Version).
getDateVersion([_,Date,_,_],Date).
getTituloVersion([_,_,Titulo,_],Titulo).
getContenidoVersion([_,_,_,Contenido],Contenido).

unica([Active],Active).
noUnica([_|NotActive],NotActive).
% Recibe el historial de versiones
getActiveVersion([Active|_],Active).
getNotActiveVersions(Historial,NotActive):-
  unica(Historial,NotActive);
  noUnica(Historial,NotActive).

aniadirActiveVersion(Historial, Version, NuevoHistorial):-
  getNotActiveVersions(Historial,NotActive),
  append([Version],[NotActive],NuevoHistorial).

%  -------------------------------------------TDA ACCESS---------------------------------------------------
% TODOS LOS ACCESOS SOLO DEBEN SER DE LA FORMA "R", "W", "C"
isAccess(Access):-
  member(Access,["W","R","C"]),!.
% preguntar por que no me funciona
isAccessList([]):-!.
isAccessList([H|T]):-
  isAccess(H),
  isAccessList(T).

makeAccess(P,U1,[U1,P]).
% Predicado que crea los accessos del documento,  otorgando a cada usuario los
createAccesses(_,_,[],[]).
createAccesses(Sn1,Permisos,[U1|T1],[UF|TF]):-
  isAccessList(Permisos),
  getRegisterUsers(Sn1,Registrados),
  member(U1,Registrados),
  makeAccess(Permisos,U1,UF),
  createAccesses(_,Permisos,T1,TF).

% Predicado que retorna si un usuario tiene permiso para escribir en tal documento

% FilterRestantes

% isEditor(Sn1,Id,User):-
%   getDocumentById(Id,Doc),
%   getAccessesDoc(Doc,Accesses),

%   getAutorDoc(Sn1,Autor)

buscarPermiso(User,User,foundem):-!.
buscarPermiso(_,[],[]).
buscarPermiso(Usuario,[H|T],[H1|T1]):-
  constLista(H,H1),
  buscarPermiso(Usuario,T,T1).

% Otros Hechos
equal(X,X).
head([H|_],H).
vacia([],[]).

% Otros Predicados
indexOf([Element|_], Element, 0). % We found the element
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1), % Check in the tail of the list
  Index is Index1+1.              % and increment the resulting index

%  -------------------------------------------MAIN---------------------------------------------------
% Metas Principales: Register, Login, Share, Add, RestoreVersion, Search
% Metas 
paradigmaDocsRegister(Sn1,Fecha,Username,Password,Sn2):-
  string(Username),
  string(Password),
  registradoAntes(Sn1,Username),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  getRegistrados(Sn1,Registrados),
  append(Registrados,[[Username,Password,Fecha]],UpdateRegistrados), 
  Sn2 = [Nombre,FechaCreacion,UpdateRegistrados,Logeados,Docs].      % Retorna paradigmaDocs con la lista de registrados actualizada

paradigmaDocsLogin(Sn1,Username,Password,Sn2):-
  string(Username),
  string(Password),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getLogeados(Sn1,Logeados),
  
  vacia(Logeados,[]),     % Si la lista de logeados esta vacía se permite que un usuario inicie sesión
  getUserNames(Registrados,Usernames),
  getPasswords(Registrados,Passwords),

  indexOf(Usernames,Username,Index),
  nth0(Index,Passwords,Pass),
  equal(Pass,Password),

  getDocumentos(Sn1,Docs),
  append(Logeados,[Username],UpdateLogeados),
  Sn2 = [Nombre,FechaCreacion,Registrados,UpdateLogeados,Docs]. % Retorna paradigmaDocs con la lista de logeados actualizada

paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido, Sn2):-
  string(Nombre),
  string(Contenido),
  sesionActiva(Sn1),    % Si existe sesion activa se saca al usuario
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Autor),
  setId(Sn1,Id),
  
  constVersion(-1,Fecha, Nombre, Contenido,Version),
  constDoc(Id,Autor,[],[Version],Doc),
  append(Docs,Doc,UpdateDocs),
  Sn2 = [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].  % Retorna paradigmaDocs sin el usuario logeado

% Condiciones de uso:
% Todos los usuarios que se ingresen en ListaUsernamesPermitidos, deben estar previamente logeados.
% El autor del documento obtenido por "DocumentId", debe ser el mismo que se encuentra logeado en paradigmaDocs

paradigmaDocsShare(Sn1, DocumentId, ListaPermisos, ListaUsernamesPermitidos, Sn2):-
  sesionActiva(Sn1),
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Logeado),

  getDocumentById(Sn1,DocumentId,Doc),
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getAccessesDoc(Doc,OldAcceses),
  getHistorialDoc(Doc,Historial),

  createAccesses(Sn1,ListaPermisos,ListaUsernamesPermitidos, NewAccesses),
  append(OldAcceses,NewAccesses,UpdateAccesses),
    
  equal(Logeado,Autor),
  constDoc(Id,Autor,UpdateAccesses,Historial,NuevoDoc),
  getRestantes(DocumentId,Docs,Restantes),
  append(Restantes,NuevoDoc,UpdateDocs),
  Sn2 = [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].

% Excepciones: Cuando el autor puede entregarse permisos a si mismo

paradigmaDocsAdd( Sn1, DocumentId, Date ,ContenidoTexto, Sn2):-
  string(ContenidoTexto),
  sesionActiva(Sn1),
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Logeado),
  % Se extrae los datos originales del documento
  getDocumentById(Sn1,DocumentId,Doc),    % get the document
  
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getAccessesDoc(Doc,Accesses), % Se busca si el usuario esta en la lista de compartidos y tiene el permiso "Write"
  
  getHistorialDoc(Doc,Historial),
  \+vacia(Historial,[]),  % Si el historial no esta vacio
  equal(Logeado, Autor),  % Si el autor es el que agrega

  % Se extraen los datos de la version activa
  getActiveVersion(Historial,ActiveVersion),  % get Active version
  % Hay que verificar que el usuario no tenga ya permisos, si es asi, se filtra la lista y se le borra ese permiso, para agregarle el nuevo

  getIdVersion(ActiveVersion,IdVersion),
  getTituloVersion(ActiveVersion,TituloVersion),
  getContenidoVersion(ActiveVersion,ContenidoVersion),
  string_concat(ContenidoVersion, ContenidoTexto, NuevoContenido),
  constVersion(IdVersion,Date, TituloVersion, NuevoContenido, NuevaVersion),
  aniadirActiveVersion(Historial, NuevaVersion, NuevoHistorial),
  constDoc(Id,Autor,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,Restantes),
  append(Restantes,NuevoDoc,UpdateDocs),
  Sn2 = [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].

%paradigmaDocsRestoreVersion(Sn1, documentId, idVersion, Sn2):-

% EJEMPLOS:

% Register:
% 1. Se logea un usuario comun, no existe un username igual:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2).
% 2. Se intenta logear un usuario con el mismo "username", el predicado retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"nico","1234",PD3).
% 3. Se intenta logear un usuario con un "username" distinto, se permite el registro:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3).
% 4. Se registran 3 usuarios unicos
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsRegister(PD3,D1,"marco","4321",PD4).

% Login
% 1. Se logea un usuario existente con credenciales correctas:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsRegister(PD3,D1,"marco","4321",PD4), paradigmaDocsLogin(PD4,"nico","qwerty",PD5).
% 2. El usuario "robert" se intenta logear con contraseña incorrecta, el predicado, retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsRegister(PD3,D1,"marco","4321",PD4), paradigmaDocsLogin(PD4,"robert","qwerty",PD5).
% 3. El usuario "nico" ya se encuentra logeado, ahora el usuario "robert" desea logearse, pero no esta permitido, retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsRegister(PD3,D1,"marco","4321",PD4), paradigmaDocsLogin(PD4,"nico","qwerty",PD5),paradigmaDocsLogin(PD5, "robert","1234",PD6).
% 4. Se intenta logear un usuario, no registrado en paradigmaDocs, retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsRegister(PD3,D1,"marco","4321",PD4), paradigmaDocsLogin(PD4,"JuanJose","qwerty",PD5).

% Create
% 1. El usuario "nico" autenticado, crea un documento en paradigmaDocs id1:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsRegister(PD3,D1,"marco","4321",PD4), paradigmaDocsLogin(PD4,"nico","qwerty",PD5), paradigmaDocsCreate(PD5,D2,"DocNico","NicoContent",PD6)
% 2. 

% Share
% 1. El usuario robert se logea y posterior a esto, aplica "Share" al documento de ID=1 el cual es dueño, y otorga los permisos de "W" "C" al usuario "nico"
%   
% 2. Se le asigna accesos a 2 usuarios
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsLogin(PD3,"nico","qwerty",PD4),paradigmaDocsCreate(PD4,D2,"mi CV","lorem ipsum",PD5), paradigmaDocsLogin(PD5,"robert","1234",PD6),paradigmaDocsCreate(PD6,D2,"DocRobert","Contenido",PD7),paradigmaDocsLogin(PD7,"robert","1234",PD8),paradigmaDocsShare(PD8,1,["W","C"],["nico"],PD9),paradigmaDocsLogin(PD9,"robert","1234",PD10),paradigmaDocsShare(PD10,1,["W","C","R"],["nico"],PD11).   

% Add
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsLogin(PD3,"nico","qwerty",PD4),paradigmaDocsCreate(PD4,D2,"mi CV","lorem ipsum",PD5), paradigmaDocsLogin(PD5,"robert","1234",PD6),paradigmaDocsCreate(PD6,D2,"DocRobert","Contenido",PD7),paradigmaDocsLogin(PD7,"robert","1234",PD8),paradigmaDocsShare(PD8,1,["W","C"],["nico"],PD9),paradigmaDocsLogin(PD9,"robert","1234",PD10),paradigmaDocsShare(PD10,1,["W","C","R"],["nico"],PD11),paradigmaDocsLogin(PD11,"nico","qwerty",PD12),paradigmaDocsAdd(PD12,0,D1,"hola",PD13).
