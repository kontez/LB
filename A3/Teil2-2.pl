% my_unify

% Term1 und Term2 sind Variablen
my_unify(Term1, Term2) :- var(Term1), var(Term2), Term1 = Term2.

% Term1 ist eine Variable und Term2 nicht
my_unify(Term1, Term2) :- var(Term1), nonvar(Term2), occurs_check(Term1, Term2), Term1 = Term2.

% Term1 ist keine Variable aber Term1 ja
my_unify(Term1, Term2) :- nonvar(Term1), var(Term2), occurs_check(Term2, Term1), Term2 = Term1.

% Keine Variable
my_unify(Term1, Term2) :- nonvar(Term1), nonvar(Term2),
                          Term1 =.. [TName1|TListe1],
                          Term2 =.. [TName2|TListe2],
                          TName1 == TName2, %Die Namen der Praedikate muessen gleich sein
                          %Im Algorithmus wird dies dargestellt als f=g
                          length(TListe1,Laenge1), length(TListe2,Laenge2),
                          Laenge1 == Laenge2, %Auch die Laenge der Praedikate muss gleich sein
                          %Im Algorithmus wird dies dargestellt als n=m
                          %Jetzt muessen wir die pruefen ob die Elemente der Listen unifizierbar
                          %sind, und rufen my_unify_list/2 auf.
                          my_unify_list(TListe1, TListe2).

%Dies brauchen wir um die zwei Listen von oben zu unifizieren.
my_unify_list([], []). %Ende der Rekursion, leere Listen.

%Die Listen rekursiv durchgehen und my_unify/2 aufrufen.
my_unify_list([Kopf1|Rest1], [Kopf2|Rest2]) :- my_unify(Kopf1, Kopf2), my_unify_list(Rest1, Rest2).

%%%%%%%%%%%%%%%%%

% occurs_check

% Falls t eine Variable, und t ungleich X
occurs_check(X, Term) :- var(Term), Term \== X.

% Falls Term keine Variable.
% Wir suchen in den Argumenten von Term, nach X
occurs_check(X, Term) :- nonvar(Term), Term =.. [_Kopf|Rest], occurs_check_list(X, Rest).

% X ist nicht in den Argumenten.
occurs_check_list(_, []).

% rekursives suchen nach X.
occurs_check_list(X, [Kopf|Rest]) :- occurs_check(X, Kopf), occurs_check_list(X, Rest).
