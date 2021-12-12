%paradigmaDocsRegister(Sn1, Fecha, Username, Password, Sn2).
% Funcion Register:
% Predicado
% paradigmaDocsRegister(Sn1, Fecha, Username, Password, Sn2):-
%   registradoAntes?(Username,Password),
%   fechaValida(Fecha),
%   registrar(Username,Password,Fecha)
% date(Day,Month,Year,[Day,Month,Year]):-
%
% TDA DATE
% Constructor
% date: Funcion que comprueba que una fecha es correcta
% Dominio: Lista [Day, Month, Year]
% Recorrido: Lista

% De Pertenencia

isDay(Day):-
	(Day > 0),(Day < 32).
isMonth(Month):-
	(Month > 0),(Month < 13).
isYear(Year):-
  (Year > 0).
isDate(Date):-
		getDay(Date,D),
		getMonth(Date,M),
    getYear(Date,Y),
		isDay(D), isMonth(M), isYear(Y).

% Selectores
getDay([D,_,_],D).
getMonth([_,M,_],M).
getYear([_,_,Y],Y).

% TDA ParadigmaDocs
% Constructor Paradigmadocs
% Representacion: NombrePlataforma X Fecha X ListaRegistrados X ListaLogeados X ListaDocumentos[Lista Historial]


constPdocs(Name,Date,Registrados,Logeados,Documentos,[Name,Date,Registrados,Logeados,Documentos]):-
  isDate(Date).

paradigmaDocs(Name,Date,SOut):-
  isDate(Date),
  constPdocs(Name,Date,[],[],[[]],SOut).
	

% Lista de Registrados
% getRegistrados: Funcion que obtiene la lista de registrados de paradigmadocs
getNombrePDocs([Nombre,_,_,_,_],Nombre).
getFechaCreacionPdocs([_,Fecha,_,_,_],Fecha).
getRegistrados([_,_,ListaReg,_,_],ListaReg).
getLogeados([_,_,_,ListaLog,_],ListaLog).
getDocumentos([_,_,_,_,ListaDocs],ListaDocs).
% TDA USUARIO
% Getters and Setters user

getUser([User,_,_],User).
getPass([_,Pass,_],Pass).
getFechaCreacionUser([_,_,DateC],DateC). % GetDateCreation

getUserNames([],[]).

getUserNames([H|T],[H1|T1]):-
  getUser(H,H1),
  getUserNames(T,T1).
  
% Registrado Antes

registradoAntes(ParadigmaDocs,User):-
  getRegistrados(ParadigmaDocs,ListaRegistrados),
  getUserNames(ListaRegistrados,Usernames),
  member(User,Usernames).
% [User,Pass,Fecha]

paradigmaDocsRegister(Sn1,Fecha,Username,Password,Sn2):-
  \+registradoAntes(Sn1,Username),
  isDate(Fecha),
  getNombrePDocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  getRegistrados(Sn1,Registrados),
  append(Registrados,[Username,Password,Fecha],UpdateRegistrados), % El problema del |... es por el append, quiza sea una buena idea cambiar por aniadir al final
  constPdocs(Nombre,FechaCreacion,UpdateRegistrados,Logeados,Docs,Sn2).

paradigmaDocsLogin(Sn1,Username,Sn2):-
  registradoAntes(Sn1,Username),
  getNombrePDocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getLogeados(Sn1,Logeados),
  % Hacer predicado para que busque la contraseña coincide contraseña
  getDocumentos(Sn1,Docs),
  append(Logeados,[Username],UpdateLogeados), 
  constPdocs(Nombre,FechaCreacion,Registrados,UpdateLogeados,Docs,Sn2).

logeado(Sn1,User):-
  getLogeados(Sn1,Logeados),
  member(User,Logeados).

% ESte predicado se usara en todas las funciones para comprobar que el usuario tenga sesion activa
crearDocumento(Fecha, Nombre, Contenido, Id, [Id, Fecha, Nombre, Contenido]).

getId(Sn1,Id):-
  getDocumentos(Sn1,Docs),
  length(Docs,Idd),
  Id is Idd + 1.
% Predicado que elimina la sesion activa de un usuario
deslogear(Sn1,Sn2):-
  getNombrePDocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  constPdocs(Nombre,FechaCreacion,Registrados,[],Docs,Sn2).

  %  Agregar al para saver si se arreglar las palabras esas
insertarAlFinal( Elemento, [], [Elemento] ).
insertarAlFinal( Elemento, [Cabeza|Resto], [Cabeza|Lista] ) :-
        insertarAlFinal( Elemento, Resto, Lista ).
         
paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido, Sn2):-
  logeado(Sn1,Nombre),
  getNombrePDocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  getId(Sn1,Id),
  crearDocumento(Fecha, Nombre, Contenido, Id, Doc),
  append(Docs,[Doc],UpdateDocs),
  constPdocs(NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs,Sn2).

