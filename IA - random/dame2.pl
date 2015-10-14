%--INITIALISATION DES CASES JOUABLES--
damier(X,Y):- member(X,[1,3,5,7,9]),member(Y,[1,3,5,7,9]). %On ne joue que sur les cases noires du damier
damier(X,Y):- member(X,[2,4,6,8,10]),member(Y,[2,4,6,8,10]).
damierMilieu(X,Y):- member(X,[4,6,8]),member(Y,[4,6,8]).
damierMilieu(X,Y):- member(X,[3,5,7]),member(Y,[3,5,7]).
%coup noir coup blanc pour stopper
%attention la dame est bloquée par une diagonale de 2 noirs ou plus
%faire bouffer les dames blanches puis implémenter les dames pour les noirs
%attention, mettre une récursivité pour la dame elle doit verifier qu'elle ne peut pas bouffer plus de pions en plusieurs coups
% => est ce qu'on enregistre le nombre de possibilités ? ou trop dur ? -> pas pour l'instant


%--INITIALISATION DES PIONS--
:- dynamic(posBlanc/1).
:- dynamic(posNoir/1).
:- dynamic(posDameBlanc/1).
:- dynamic(posDameNoir/1).

%posBlanc([[1,1],[1,3],[3,1],[3,3],[5,1],[5,3],[7,1],[7,3],[9,1],[9,3],[2,2],[2,4],[4,2],[4,4],[6,2],[6,4],[8,2],[8,4],[10,2],[10,4]]).
%posNoir([[1,7],[1,9],[3,7],[3,9],[5,7],[5,9],[7,7],[7,9],[9,7],[9,9],[2,8],[2,10],[4,8],[4,10],[6,8],[6,10],[8,8],[8,10],[10,8],[10,10]]).
posBlanc([[3,9],[5,9]]).
%posNoir([[4,2]]). %,[7,7],[9,9]]).
posNoir([]).
posDameBlanc([[2,10],[4,10],[8,10]]).
posDameNoir([]).

dameBlanche(X,Y):- posDameBlanc(L),member([X,Y],L).
dameNoire(X,Y):- posDameNoir(L),member([X,Y],L).
pionBlanc(X,Y):- posBlanc(L),member([X,Y],L).
pionNoir(X,Y):- posNoir(L),member([X,Y],L).
caseBlanche(X,Y):- pionBlanc(X,Y); dameBlanche(X,Y). 	%Case occupée par un pion ou une dame blanc 
caseNoire(X,Y):- pionNoir(X,Y); dameNoire(X,Y). 		%Case occupée par un pion ou une dame noir
caseOccupee(X,Y):- pionBlanc(X,Y); pionNoir(X,Y); dameBlanche(X,Y); dameNoire(X,Y).

%clean(1):- retract(posBlanc(_)),retract(posNoir(_)),asserta(posNoir([[1,7],[1,9],[3,7],[3,9],[5,7],[5,9],[7,7],[7,9],[9,7],[9,9],[2,8],[2,10],[4,8],[4,10],[6,8],[6,10],[8,8],[8,10],[10,8],[10,10]])),asserta(posBlanc([[1,1],[1,3],[3,1],[3,3],[5,1],[5,3],[7,1],[7,3],[9,1],[9,3],[2,2],[2,4],[4,2],[4,4],[6,2],[6,4],[8,2],[8,4],[10,2],[10,4]])).

%--DEPLACEMENT ALEATOIRE--
randum(X):- X is random(3)-1.
randum(X):-randum(X),X\==0.

%--CALCUL DEPLACEMENT BLANC--
aleaBlanc(X2,Y2,X,Y,jeBouffeDame):- jeBouffeBlancDame(X2,Y2,X,Y),moveBlanc(X2,Y2,X,Y),!.
aleaBlanc(X2,Y2,X,Y,jeBouffe):- not(jeBouffeBlancDame(X2,Y2,X,Y)),aleaBlancBouffer(X2,Y2,X,Y),moveBlanc(X2,Y2,X,Y),!.
aleaBlanc(X2,Y2,X,Y,jeBouffePasDame):- not(aleaBlancBouffer(X2,Y2,X,Y)),aleaBlancPasBouffer(X2,Y2,X,Y),Y2 == 10,moveBlanc(X2,Y2,X,Y),!.
aleaBlanc(X2,Y2,X,Y,jeBouffePas):- not(aleaBlancBouffer(X2,Y2,X,Y)),aleaBlancPasBouffer(X2,Y2,X,Y),moveBlanc(X2,Y2,X,Y),!.

jeBouffeBlanc(X2,Y2,X,Y):-aleaBlancBouffer(X2,Y2,X,Y),!.
jeBouffeBlancDame(X2,Y2,X,Y):- Y2 is 10,aleaBlancBouffer(X2,Y2,X,Y),!.
jeBougeBlancDame(X2,Y2,X,Y) :- aleaBlancPasBouffer(X2,Y2,X,Y).

%--Dame
aleaBlancPasBouffer(X2,Y2,X,Y):- dameBlanche(X,Y),not(damierMilieu(X,Y)),member(Xi,[-8,-7,-6,-5,-4,-3]),(Xi = Yi),X2 is X + Xi, Y2 is Y + Yi,damierMilieu(X2,Y2),Xa is X-1,Ya is Y-1,between(X2,Xa,Xocc),between(Y2,Ya,Yocc),not(caseOccupee(Xocc,Yocc)),!.
aleaBlancPasBouffer(X2,Y2,X,Y):- dameBlanche(X,Y),not(damierMilieu(X,Y)),member(Xi,[-8,-7,-6,-5,-4,-3]),(Xi = -Yi),X2 is X + Xi, Y2 is Y + Yi,damierMilieu(X2,Y2),Xa is X-1,Ya is Y+1,between(X2,Xa,Xocc),between(Ya,Y2,Yocc),not(caseOccupee(Xocc,Yocc)),!.
aleaBlancPasBouffer(X2,Y2,X,Y):- dameBlanche(X,Y),not(damierMilieu(X,Y)),member(Xi,[3,4,5,6,7,8]),(Xi = -Yi),X2 is X + Xi, Y2 is Y + Yi,damierMilieu(X2,Y2),Xa is X+1,Ya is Y-1,between(Xa,X2,Xocc),between(Y2,Ya,Yocc),not(caseOccupee(Xocc,Yocc)),!.
aleaBlancPasBouffer(X2,Y2,X,Y):- dameBlanche(X,Y),not(damierMilieu(X,Y)),member(Xi,[3,4,5,6,7,8]),(Xi = Yi),X2 is X + Xi, Y2 is Y + Yi,damierMilieu(X2,Y2),Xa is X+1,Ya is Y+1,between(Xa,X2,Xocc),between(Ya,Y2,Yocc),not(caseOccupee(Xocc,Yocc)),!.

%aleaBlancBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,dameBlanche(X,Y),Xn is X + Xi, Yn is Y + 1,caseNoire(Xn,Yn),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.
%aleaBlancBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,dameBlanche(X,Y),Xn is X + Xi, Yn is Y + 1,caseNoire(Xn,Yn),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.
%aleaBlancBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,dameBlanche(X,Y),Xn is X + Xi, Yn is Y - 1,caseNoire(Xn,Yn),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.
%aleaBlancBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,dameBlanche(X,Y),Xn is X + Xi, Yn is Y - 1,caseNoire(Xn,Yn),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.

%--Pion
aleaBlancPasBouffer(X2,Y2,X,Y):- randum(Xi),pionBlanc(X,Y),Y2 is Y + 1,X2 is X + Xi,damier(X2,Y2),not(caseOccupee(X2,Y2)),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y + 1,caseNoire(Xn,Yn),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y + 1,caseNoire(Xn,Yn),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y - 1,caseNoire(Xn,Yn),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.
aleaBlancBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionBlanc(X,Y),Xn is X + Xi, Yn is Y - 1,caseNoire(Xn,Yn),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeNoir(Xn,Yn),!.



%--CALCUL DEPLACEMENT NOIR--
%aleaNoir(X2,Y2,X,Y,jeBouffe):- aleaNoirBouffer(X2,Y2,X,Y),moveNoir(X2,Y2,X,Y).
%aleaNoir(X2,Y2,X,Y,jeBouffePas):- not(aleaNoirBouffer(X2,Y2,X,Y)),aleaNoirPasBouffer(X2,Y2,X,Y),moveNoir(X2,Y2,X,Y),!.
aleaNoir(X2,Y2,X,Y,jeBouffeDame):- jeBouffeBlancNoir(X2,Y2,X,Y),moveNoir(X2,Y2,X,Y),!.
aleaNoir(X2,Y2,X,Y,jeBouffe):- not(jeBouffeBlancNoir(X2,Y2,X,Y)),aleaBlancBouffer(X2,Y2,X,Y),moveNoir(X2,Y2,X,Y),!.
aleaNoir(X2,Y2,X,Y,jeBouffePasDame):- not(aleaBlancBouffer(X2,Y2,X,Y)),aleaBlancPasBouffer(X2,Y2,X,Y),Y2 ==0,moveNoir(X2,Y2,X,Y),!.
aleaNoir(X2,Y2,X,Y,jeBouffePas):- not(aleaBlancBouffer(X2,Y2,X,Y)),aleaBlancPasBouffer(X2,Y2,X,Y),moveNoir(X2,Y2,X,Y),!.

jeBouffeNoir(X2,Y2,X,Y):-aleaNoirBouffer(X2,Y2,X,Y),!.
jeBouffeBlancNoir(X2,Y2,X,Y):- Y2 is 0,aleaNoirBouffer(X2,Y2,X,Y),!.
jeBougeBlancNoir(X2,Y2,X,Y) :- aleaNoirPasBouffer(X2,Y2,X,Y).

aleaNoirPasBouffer(X2,Y2,X,Y):- randum(Xi),pionNoir(X,Y),Y2 is Y - 1, X2 is X + Xi,damier(X2,Y2),not(caseOccupee(X2,Y2)),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y - 1,caseBlanche(Xb,Yb),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeBlanc(Xb,Yb),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y - 1,caseBlanche(Xb,Yb),Y2 is Y - 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeBlanc(Xb,Yb),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is 1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y + 1,caseBlanche(Xb,Yb),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeBlanc(Xb,Yb),!.
aleaNoirBouffer(X2,Y2,X,Y):- Xi is -1,Xi2 is Xi + Xi,pionNoir(X,Y),Xb is X + Xi, Yb is Y + 1,caseBlanche(Xb,Yb),Y2 is Y + 2,X2 is X + Xi2,damier(X2,Y2),not(caseOccupee(X2,Y2)),supprimeBlanc(Xb,Yb),!.

%--ACTION DEPLACEMENT--
moveNoir(X2,Y2,X,Y):- Y2\==0,pionNoir(X,Y),damier(X2,Y2),not(caseOccupee(X2,Y2)),posNoir(L),supprime([X,Y],L,R),ajoute([X2,Y2],R,R2),!,retract(posNoir(_)),asserta(posNoir(R2)).
moveNoir(X2,Y2,X,Y):- pionNoir(X,Y),damier(X2,Y2),not(caseOccupee(X2,Y2)),posNoir(L),supprime([X,Y],L,R),posDameNoir(L2),ajoute([X2,Y2],L2,R2),!,retract(posNoir(_)),asserta(posNoir(R)),retract(posDameNoir(_)),asserta(posDameNoir(R2)).
moveNoir(X2,Y2,X,Y):- dameNoire(X,Y),damier(X2,Y2),not(caseOccupee(X2,Y2)),posDameNoir(L),supprime([X,Y],L,R),ajoute([X2,Y2],R,R2),!,retract(posDameNoir(_)),asserta(posDameNoir(R2)).

moveBlanc(X2,Y2,X,Y):- Y2\==10,pionBlanc(X,Y),damier(X2,Y2),not(caseOccupee(X2,Y2)),posBlanc(L),supprime([X,Y],L,R),ajoute([X2,Y2],R,R2),!,retract(posBlanc(_)),asserta(posBlanc(R2)).
moveBlanc(X2,Y2,X,Y):-pionBlanc(X,Y),damier(X2,Y2),not(caseOccupee(X2,Y2)),posBlanc(L),supprime([X,Y],L,R),posDameBlanc(L2),ajoute([X2,Y2],L2,R2),!,retract(posBlanc(_)),asserta(posBlanc(R)),retract(posDameBlanc(_)),asserta(posDameBlanc(R2)).
moveBlanc(X2,Y2,X,Y):- dameBlanche(X,Y),damier(X2,Y2),not(caseOccupee(X2,Y2)),posDameBlanc(L),supprime([X,Y],L,R),ajoute([X2,Y2],R,R2),!,retract(posDameBlanc(_)),asserta(posDameBlanc(R2)).

%ajoutdameNoire(X,Y):-damier(X,Y),posNoir(L),
supprimeNoir(X,Y):-posNoir(L),supprime([X,Y],L,R),retract(posNoir(_)),asserta(posNoir(R)),!.
supprimeBlanc(X,Y):-posBlanc(L),supprime([X,Y],L,R),retract(posBlanc(_)),asserta(posBlanc(R)),!.
supprimeNoir(X,Y):-posDameNoir(L),supprime([X,Y],L,R),retract(posDameNoir(_)),asserta(posDameNoir(R)),!.
supprimeBlanc(X,Y):-posDameBlanc(L),supprime([X,Y],L,R),retract(posDameBlanc(_)),asserta(posDameBlanc(R)),!.
supprime(X,[X|Y],Y).
supprime(X,[Y|Z],[Y|K]):-supprime(X,Z,K).
ajoute(X,Y,[X|Y]).