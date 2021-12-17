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
paradigmaDocs(Name,Date,[Name,Date,[],[],[]]):-
  string(Name).      % nota: no es necesario verificar que es una fecha, pues el predicado del TDA fecha lo verifica antes de pasarlo

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

% SesionActiva: Predicado que verifica cuando un usuario tiene sesion activa en paradigmaDocs 
sesionActiva(Sn1):-       
  getLogeados(Sn1,Logeados),
  \+Logeados==[].

%  -------------------------------------------TDA DOC--------------------------------------------------
% Constructor de Documento
constDoc(Id,Autor,Shares,Historial,[[Id,Autor,Shares,Historial]]).
% Constructor de Historial (Version)
% Getters Documento:
getIdDoc([Id,_,_,_],Id).        % Id Documento
getAutorDoc([_,Autor,_,_],Autor).
getAccessesDoc([_,_,Shares,_],Shares).
getHistorialDoc([_,_,_,Historial],Historial).

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

revokeAccesses(Doc,[Id,Autor,[[Autor,["W","C","R"]]],Historial]):-
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getHistorialDoc(Doc,Historial).

% Obtiene los documentos por ID y además les revoca el acceso
revokeAllAccesses(_,[],[]):-!.
  revokeAllAccesses(Sn1,[H|T],[H1|T1]):-
  getDocumentById(Sn1,H,Doc),
  revokeAccesses(Doc,H1),
  revokeAllAccesses(Sn1,T,T1).

% Predicado que extrae los restantes de una lista
% Como funciona? Y por que no se usan la variable de retorno?
% Por que el retorno de esta variable se hará en el caso base
% por lo tanto durante el caso recurivo solo se juega con la lista pues esta será la entrada de la otra
getRestantesLista(Restantes,[],Restantes):-!.
getRestantesLista(Documentos,[H|T],X):-
getRestantes(H,Documentos,Actualizada),
getRestantesLista(Actualizada,T,X).

%  -------------------------------------------TDA VERSION---------------------------------------------------
constVersion(Idvr ,Fecha ,Nombre ,Contenido,NuevaVersion):-
  NewId is Idvr+1,
  NuevaVersion = [NewId ,Fecha ,Nombre ,Contenido].

getIdVersion([Version,_,_,_],Version).
getDateVersion([_,Date,_,_],Date).
getTituloVersion([_,_,Titulo,_],Titulo).
getContenidoVersion([_,_,_,Contenido],Contenido).

getVersionById(Historial,Id,Ver):-
  getIndexElement(Historial,Id,Index),
  nth0(Index,Historial,Ver).
  
noUnica([_|NotActive],NotActive).
% Recibe el historial de versiones
getActiveVersion([Active|_],Active):-!.
getNotActiveVersions(Historial,NotActive):-
  noUnica(Historial,NotActive).

aniadirActiveVersion(Historial, Version, NuevoHistorial):-
  getNotActiveVersions(Historial,NotActive),
  append([Version],[NotActive],NuevoHistorial).

%  -------------------------------------------TDA ACCESS---------------------------------------------------
% TODOS LOS ACCESOS SOLO DEBEN SER DE LA FORMA "R", "W", "C"
% Los accessos solo pueden ser "W", "R" o "C"
isAccess(Access):-
  myMember(Access,["W","R","C"]).

isAccessList([]):-!.
isAccessList([H|T]):-
  isAccess(H),
  isAccessList(T).

isEditor(Usuario,Accesses):-
  getPermisos(Usuario,Accesses,PermisosUsuario),
  myMember("W",PermisosUsuario).

% Predicado que crea los accessos del documento,  otorgando a cada usuario los
createAccesses(_,_,[],[]):-!.   % Base Case 1
createAccesses(Sn1,Permisos,[U1|T1],[[U1,Permisos]|TF]):-
  isAccessList(Permisos),
  registradoAntes(Sn1,U1),
  createAccesses(Sn1,Permisos,T1,TF).

getNombrePermiso([Nombre,_],Nombre).
getTipoPermiso([_,Permiso],Permiso).

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

%  -------------------------------------------OTROS PREDICADOS / HECHOS---------------------------------------------------
% AddHead:
% Añade elemento a la cabeza
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

%  -------------------------------------------MAIN---------------------------------------------------
% Metas Principales: Register, Login, Share, Add, RestoreVersion, Search
% Metas 
paradigmaDocsRegister(Sn1,Fecha,Username,Password,[Nombre,FechaCreacion,UpdateRegistrados,Logeados,Docs]):-
  string(Username),
  string(Password),
  \+registradoAntes(Sn1,Username),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  getRegistrados(Sn1,Registrados),
  append(Registrados,[[Username,Password,Fecha]],UpdateRegistrados).      % Retorna paradigmaDocs con la lista de registrados actualizada

paradigmaDocsLogin(Sn1,Username,Password,[Nombre,FechaCreacion,Registrados,UpdateLogeados,Docs]):-
  string(Username),
  string(Password),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getLogeados(Sn1,Logeados),
  Logeados == [], 
       
  getUserNames(Registrados,Usernames),
  getPasswords(Registrados,Passwords),

  indexOf(Usernames,Username,Index),
  nth0(Index,Passwords,Pass),
  Pass == Password,

  getDocumentos(Sn1,Docs),
  append(Logeados,[Username],UpdateLogeados). % Retorna paradigmaDocs con la lista de logeados actualizada

paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido, [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs]):-
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
  constDoc(Id,Autor,[[Autor,["W","C","R"]]],[Version],Doc),
  append(Docs,Doc,UpdateDocs).

paradigmaDocsShare(Sn1, DocumentId, ListaPermisos, ListaUsernamesPermitidos,[NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs]):-
  sesionActiva(Sn1),
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Logeado),
  getDocumentById(Sn1,DocumentId,Doc),
  getAutorDoc(Doc,Autor),  
  getAccessesDoc(Doc,OldAcceses),
  getHistorialDoc(Doc,Historial),
  Autor == Logeado,
  filtraAccesses(ListaUsernamesPermitidos,OldAcceses,FilteredAccesses),
  createAccesses(Sn1,ListaPermisos,ListaUsernamesPermitidos,Accesses),
  append(FilteredAccesses,Accesses,NewAccesses),

  constDoc(DocumentId,Autor,NewAccesses,Historial,NuevoDoc),
  getRestantes(DocumentId,Docs,Restantes),
  append(Restantes,NuevoDoc,UpdateDocs).

paradigmaDocsAdd(Sn1,DocumentId,Date,ContenidoTexto,[NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs]):-
  string(ContenidoTexto),
  sesionActiva(Sn1),
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),

  getLogeado(Sn1,Logeado),
  getDocumentById(Sn1,DocumentId,Doc),    % get the document
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getAccessesDoc(Doc,Accesses), % Se busca si el usuario esta en la lista de compartidos y tiene el permiso "Write"
  getHistorialDoc(Doc,Historial),
  \+Historial==[],
  isEditor(Logeado,Accesses),
  
  getActiveVersion(Historial,ActiveVersion),  % get Active version
  % Hay que verificar que el usuario no tenga ya permisos, si es asi, se filtra la lista y se le borra ese permiso, para agregarle el nuevo
  getIdVersion(ActiveVersion,IdVersion),
  getTituloVersion(ActiveVersion,TituloVersion),
  getContenidoVersion(ActiveVersion,ContenidoVersion),
  string_concat(ContenidoVersion, ContenidoTexto, NuevoContenido),
  constVersion(IdVersion,Date, TituloVersion, NuevoContenido, NuevaVersion),
  addHead(NuevaVersion,[ActiveVersion],NuevoHistorial),
  constDoc(Id,Autor,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  append(RestantesDoc,NuevoDoc,UpdateDocs).

paradigmaDocsRestoreVersion(Sn1,DocumentId,IdVersion,Sn2):-
  sesionActiva(Sn1),
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getLogeado(Sn1,Logeado),
  getDocumentos(Sn1,Docs),

  getDocumentById(Sn1,DocumentId,Doc),    % get the document
  getIdDoc(Doc,Id),
  getAutorDoc(Doc,Autor),
  getAccessesDoc(Doc,Accesses), % Se busca si el usuario esta en la lista de compartidos y tiene el permiso "Write"
  getHistorialDoc(Doc,Historial),

  Autor == Logeado,
  getVersionById(Historial,IdVersion,Restaurada),
  getRestantes(IdVersion,Historial,VerRestantes),
  addHead(Restaurada,VerRestantes,NuevoHistorial),
  constDoc(Id,Autor,Accesses,NuevoHistorial,NuevoDoc),
  getRestantes(DocumentId,Docs,RestantesDoc),
  append(RestantesDoc,NuevoDoc,UpdateDocs),
  Sn2 =[NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].

paradigmaDocsRevokeAllAccesses(Sn1,DocumentIds,Sn2):-
  sesionActiva(Sn1),
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  revokeAllAccesses(Sn1,DocumentIds,RevokedDocuments),
  getRestantesLista(Docs,DocumentIds,RestantesDoc),
  append(RestantesDoc,RevokedDocuments,UpdateDocs),
  Sn2 =[NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].
% paradigmaDocsToString(Sn1, StrOut):-

% todo se trata de caos base






%[[0, "chuck", [["chuck", ["W", "C", "R"]]], [[0, [21, 12, 2021], "Titulochuck", "Contenidochuck"]]], [1, "saul", [["saul", ["W", "C", "R"]]], [[0, [20, 12, 2020], "saulDoc", "saulContent"]]], [2, "kim", [["kim", ["W", "C", "R"]], ["chuck", ["W", "C"]], ["saul", ["W", "C"]]], [[0, [20, 12, 2020], "kimDoc", "kimContent"]]]]

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
% 1. El usuario "saul" se intenta logear con contraseña incorrecta, el predicado, retorna false:
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"saul","qwerty",PD5).
% 2. El usuario "chuck" ya se encuentra logeado, ahora el usuario "saul" desea logearse, pero no esta permitido, retorna false:
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsLogin(PD5, "saul","1234",PD6).
% 3. Se intenta logear un usuario, no registrado en paradigmaDocs, retorna false:
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
% ----------------------------------------------------------------------------- Add --------------------------------------------------------------------------------------------------
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"kim","4321",PD13),paradigmaDocsAdd(PD13,2,D1,"blabla",PD14).
% *************************************************************************** Excepciones(false) *************************************************************************************
% ADD AND SHARE
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"chuck","qwerty",PD13), paradigmaDocsAdd(PD13,2,D1,"blabla",PD14),paradigmaDocsLogin(PD14,"kim","4321",PD15), paradigmaDocsCreate(PD15,D1,"KIMDOC2","KimCOntent2",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsShare(PD17,3,["W","C"],["chuck","saul"],PD18),
% [["kim", ["W", "C", "R"]], ["chuck", ["W", "C"]], ["saul", ["W", "C"]]
% ----------------------------------------------------------------------------- Revoke All Accesses --------------------------------------------------------------------------------------------------
% date(20, 12, 2020, D1), date(21, 12, 2021, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "chuck", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"saul","1234",PD3), paradigmaDocsRegister(PD3,D1,"kim","4321",PD4), paradigmaDocsLogin(PD4,"chuck","qwerty",PD5),paradigmaDocsCreate(PD5,D2,"Titulochuck","Contenidochuck",PD6), paradigmaDocsLogin(PD6,"saul","1234",PD7), paradigmaDocsCreate(PD7,D1,"saulDoc","saulContent",PD8), paradigmaDocsLogin(PD8,"kim","4321",PD9), paradigmaDocsCreate(PD9,D1,"kimDoc","kimContent",PD10), paradigmaDocsLogin(PD10,"kim","4321",PD11), paradigmaDocsShare(PD11,2,["W","C"],["chuck","saul"],PD12),paradigmaDocsLogin(PD12,"chuck","qwerty",PD13), paradigmaDocsAdd(PD13,2,D1,"blabla",PD14),paradigmaDocsLogin(PD14,"kim","4321",PD15), paradigmaDocsCreate(PD15,D1,"KIMDOC2","KimCOntent2",PD16),paradigmaDocsLogin(PD16,"kim","4321",PD17),paradigmaDocsShare(PD17,3,["W","C"],["chuck","saul"],PD18),paradigmaDocsLogin(PD18,"kim","4321",PD19),paradigmaDocsRevokeAllAccesses(PD19,[3,2],PD20).  
