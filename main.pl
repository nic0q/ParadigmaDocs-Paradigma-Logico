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
isDate(X):-
		getDay(X,D),
		getMonth(X,M),
		isDay(D), isMonth(M).

% Curiosamente el mismo metodo que estoy usando lo usa Elixir cuando algo es
% verdadero, devuelve la cosa en cuestion en vez de true o false
% Selectores
getDay([D,_,_],D).
getMonth([_,M,_],M).


paradigmaDocs(Name,Date,[Name,Date,[],[],[]]):-
	isDate(Date).

getRegistrados([_,_,X,_,_],X).
getLogeados([_,_,_,X,_],X).
getDocumentos([_,_,_,_,X],X).

paradigmaDocsRegister(_,Date,User,_,_):-
		isDate(Date),
		\+registradoAntes(User).

