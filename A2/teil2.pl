% var(A) ist true wenn A eine freie/ungebundene Variable ist. var(3) -> false, var(X) -> true, var(bla) -> false,
mnot(X) :- \+ var(X),X,!,fail.  %Prüft ob X belegt, ist X true, dann wird fail ausgegeben
mnot(X) :- \+ var(X).    %Prüft ob X belegt, true ist oben abgedegt, daher würde fail hier bearbeitet und er gibt true wieder,
mnot(X) :- var(X),fail. %Falls X unbelegt ist, wird fail ausgegeben

%Logisches UND
and(A,B) :- \+ var(A),\+ var(B),(A,B).  %Prüfen ob die beiden Variablen Belegt sind und dann der Und-Vergleich
and(A,B) :- (var(A);var(B)),fail.    %Prüfen ob einer der beiden Variabelen unbelegt sind, führt zum fail.
%Logisches ODER
or(A,B) :- \+ var(A),\+ var(B), (A;B),!.%Selbes Prinzip wie bei and/2
or(A,B) :- (var(A);var(B)),fail.
%Logisches auschließendes UND
nand(A,B) :- mnot(and(A,B)).   %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten and geschiet
%Logisches auschließendes ODER
nor(A,B) :- mnot(or(A,B)).     %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten or geschiet
%Implikation
impl(A,B) :- or(mnot(A),B).
%Aquivalenz
aequiv(A,B) :- and(or(mnot(A),B),or(mnot(B),A)).   %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten mnot geschiet
%Exclusives ODER
xor(A,B) :- mnot(and(or(mnot(A),B),or(mnot(B),A))).     %Hier müssen die Variablen nicht auf belegung geprüft werden, da dies bei dem verwendeten mnot geschiet

bind(fail).
bind(true).


% Aufgabe 2.3 Wahrheitstafel mit zwei Variablen

tafel(A,B,Ausdruck) :- pprint(A,B,Ausdruck),                   %Gibt die Tafel aus, wie in der Vorlesung gezeigt.
                       bind(A),bind(B),pprint(A,B),
                       do(Ausdruck),
                       fail.
tafel(_,_,_).                                                   %Damit die Tafel nicht fehlschlägt

pprint(A,B,Ausdruck) :- write(A), tab(1), write(B), tab(1),     %Für die Ausgabe zuständig
                        write('||'), tab(1), writeln(Ausdruck).
pprint(A,B) :- write(A), tab(1), write(B), tab(1), write('||'), tab(1).

do(Ausdruck) :- Ausdruck, !, writeln(true).                     %Ausführen des Ausdrucks
do(_Ausdruck) :- writeln(fail).


% Aufgabe 2.4 Wahrheitstafel mit drei Variablen

tafel3(A,B,C,Ausdruck) :- pprint3(A,B,C,Ausdruck),                    %Gibt die Tafel mit drei Variablen aus
                          bind(A),bind(B),bind(C),pprint3(A,B,C),
                          do(Ausdruck),
                          fail.
tafel3(_,_,_,_).

pprint3(A,B,C,Ausdruck):- write(A), tab(1), write(B), tab(1),  write(C), tab(1),      %Das prädikat was wir brauchen um 3 Variablen auszugeben.
                           write('||'), tab(1), writeln(Ausdruck).
pprint3(A,B,C) :- write(A), tab(1), write(B), tab(1),  write(C), tab(1), write('||'), tab(1).



% Aufgabe 2.5 Wahrheitstafel mit n Variablen

tafeln(Variablen, Ausdruck) :- pprintn(Variablen, Ausdruck),                        %Gibt eien Tafel mit n-Variabeln aus.
                               bindn(Variablen), pprintn(Variablen),
                               do(Ausdruck),
                               fail.
tafeln(_,_).

pprintn([A|Rest], Ausdruck) :- write(A), tab(1), pprintn(Rest, Ausdruck).            %Für den Ausdruck der n-Variablen. Rekursives aufrufen durch die Liste der Variablen
pprintn([], Ausdruck) :- write('||'), tab(1), writeln(Ausdruck).

pprintn([A|Rest]) :- write(A), tab(1), pprintn(Rest).
pprintn([]) :- tab(1), write('||'), tab(1).

bindn([A|Rest]) :- bind(A), bindn(Rest).                                            %Brauchen wir um n-Variablen zu Binden.
bindn([]).


% Aufgabe 2.7 Wahrheitstafel fuer 2.1

%formelA :- tafel3(A,B,C, and(or(and(A, mnot(B)),and(mnot(A),B)), and(impl(C,B), impl(and(B,mnot(A)), mnot(C))))).     %Fehler in Formel f1 gefunden. Hatten A xor B, dabei ist es !(A u. B), da auch keines entfernt werden kann.
formelA :-  tafel3(A,B,C, and(mnot(and(A, B)), and(impl(C,B), impl(and(B,mnot(A)), mnot(C))))).                        %Daher folgende Formel im Programm (!(A u. B) u. (C impl. B) u. ((B u. !A) impl. !C))


%Aufgabe 2.8 testen auf aequivalenz zwischen (Negation von ((F1 und F2 und F3) impliziert F4)) und der KNF von 2.1
formelB :- tafel3(A,B,C, aequiv( mnot(impl(and(mnot(and(A,B)), and(impl(C,B), impl(and(B,mnot(A)), mnot(C)))),mnot(C))),
                                 and(or(A,B),and(or(mnot(A),mnot(B)),and(or(mnot(C),B),and(or(mnot(B),or(A,mnot(C))),C)))))).


%Testaufgabe aus dem Praktikum
inhiPost(A,B) :- and(A,mnot(B)).      %Keine Variablenprüfung notwendig, da dies in and/mnot durchgeführt wird.


inhiPrae(A,B) :-  \+ var(A), \+ var(B), A, !, fail. %Wenn A true ist, kommt es hier zu einem Fehlschlag durch fail, wenn A false ist dann geht er gleich in den nächsten Zweig.
inhiPrae(A,B) :-  \+ var(A), \+ var(B), B.          %Wenn B wahr ist und er oben nicht failt, gibt er true im allgemein aus, weil !False u. True = True. Wenn B fehlschlägt ist es generell fail.
%inhiPrae(A,B) :- (var(A);var(B)),fail.        %Durch die var prüfung davor kann dies weggelassen werden, da es Automatisch fehlschlägt, wenn die nicht Belegt sind.
