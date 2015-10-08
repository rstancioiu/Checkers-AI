%--INITIALISATION DES CASES JOUABLES--
damier(X,Y):- member(X,[1,3,5,7,9]),member(Y,[1,3,5,7,9]). %On ne joue que sur les cases noires du damier
damier(X,Y):- member(X,[2,4,6,8,10]),member(Y,[2,4,6,8,10]).

%--INITIALISATION DES PIONS--
%pionBlanc(X,Y):- member(X,[1,3,5,7,9]),member(Y,[1,3]).
%pionBlanc(X,Y):- member(X,[2,4,6,8,10]),member(Y,[2,4]).
%pionNoir(X,Y):- member(X,[1,3,5,7,9]),member(Y,[7,9]).
%pionNoir(X,Y):- member(X,[2,4,6,8,10]),member(Y,[8,10]).
:- dynamic(posBlanc/1).
:- dynamic(posNoir/1).
posBlanc([[1,1],[1,3],[3,1],[3,3],[5,1],[5,3],[7,1],[7,3],[9,1],[9,3],[2,2],[2,4],[4,2],[4,4],[6,2],[6,4],[8,2],[8,4],[10,2],[10,4]]).
%posNoir([[1,7],[1,9],[3,7],[3,9],[5,7],[5,9],[7,7],[7,9],[9,7],[9,9],[2,8],[2,10],[4,8],[4,10],[6,8],[6,10],[8,8],[8,10],[10,8],[10,10]]).
posNoir([[5,5],[7,7],[9,7]]).
pionBlanc(X,Y):- posBlanc(L),member([X,Y],L).
pionNoir(X,Y):- posNoir(L),member([X,Y],L).
clean(1):- retract(posBlanc(_)),retract(posNoir(_)),asserta(posNoir([[1,7],[1,9],[3,7],[3,9],[5,7],[5,9],[7,7],[7,9],[9,7],[9,9],[2,8],[2,10],[4,8],[4,10],[6,8],[6,10],[8,8],[8,10],[10,8],[10,10]])),asserta(posBlanc([[1,1],[1,3],[3,1],[3,3],[5,1],[5,3],[7,1],[7,3],[9,1],[9,3],[2,2],[2,4],[4,2],[4,4],[6,2],[6,4],[8,2],[8,4],[10,2],[10,4]])).

%--DEPLACEMENT ALEATOIRE--
randum(X):- X is random(3)-1.
randum(X):-randum(X),X\==0.

%--Deplacement Blanc--
aleaBlanc(X2,Y2,X,Y,1):- aleaBlancBouffer(X2,Y2,X,Y),moveBlanc(X2,Y2,X,Y).
aleaBlanc(X3,Y3,X2,Y2,2):- aleaBlanc(X2,Y2,_,_,1),aleaBlancBouffer(X3,Y3,X2,Y2),moveBlanc(X3,Y3,X2,Y2).
aleaBlanc(X3,Y3,X2,Y2,3):- aleaBlanc(X2,Y2,_,_,2),aleaBlancBouffer(X3,Y3,X2,Y2),moveBlanc(X3,Y3,X2,Y2).
aleaBlanc(X2,Y2,X,Y,0):- not(aleaBlanc(X2,Y2,X,Y,I),I > 0,not(aleaBlancBouffer(X2,Y2,X,Y)),aleaBlancPasBouffer(X2,Y2,X,Y),moveBlanc(X2,Y2,X,Y),!.

aleaBlancPasBouffer(X2,Y2,X,Y):- randum(Xi),pionBlanc(X,Y),Y2 is Y + 1,X2 is X + Xi,damier(X2,Y2),not(pionBlanc(X2,Y2)),not(pionNoir(X2,Y2)),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y + 1,pionNoir(Xn,Yn),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(pionBlanc(X2,Y2)),not(pionNoir(X2,Y2)),supprimeNoir(Xn,Yn),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y + 1,pionNoir(Xn,Yn),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(pionBlanc(X2,Y2)),not(pionNoir(X2,Y2)),supprimeNoir(Xn,Yn),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y - 1,pionNoir(Xn,Yn),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(pionBlanc(X2,Y2)),not(pionNoir(X2,Y2)),supprimeNoir(Xn,Yn),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y - 1,pionNoir(Xn,Yn),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(pionBlanc(X2,Y2)),not(pionNoir(X2,Y2)),supprimeNoir(Xn,Yn),!.

%--Deplacement Noir--
%aleaNoir(X2,Y2,X,Y,jeBouffePas):- not(aleaNoirBouffer(X2,Y2,X,Y)),aleaNoirPasBouffer(X2,Y2,X,Y),moveNoir(X2,Y2,X,Y).
aleaNoir(X2,Y2,X,Y,jeBouffe):- aleaNoirBouffer(X2,Y2,X,Y),moveNoir(X2,Y2,X,Y).

aleaNoirPasBouffer(X2,Y2,X,Y):- randum(Xi),pionNoir(X,Y),Y2 is Y - 1, X2 is X + Xi,damier(X2,Y2),not(pionBlanc(X2,Y2)),not(pionNoir(X2,Y2)),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y - 1,pionBlanc(Xb,Yb),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(pionNoir(X2,Y2)),not(pionBlanc(X2,Y2)),supprimeBlanc(Xb,Yb),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y - 1,pionBlanc(Xb,Yb),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(pionNoir(X2,Y2)),not(pionBlanc(X2,Y2)),supprimeBlanc(Xb,Yb),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y + 1,pionBlanc(Xb,Yb),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(pionNoir(X2,Y2)),not(pionBlanc(X2,Y2)),supprimeBlanc(Xb,Yb),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y + 1,pionBlanc(Xb,Yb),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(pionNoir(X2,Y2)),not(pionBlanc(X2,Y2)),supprimeBlanc(Xb,Yb),!.

%--DEPLACEMENT D'UN PION--
moveNoir(X2,Y2,X,Y):- pionNoir(X,Y),damier(X2,Y2),not(pionNoir(X2,Y2)),posNoir(L),supprime([X,Y],L,R),ajoute([X2,Y2],R,R2),!,retract(posNoir(_)),asserta(posNoir(R2)).
moveBlanc(X2,Y2,X,Y):- pionBlanc(X,Y),damier(X2,Y2),not(pionBlanc(X2,Y2)),posBlanc(L),supprime([X,Y],L,R),ajoute([X2,Y2],R,R2),!,retract(posBlanc(_)),asserta(posBlanc(R2)).
supprimeNoir(X,Y):-posNoir(L),supprime([X,Y],L,R),retract(posNoir(_)),asserta(posNoir(R)),!.
supprimeBlanc(X,Y):-posBlanc(L),supprime([X,Y],L,R),retract(posBlanc(_)),asserta(posBlanc(R)),!.
supprime(X,[X|Y],Y).
supprime(X,[Y|Z],[Y|K]):-supprime(X,Z,K).
ajoute(X,Y,[X|Y]).

