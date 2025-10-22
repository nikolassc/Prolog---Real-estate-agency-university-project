% ΙΩΑΝΝΗΣ ΔΙΓΚΑΣ
% ΑΕΜ: 4368

% ΝΙΚΟΛΑΣ ΣΠΥΡΟΣ ΧΡΙΣΤΟΦΟΡΟΥ
% ΑΕΜ: 4479

%ΝΙΚΗΦΟΡΟΣ ΚΛΙΑΦΑΣ
% ΑΕΜ: 4487

:- set_prolog_flag(encoding, utf8).
:- set_prolog_flag(double_quotes, string).

:- consult('houses.pl').
:- consult('requests.pl').


% run/0
% Ξεκινά την εφαρμογή. Απλά καλεί το menu/0.

run :- menu.

% menu/0
% Εμφανίζει το κύριο μενού επιλογών για τον χρήστη και ζητάει την είσοδο του.
% Επιτρέπει στον χρήστη να επιλέξει μεταξύ:
%   1. Διαδραστική λειτουργία (option1/0)
%   2. Μαζικές προτιμήσεις πελατών (option2/0)
%   3. Δημοπρασία πελατών (option3/0)
%   0. Έξοδος από την εφαρμογή
% Μετά την εκτέλεση της επιλογής, επαναλαμβάνει το μενού μέχρι να δοθεί 0.

menu :-
    writeln("\nΜενού:"),
    writeln("======"),
    writeln("1 - Προτιμήσεις ενός Πελάτη"),
    writeln("2 - Μαζικές Προτιμήσεις Πελατών"),
    writeln("3 - Επιλογή Πελατών Μέσω Δημοπρασίας"),
    writeln("0 - Έξοδος"),
    write("Επιλογή: "),
    read(Choice),
    choice_handler(Choice),
    Choice \= 0,
    menu.


% choice_handler(Choice)
% Εκτελεί τη λειτουργία που αντιστοιχεί στην επιλογή του χρήστη.
% Παίρνει ως όρισμα το Choice (αριθμός από 0 έως 3) και καλεί το αντίστοιχο κατηγόρημα.
% Αν ο αριθμός δεν είναι έγκυρος, εμφανίζει μήνυμα λάθους.

choice_handler(1):- option1, !.
choice_handler(2):- option2, !.
choice_handler(3):- option3, !, true.
choice_handler(0):- writeln("Έξοδος από την εφαρμογή :/"),nl, !.
choice_handler(_):- writeln("Επίλεξε έναν αριθμό μεταξύ 0 έως 3!"), !.


% === Επιλογή 1: Διαδραστική λειτουργία ===

% option1/0
% Ζητάει διαδραστικά από τον χρήστη τα κριτήρια για ένα σπίτι (π.χ. εμβαδόν, δωμάτια, κατοικίδια).
% Αναζητά τα σπίτια που πληρούν τα κριτήρια αυτά (find_compatible_houses/2) και εμφανίζει τα αποτελέσματα.

option1 :-
    writeln("\nΔώσε τις παρακάτω πληροφορίες:"),
    writeln("================================"),
    write("Ελάχιστο Εμβαδόν: "), read(MinArea),
    write("Ελάχιστος Αριθμός Υπνοδωματίων: "), read(MinRooms),
    write("Να επιτρέπονται κατοικίδια; (yes/no): "), read(Pets),
    write("Από ποιον όροφο και πάνω να υπάρχει ανελκυστήρας; "), read(ElevatorLimit),
    write("Ποιο είναι το μέγιστο ενοίκιο που μπορείς να πληρώσεις; "), read(MaxTotal),
    write("Πόσα θα έδινες για ένα διαμέρισμα στο κέντρο της πόλης (στα ελάχιστα τετραγωνικά);  "), read(MaxCenter),
    write("Πόσα θα έδινες για ένα διαμέρισμα στα προάστια της πόλης (στα ελάχιστα τετραγωνικά); "), read(MaxSuburb),
    write("Πόσα θα έδινες για κάθε τετραγωνικό διαμερίσματος πάνω από το ελάχιστο; "), read(ExtraPerM2),
    write("Πόσα θα έδινες για κάθε τετραγωνικό κήπου; "), read(ExtraPerGarden),

    Requirements = [MinArea, MinRooms, Pets, ElevatorLimit,
                    MaxTotal, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden],

    find_compatible_houses(Requirements, CompatibleHouses),
    show_results(Requirements, CompatibleHouses).

% === Εκτύπωση αποτελεσμάτων ===
show_results(_, []) :-
    writeln("\nΔεν υπάρχουν κατάλληλα σπίτια!!").

show_results(Requirements, CompatibleHouses) :-
    print_houses(CompatibleHouses),
    find_best_house(Requirements, CompatibleHouses, house(Address, _, _, _, _, _, _, _, _)),
    format("\nΠροτείνεται η ενοικίαση του διαμερίσματος στην διεύθυνση: ~w\n", [Address]).

% find_compatible_houses(Requirements, CompatibleHouses)
% Δέχεται ως είσοδο μια λίστα με τα Requirements του πελάτη:
% [MinArea, MinRooms, Pets, ElevatorLimit, MaxTotal, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden]
% και επιστρέφει τη λίστα CompatibleHouses με όλα τα σπίτια που πληρούν αυτά τα κριτήρια.
% Κάνει χρήση του compatible_house/2 για τον έλεγχο κάθε σπιτιού.

find_compatible_houses(Requirements, CompatibleHouses) :-
    findall(
        house(Address, Rooms, Area, Center, Floor, Elevator, Pets, Garden, Rent),
        (
            house(Address, Rooms, Area, Center, Floor, Elevator, Pets, Garden, Rent),
            compatible_house(Requirements, house(Address, Rooms, Area, Center, Floor, Elevator, Pets, Garden, Rent))
        ),
        CompatibleHouses
    ).

% compatible_house(Requirements, House)
% Ελέγχει αν ένα σπίτι πληροί όλα τα κριτήρια του πελάτη.
% - Requirements: Λίστα με τα κριτήρια πελάτη όπως στο find_compatible_houses/2.
% - House: Δομή house(Address, Rooms, Area, Center, Floor, Elevator, Pets, Garden, Rent).
% Επιστρέφει true αν το σπίτι πληροί:
%   - Ελάχιστο εμβαδόν
%   - Ελάχιστο αριθμό δωματίων
%   - Επιτρεπτά κατοικίδια
%   - Απαιτήσεις ανελκυστήρα (αν χρειάζεται)
%   - Το ενοίκιο δεν ξεπερνάει την προσφορά που είναι διατεθειμένος να δώσει ο πελάτης.

compatible_house(
    [MinArea, MinRooms, WantsPets, ElevatorLimit,
     MaxTotal, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden],
    house(_, Rooms, Area, Center, Floor, Elevator, PetsAllowed, Garden, Rent)
) :-
    Area >= MinArea,
    Rooms >= MinRooms,
    pets_ok(WantsPets, PetsAllowed),
    elevator_ok(ElevatorLimit, Floor, Elevator),
    offer([MinArea, Center, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden, MaxTotal],
          Area, Garden, FinalOffer),
    Rent =< FinalOffer.

% offer(Requirements, Area, Garden, Offer)
% Υπολογίζει την προσφορά του πελάτη για ένα σπίτι, με βάση:
% - Την περιοχή (Area) του σπιτιού
% - Το μέγεθος του κήπου (Garden)
% - Requirements: Λίστα που περιέχει MinArea, CenterStatus, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden, MaxTotal.
% Επιστρέφει την τελική προσφορά (Offer), η οποία δεν ξεπερνά το MaxTotal.
% Η προσφορά προσαρμόζεται ανάλογα με το αν το σπίτι βρίσκεται στο κέντρο ή στα προάστια.

offer([MinArea, yes, MaxCenter, _, ExtraPerM2, ExtraPerGarden, MaxTotal], Area, Garden, Offer) :-
    ExtraArea is max(0, Area - MinArea),
    Extra is ExtraArea * ExtraPerM2 + Garden * ExtraPerGarden,
    RawOffer is MaxCenter + Extra,
    ( RawOffer =< MaxTotal -> Offer = RawOffer ; Offer = MaxTotal ).

offer([MinArea, no, _, MaxSuburb, ExtraPerM2, ExtraPerGarden, MaxTotal], Area, Garden, Offer) :-
    ExtraArea is max(0, Area - MinArea),
    Extra is ExtraArea * ExtraPerM2 + Garden * ExtraPerGarden,
    RawOffer is MaxSuburb + Extra,
    ( RawOffer =< MaxTotal -> Offer = RawOffer ; Offer = MaxTotal ).


% === Βοηθητικά για κατοικίδια ===
pets_ok(yes, yes).
pets_ok(no, _).

% === Βοηθητικά για ανελκυστήρα ===
elevator_ok(Limit, Floor, yes) :- Floor >= Limit.
elevator_ok(Limit, Floor, _)   :- Floor < Limit.

% print_houses(Houses)
% Εκτυπώνει τα δεδομένα (διεύθυνση, δωμάτια, εμβαδόν, κήπος, κλπ) για κάθε σπίτι στη λίστα Houses.
% Κάθε σπίτι εμφανίζεται με format για ευκολία ανάγνωσης.

print_houses([]).
print_houses([house(Address, Rooms, Area, Center, Floor, Elevator, Pets, Garden, Rent)|Tail]) :-
    format("\nΚατάλληλο σπίτι στην διεύθυνση: ~w\nΥπνοδωμάτια: ~w\nΕμβαδόν: ~w\nΕμβαδόν κήπου: ~w\nΕίναι στο κέντρο της πόλης: ~w\nΕπιτρέπονται κατοικίδια: ~w\nΌροφος: ~w\nΑνελκυστήρας: ~w\nΕνοίκιο: ~w\n",
           [Address, Rooms, Area, Garden, Center, Pets, Floor, Elevator,  Rent]),
    print_houses(Tail).

% find_best_house(Requirements, Houses, BestHouse)
% Επιλέγει το καλύτερο σπίτι από μια λίστα Houses, με τα εξής κριτήρια:
% 1. Το φθηνότερο ενοίκιο
% 2. Αν υπάρχουν πολλά με το ίδιο ενοίκιο, επιλέγει αυτό με τον μεγαλύτερο κήπο
% 3. Αν υπάρχουν πολλά με ίδιο ενοίκιο και κήπο, επιλέγει αυτό με το μεγαλύτερο εμβαδόν

find_best_house(_, [Best], Best).
find_best_house(_, Houses, Best) :-
    find_cheapest(Houses, CheapestList),
    find_biggest_garden(CheapestList, GardenList),
    find_biggest_area(GardenList, [Best|_]).

% === Βοηθητικά για ταξινόμηση ===
get_rent(house(_,_,_,_,_,_,_,_, Rent), Rent).
has_rent(Min, house(_,_,_,_,_,_,_,_, Rent)) :- Rent =:= Min.
find_cheapest(Houses, CheapestList) :-
    maplist(get_rent, Houses, Rents),
    min_list(Rents, Min),
    include(has_rent(Min), Houses, CheapestList).

get_garden(house(_,_,_,_,_,_,_, Garden, _), Garden).
has_garden(Max, house(_,_,_,_,_,_,_, Garden, _)) :- Garden =:= Max.
find_biggest_garden(Houses, Biggest) :-
    maplist(get_garden, Houses, Gardens),
    max_list(Gardens, Max),
    include(has_garden(Max), Houses, Biggest).

get_area(house(_, _, Area, _, _, _, _, _, _), Area).
has_area(Max, house(_, _, Area, _, _, _, _, _, _)) :- Area =:= Max.
find_biggest_area(Houses, Biggest) :-
    maplist(get_area, Houses, Areas),
    max_list(Areas, Max),
    include(has_area(Max), Houses, Biggest).



% option2/0
% Εκτελεί τη λειτουργία μαζικών προτιμήσεων (Επιλογή 2):
% - Για κάθε πελάτη από το αρχείο requests.pl, εμφανίζει τα σπίτια που πληρούν τις απαιτήσεις του.
% - Καλεί show_results/2 για κάθε πελάτη ώστε να εμφανίσει προτάσεις.

option2 :-
    forall(
        request(Name, MinArea, MinRooms, Pets, ElevatorLimit, MaxTotal, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden),
        (
            format("\nΚατάλληλα διαμερίσματα για τον πελάτη: ~w~n=================================================\n", [Name]),
            Requirements = [MinArea, MinRooms, Pets, ElevatorLimit, MaxTotal, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden],
            findall(
                house(Address, Rooms, Area, Center, Floor, Elevator, PetsAllowed, Garden, Rent),
                (
                    house(Address, Rooms, Area, Center, Floor, Elevator, PetsAllowed, Garden, Rent),
                    compatible_house(Requirements,
                                     house(Address, Rooms, Area, Center, Floor, Elevator, PetsAllowed, Garden, Rent))
                ),
                CompatibleHouses
            ),
            ( CompatibleHouses \= [] ->
                show_results(Requirements, CompatibleHouses)
            ;
                writeln("Δεν υπάρχουν κατάλληλα σπίτια για αυτόν τον πελάτη.")
            )
        )
    ).


/*
ΚΥΡΙΑ ΛΕΙΤΟΥΡΓΙΑ ΔΗΜΟΠΡΑΣΙΑΣ

1. Διαβάζουμε όλα τα requests και τα ονόματα των πελατών από το αρχείο (requests.pl).
2. Για κάθε πελάτη, εντοπίζουμε ποια σπίτια είναι συμβατά με τις απαιτήσεις του (compatible).
3. Υπολογίζουμε την προσφορά (offer) του πελάτη για κάθε συμβατό σπίτι με βάση:
   - base price (ανάλογα με το αν είναι στο κέντρο ή προάστια)
   - extra για εμβαδόν πάνω από το ελάχιστο
   - extra για κήπο
4. Φιλτράρουμε μόνο όσα σπίτια έχουν ενοίκιο ≤ προσφορά.
5. Ταξινομούμε τα κατάλληλα σπίτια του κάθε πελάτη από το καλύτερο προς το χειρότερο, βάσει:
   - φθηνότερο ενοίκιο => μεγαλύτερος κήπος => μεγαλύτερο εμβαδόν.
6. Σε κάθε γύρο:
   α. Επιλέγουμε την πρώτη προτίμηση κάθε πελάτη.
   β. Ομαδοποιούμε τις επιλογές ανά σπίτι: (σπίτι => λίστα πελατών που το θέλουν).
   γ. Για κάθε σπίτι, επιλέγουμε ως νικητή τον πελάτη με τη μεγαλύτερη προσφορά.
7. Αφαιρούμε:
   - Τους πελάτες που κέρδισαν.
   - Τα σπίτια που κατοχυρώθηκαν από τις λίστες των υπόλοιπων.
8. Επαναλαμβάνουμε μέχρι να μην υπάρχουν διαθέσιμες επιλογές για κανέναν πελάτη.
9. Τέλος τυπώνουμε το αποτέλεσμα:
   - ποιος πήρε ποιο σπίτι
   - ή αν δεν κατάφερε να βρει σπίτι
*/


% ======= Λειτουργία 3: Δημοπρασία =======

% option3/0
% Εκτελεί τη διαδικασία δημοπρασίας (Επιλογή 3):
% - Χτίζει τις προτιμήσεις κάθε πελάτη (build_preferences/2)
% - Εκτελεί γύρους δημοπρασίας (loop_auction/3), όπου οι πελάτες επιλέγουν σπίτια και σε περίπτωση σύγκρουσης το παίρνει αυτός με τη μεγαλύτερη προσφορά.
% - Τυπώνει τα τελικά αποτελέσματα (print_final_allocations/2)

option3 :-
    writeln(""),
    findall(Name, request(Name, _, _, _, _, _, _, _, _, _), AllTenants),  % Συλλέγει όλα τα ονόματα πελατών
    build_preferences(AllTenants, Preferences),                            % Δημιουργεί προτιμήσεις κάθε πελάτη
    loop_auction(Preferences, [], FinalAllocations),                      % Εκτελεί επαναληπτικά τη διαδικασία δημοπρασίας
    print_final_allocations(AllTenants, FinalAllocations).               % Εκτυπώνει τα αποτελέσματα

% build_preferences(Tenants, Preferences)
% Δέχεται μια λίστα Tenants (ονόματα πελατών) και δημιουργεί για κάθε πελάτη μια λίστα με τα κατάλληλα σπίτια, ταξινομημένη κατά προτίμηση.
% - Tenants: Λίστα με ονόματα πελατών.
% - Preferences: Λίστα της μορφής [Όνομα - Λίστα_Σπιτιών], όπου η Λίστα_Σπιτιών περιέχει τα σπίτια που πληρούν τα κριτήρια του πελάτη.

% Για κάθε πελάτη:
% 1. Φιλτράρει τα σπίτια βάσει ελάχιστων απαιτήσεων.
% 2. Υπολογίζει την προσφορά του πελάτη για κάθε σπίτι με offer_for/3.
% 3.Κρατάει μόνο τα σπίτια που έχουν ενοίκιο <= προσφορά του πελάτη.
% 4. Βαθμολογεί και ταξινομεί τα σπίτια με βάση score_and_sort_houses/3.
% Αν δεν υπάρχουν κατάλληλα σπίτια, η λίστα του πελάτη είναι κενή.

build_preferences([], []).
build_preferences([Name | Rest], [Name - SortedHouses |  PrefsRest]) :-
    request(Name, MinArea, MinRooms, Pets, ElevatorFloor, _, _, _, _, _),
    findall(
        house(Address, Rooms, Area, Center, Floor, Elevator, PetsAllowed, Garden, Rent),
        (
            house(Address, Rooms, Area, Center, Floor, Elevator, PetsAllowed, Garden, Rent),
            Area>=MinArea,
            Rooms>= MinRooms,
            (Pets == yes -> PetsAllowed == yes ; true),
            (Floor >= ElevatorFloor -> Elevator == yes ; true),
            offer_for(Name, house(Address, Rooms, Area, Center, Floor, Elevator, PetsAllowed, Garden, Rent), Offer),
            Rent =<Offer  % Μόνο αν μπορεί να το πληρώσει
        ),
        Houses
    ),
    score_and_sort_houses(Houses, Name, SortedHouses),  % Ταξινόμηση σπιτιών κατά προτίμηση
    build_preferences(Rest, PrefsRest).


% score(TenantName, House, ScoreList)
% Υπολογίζει λίστα βαθμολογίας για το σπίτι, σύμφωνα με τα κριτήρια της εκφώνησης.
% Η λίστα έχει τη μορφή [Rent, -Garden, -Area], ώστε να επιτρέπεται εύκολη ταξινόμηση:
% - Χαμηλότερο ενοίκιο (Rent): προτιμάται.
% - Μεγαλύτερος κήπος (Garden): προτιμάται => για αυτό χρησιμοποιείται -Garden.
% - Μεγαλύτερο εμβαδόν (Area): προτιμάται => για αυτό χρησιμοποιείται -Area.
% Το TenantName δεν χρησιμοποιείται άμεσα, αλλά παραμένει για συμβατότητα με map_list_to_pairs/3.

score(_, house(_, _, Area, _, _, _, _, Garden, Rent), [Rent, NegativeGarden, NegativeArea]) :-
    NegativeGarden is -Garden,
    NegativeArea is -Area.

% score_and_sort_houses(Houses, TenantName, SortedHouses)
% Ταξινομεί τα σπίτια για έναν πελάτη σε σειρά προτίμησης σύμφωνα με:
% 1. Ενοίκιο (όσο φθηνότερο, τόσο καλύτερο)
% 2. Κήπος (όσο μεγαλύτερος, τόσο καλύτερος)
% 3. Εμβαδόν (όσο μεγαλύτερο, τόσο καλύτερο)
%
% Χρησιμοποιεί map_list_to_pairs/3 για να συσχετίσει κάθε σπίτι με τη λίστα βαθμολογίας του.
% Το predsort/3 χρησιμοποιείται με custom σύγκριση ώστε να ακολουθεί την προτεραιότητα σωστά.

score_and_sort_houses(Houses, Name, Sorted) :-
    map_list_to_pairs(score(Name), Houses, Scored),      % Δημιουργεί ScoreList - House ζεύγη
    predsort(compare_score_lists, Scored, SortedPairs),  % Ταξινομεί βάσει ScoreList
    pairs_values(SortedPairs, Sorted).                   % Επιστρέφει μόνο τα σπίτια, σε σειρά προτίμησης

% compare_score_lists(Order, A-_, B-_)
% Συγκρίνει δύο λίστες βαθμολογίας και επιλέγει το μικρότερο για τα θετικά και μεγαλύτερο για τα αρνητικά.
% Χρησιμοποιείται από predsort/3 για να ταξινομήσει τα σπίτια με βάση Rent, -Garden, -Area.

compare_score_lists(Order, A-_, B-_) :-
    compare(Order, A, B).

% loop_auction(Preferences, Accuμ, Final)
% Εκτελεί τον επαναληπτικό κύκλο της δημοπρασίας:
% - Preferences: Λίστα [Όνομα - ΛίσταΣπιτιών] για κάθε πελάτη.
% - Accum: Όσες κατανομές σπιτιών έχουν γίνει μέχρι τώρα.
% - Final: Τελική λίστα με τις τελικές αναθέσεις σπιτιών.
% Λογική:
% 1. Για κάθε πελάτη, παίρνει την πρώτη του επιλογή (find_first_choices/2).
% 2. Ομαδοποιεί ποιοι θέλουν κάθε σπίτι (group_by_house/2).
% 3. Επιλέγει νικητή για κάθε σπίτι (find_winners/2).
% 4. Ενημερώνει τις προτιμήσεις των πελατών που δεν κέρδισαν (update_preferences/3).
% 5. Επαναλαμβάνει τη διαδικασία μέχρι να εξαντληθούν οι προτιμήσεις.

loop_auction([], Final, Final).
loop_auction(Prefs, Accum, Final) :-
    find_first_choices(Prefs, Choices),          % Παίρνει την πρώτη επιλογή κάθε πελάτη
    group_by_house(Choices, Grouped),               % Ομαδοποιεί ποιοι πελάτες διεκδικούν κάθε σπίτι
    find_winners(Grouped, Winners),                 % Επιλέγει νικητή για κάθε σπίτι
    update_preferences(Prefs, Winners, NewPrefs),   % Ενημερώνει τις προτιμήσεις των χαμένων
    append(Winners, Accum, NewAccum),               % Προσθέτει τους νέους νικητές
    loop_auction(NewPrefs, NewAccum, Final).        % Επόμενος γύρος


% find_first_choices(Preferences, FirstChoices)
% Για κάθε πελάτη, παίρνει την πρώτη επιλογή από τη λίστα προτιμήσεών του.
% Πελάτες χωρίς καθόλου επιλογές αγνοούνται (δεν επιστρέφεται αποτέλεσμα για αυτούς).

find_first_choices([], []).
find_first_choices([Name - [House | _] | Rest], [Name - House | More]) :-
    find_first_choices(Rest, More).
find_first_choices([_ - [] | Rest], More) :-
    find_first_choices(Rest, More).

% group_by_house(Pairs, Grouped)
% Ομαδοποιεί τις πρώτες επιλογές των πελατών ανά σπίτι.
% Χρησιμοποιείται για να δούμε ποιοι πελάτες θέλουν το ίδιο σπίτι σε κάθε γύρο.

group_by_house(Pairs, Grouped) :-
    findall(House, member(_ - House, Pairs), Houses),
    sort(Houses, Unique),
    findall(
        House - Names,
        (
            member(House, Unique),
            findall(Name, member(Name - House, Pairs), Names)
        ),
        Grouped
    ).


% find_winners(Grouped, Winners)
% Επιλέγει τον "νικητή" (τον πελάτη με τη μεγαλύτερη προσφορά) για κάθε σπίτι.
% - Winners: Λίστα [ΌνομαΠελάτη - Σπίτι] με τον τελικό νικητή για κάθε σπίτι.
% Αν μόνο ένας πελάτης θέλει ένα σπίτι, αυτός το παίρνει απευθείας.
% Αν υπάρχουν πολλοί, συγκρίνονται οι προσφορές (offer_for/3) και το παίρνει αυτός με τη μεγαλύτερη.

find_winners([], []).
find_winners([House - [One] | Rest], [One - House | WinnersRest]) :-  % Μόνο ένας ενδιαφερόμενος
    find_winners(Rest, WinnersRest).
find_winners([House - Names | Rest], [Winner - House | WinnersRest]) :-  % Πλειοδότης μεταξύ πολλών
    findall(
        Offer - Name,
        (member(Name, Names), offer_for(Name, House, Offer)),
        Offers
    ),
    sort(0, @>=, Offers, [_ - Winner | _]),  % Επιλέγει τον μεγαλύτερο
    find_winners(Rest, WinnersRest).


% offer_for(Name, House, Offer)
% Υπολογίζει την προσφορά του πελάτη Name για το σπίτι House.
% Βασίζεται στα κριτήρια του πελάτη (request/10):
% - Base = MaxCenter ή MaxSuburb (ανάλογα με το αν το σπίτι είναι στο κέντρο)
% - Προστίθεται το επιπλέον ποσό για κάθε τετραγωνικό πέρα από το ελάχιστο και για τον κήπο.
% Δεν ελέγχει αν το σπίτι είναι συμβατό - υποθέτει ότι έχει ήδη ελεγχθεί.

offer_for(Name, house(_, _, Area, Center, _, _, _, Garden, _), Offer) :-
    request(Name, MinArea, _, _, _, _MaxTotal, MaxCenter, MaxSuburb, ExtraPerM2, ExtraPerGarden),
    ExtraArea is max(0, Area - MinArea),
    Extra is ExtraArea * ExtraPerM2 + Garden * ExtraPerGarden,
    (Center == yes -> Base is MaxCenter ; Base is MaxSuburb),
    Offer is Base + Extra.


% update_preferences(OldPreferences, Winners, NewPreferences)
% Ενημερώνει τις προτιμήσεις των πελατών μετά από έναν γύρο δημοπρασίας:
% - Αν ένας πελάτης έχει ήδη κερδίσει, αφαιρείται από τη λίστα (δεν συμμετέχει ξανά).
% - Για τους υπόλοιπους, αφαιρούνται από τις λίστες προτιμήσεων τα σπίτια που έχουν κατοχυρωθεί από άλλους.
% -Πελάτες χωρίς καθόλου διαθέσιμα σπίτια αφαιρούνται.

update_preferences([], _, []).
update_preferences([Name - _ | Rest], Winners, NewPrefs) :-
    member(Name - _, Winners), !,  % Αν έχει ήδη κερδίσει, δεν συμμετέχει ξανά
    update_preferences(Rest, Winners, NewPrefs).
update_preferences([Name - Houses | Rest], Winners, [Name - NewList | Tail]) :-
    exclude({Winners}/[H]>>member(_ - H, Winners), Houses, NewList),  % Αφαίρεση κατοχυρωμένων σπιτιών
    NewList \= [],  % Κρατάμε μόνο πελάτες με ακόμα διαθέσιμα σπίτια
    update_preferences(Rest, Winners, Tail).
update_preferences([_ - [] | Rest], Winners, Tail) :-  % Πελάτες χωρίς διαθέσιμες επιλογές
    update_preferences(Rest, Winners, Tail).


% print_final_allocations(TenantNames, Allocations)
% Εκτυπώνει για κάθε πελάτη το τελικό αποτέλεσμα της δημοπρασίας:
% - Αν πήρε σπίτι, εμφανίζεται η διεύθυνση.
% - Αν δεν πήρε σπίτι, εμφανίζεται σχετικό μήνυμα.
% TenantNames: Λίστα όλων των πελατών (ονομάτων).
% Allocations: Λίστα [ΌνομαΠελάτη - Σπίτι] με όσους πήραν σπίτια.

print_final_allocations([], _).
print_final_allocations([Name | Rest], Allocations) :-
    ( member(Name - house(Address, _, _, _, _, _, _, _, _), Allocations) ->
        format("O πελάτης ~w θα νοικιάσει το διαμέρισμα στην διεύθυνση: ~w~n", [Name, Address])
    ;
        format("O πελάτης ~w δεν θα νοικιάσει κάποιο διαμέρισμα!~n", [Name])
    ),
    print_final_allocations(Rest, Allocations).