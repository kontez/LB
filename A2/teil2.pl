% var(A) ist true wenn A eine freie/ungebundene Variable ist. var(3) -> false, var(X) -> true, var(bla) -> false,
mnot(X) :- \+ var(X),X,!,fail.  %Prüft ob X belegt, ist X true, dann wird fail ausgegeben
mnot(X) :- \+ var(X).    %Prüft ob X belegt, true ist oben abgedegt, daher würde fail hier bearbeitet und er gibt true wieder,
mnot(X) :- var(X),fail. %Falls X unbelegt ist, wird fail ausgegeben

%Logisches UND
and(A,B) :- \+ var(A),\+ var(B),(A,B).  %Prüfen ob die beiden Variablen Belegt sind und dann der Und-Vergleich
and(A,B) :- (var(A);var(B)),fail.    %Prüfen ob einer der beiden Variabelen unbelegt sind, führt zum fail.
%Logisches ODER
or(A,B) :- \+ var(A),\+ var(B), (A;B).%Selbes Prinzip wie bei and/2
or(A,B) :- (var(A);var(B)),fail.
%Logisches auschließendes UND
nand(A,B) :- mnot(and(A,B)).   %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten and geschiet
%Logisches auschließendes ODER
nor(A,B) :- mnot(or(A,B)).     %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten or geschiet
%Implikation
impl(A,B) :- mnot(A);B.        %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten mnot geschiet
%Aquivalenz
aequiv(A,B) :- (mnot(A);B),(mnot(B);A).   %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten mnot geschiet
%Exclusives ODER
xor(A,B) :- mnot((mnot(A);B),(mnot(B);A)).     %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten mnot geschiet

bind(true).
bind(fail).

% Aufgabe 2.3 Wahrheitstafel mit zwei Variablen

tafel(A,B,Ausdruck) :- pprint(A,B,Ausdruck),
                       bind(A),bind(B),pprint(A,B),
                       do(Ausdruck),
                       fail.
tafel(_,_,_).

pprint(A,B,Ausdruck) :- write(A), tab(1), write(B), tab(1),
                        write('||'), tab(1), writeln(Ausdruck).
pprint(A,B) :- write(A), tab(1), write(B), tab(1), write('||'), tab(1).

do(Ausdruck) :- Ausdruck, !, writeln(true).
do(_Ausdruck) :- writeln(fail).


% Aufgabe 2.4 Wahrheitstafel mit drei Variablen

tafel3(A,B,C,Ausdruck) :- pprint3(A,B,C,Ausdruck),
                          bind(A),bind(B),bind(C),pprint3(A,B,C),
                          do(Ausdruck),
                          fail.
tafel3(_,_,_,_).

pprint3(A,B,C,Ausdruck):- write(A), tab(1), write(B), tab(1),  write(C), tab(1),
                           write('||'), tab(1), writeln(Ausdruck).
pprint3(A,B,C) :- write(A), tab(1), write(B), tab(1),  write(C), tab(1), write('||'), tab(1).



% Aufgabe 2.5 Wahrheitstafel mit n Variablen

tafeln(Variablen, Ausdruck) :- pprintn(Variablen, Ausdruck),
                               bindn(Variablen), pprintn(Variablen),
                               do(Ausdruck),
                               fail.
tafeln(_,_).

pprintn([A|Rest], Ausdruck) :- write(A), tab(1), pprintn(Rest, Ausdruck).
pprintn([], Ausdruck) :- write('||'), tab(1), writeln(Ausdruck).

pprintn([A|Rest]) :- write(A), tab(1), pprintn(Rest).
pprintn([]) :- tab(1), write('||'), tab(1).

bindn([A|Rest]) :- bind(A), bindn(Rest).
bindn([]).


% Aufgabe 2.7 Wahrheitstafel fuer 2.1

formelA :- tafel3(A,B,C, and(or(and(A, mnot(B)),and(mnot(A),B)), and(impl(C,B), impl(and(B,mnot(A)), mnot(C))))).

%formelA :- tafel3(A,B,C, and(and(or(A,B),or(mnot(A),(mnot(B)))),and(or(mnot(C),B),or(mnot(B),or(A,mnot(C)))))).

%f1 and(or(A,B),or(mnot(A),(mnot(B)))) ----  or(and(A, mnot(B)),and(mnot(A),B))
%f2 or(mnot(C),B)                      ----  impl(C,B)
%f3 or(mnot(B),or(A,mnot(C)))          ----  impl(and(B,mnot(A)), mnot(C))


%Aufgabe 2.8 testen auf aequivalenz zwischen (Negation von ((F1 und F2 und F3) impliziert F4)) und der KNF von 2.1

formelB :- tafel3(A,B,C, aequiv( mnot(impl(and(or(and(A, mnot(B)),and(mnot(A),B)), and(impl(C,B), impl(and(B,mnot(A)), mnot(C)))),mnot(C))),
                                 and(or(A,B),and(or(mnot(A),mnot(B)),and(or(mnot(C),B),and(or(mnot(B),or(A,mnot(C))),C)))))).


