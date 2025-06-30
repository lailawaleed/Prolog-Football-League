:- consult('league_data.pl').  % Load existing definitions

/* Helper predicates used across tasks */
%Custom append to concatenate lists
custom_append([], L, L).
custom_append([H|T], L2, [H|NT]) :- custom_append(T, L2, NT).

%Custom member check
custom_is_member(X, [X|_]) :- !.
custom_is_member(X, [_|T]) :- custom_is_member(X, T).

%Custom list length

custom_length([], 0) :- !.
custom_length([_|T], A) :-  
    custom_length(T, R),
    A is R + 1.    

/*============================ task 1 :-)  Get a list of all players in a specific team ===============================*/
%Player(Name, Team, Position) 

players_in_team(Team, Players) :-
    collect_players(Team, [], Players),
    Players \= [],
    !. 

collect_players(Team, Acc, Players) :-
    player(Name, Team, _),
    \+ custom_is_member(Name, Acc),  %Avoid duplicates
    custom_append(Acc, [Name], NewAcc),
    collect_players(Team, NewAcc, Players),
    !.

collect_players(_, Players, Players) :- !. %Base case

/*============================ task 2 :-)  Count how many teams are from a specific country  ===================================*/
%Team(Name, Country, Num_of_winning_times)

team_count_by_country(Country, Count) :-
    collect_teams(Country, [], Teams),
    custom_length(Teams, Count),
    !.

collect_teams(Country, Acc, Teams) :-
    team(Team, Country, _),
    \+ custom_is_member(Team, Acc),  % Avoid duplicates
    custom_append(Acc, [Team], NewAcc),
    collect_teams(Country, NewAcc, Teams),
    !.

collect_teams(_, Teams, Teams) :- !.   %Base case

/*============================ task 3 :-)  Find the most successful team ===================================*/
%Team(Name, Country, Num_of_winning_times)

most_successful_team(Team) :-
    max_titles(0, MaxTitles, ''),
    team(Team, _, MaxTitles),
    MaxTitles > 0,
    !.

max_titles(CurrentMax, MaxTitles, _) :-
    team(_, _, Titles),
    Titles > CurrentMax,
    max_titles(Titles, MaxTitles, _),
    !.

max_titles(Max, Max, _) :- !. %Base case

/*============================ task 4 :-) List all matches where a specific team participated ===============================*/
%Match(Team1, Team2, Team1Goals, Team2Goals) 

matches_of_team(Team, Matches) :-
    collect_matches(Team, [], Matches),
    Matches \= [],
    !.

collect_matches(Team, Acc, Matches) :-
    match(T1, T2, T1G, T2G),
    (T1 = Team ; T2 = Team),
    Match = (T1, T2, T1G, T2G),
    \+ custom_is_member(Match, Acc),  %Avoid duplicates
    custom_append(Acc, [Match], NewAcc),
    collect_matches(Team, NewAcc, Matches),
    !.

collect_matches(_, Matches, Matches) :- !.  %Base case

/*============================ task 5 :-)  count all matches where a specific team participated ===============================*/

num_matches_of_team(Team, N) :-
    matches_of_team(Team, Matches),  % Get all matches for the team
    custom_length(Matches, N),           % Count the number of matches
    !.

/*============================ task 6 :-)  Find the top goal scorer in the tournament   ===================================*/
%Goals(Player, Num_of_scored_goals)

top_scorer(Player) :-
    max_goals(0, none, MaxGoals, TopPlayer),
    MaxGoals > 0,
    Player = TopPlayer,
    !.

max_goals(CurrentMax, _, MaxGoals, TopPlayer) :-  
    goals(Player, Goals),
    Goals > CurrentMax,
    max_goals(Goals, Player, MaxGoals, TopPlayer).

max_goals(Max, Player, Max, Player) :- !. %Base case

/*============================ task 7 :-)  Find the Most Common Position in a Specific Team  ===================================*/
%Player(Name, Team, Position) 

%Main predicate
most_common_position_in_team(Team, Pos) :-
    %Start with an empty list to track position counts,and players processed
    most_common_position_in_team_helper(Team, [], [], Pos),
    !.

%Base case: All players in the team have been processed
most_common_position_in_team_helper(Team, ProcessedPlayers, PositionCounts, Pos) :-
    %%Check if all players in the team have been processed %%
    all_players_processed(Team,ProcessedPlayers),

    %%Find the position with the highest count in the list %%
    find_highest_count_position(PositionCounts, Pos),
    !.

%Recursive case: Process each player in the team
most_common_position_in_team_helper(Team, ProcessedPlayers, PositionCounts, Pos) :-
    %%Retrieve a player from the team %%
    player(Name, Team, Position),

    %%Ensure the player has not been processed already %%
    \+ custom_is_member(player(Name, Team, Position), ProcessedPlayers),

    %%Update the count for the players position %%
    update_position_count(Position, PositionCounts, UpdatedCounts),

    %%Add the player to the list of processed players %%
    NewProcessedPlayers = [player(Name, Team, Position) | ProcessedPlayers],

    %%Recursively process the remaining players %%
    most_common_position_in_team_helper(Team, NewProcessedPlayers, UpdatedCounts, Pos).


%Helper predicate to check if all players in the team have been processed
all_players_processed(Team,ProcessedPlayers) :-
    %%Fail if there is any player in the team not in the processed list %%
    \+ (player(Name, Team, Position),

    \+ custom_is_member(player(Name, Team, Position), ProcessedPlayers)).    

%Helper predicate to update the count of a position

%Base case: Add the position with a count of 1 if the list is empty
update_position_count(Position, [], [1-Position]).

update_position_count(Position, [Count-Pos | Rest], UpdatedList) :-
    %%If the position matches, increment the count %%
    (Position = Pos ->
        NewCount is Count + 1,
        UpdatedList = [NewCount-Pos | Rest]
    ;
        %%Otherwise, keep the current entry and process the rest of the list %%
        update_position_count(Position, Rest, UpdatedRest),
        UpdatedList = [Count-Pos | UpdatedRest]
    ).

%Helper predicate to find the position with the highest count
find_highest_count_position([_-Pos], Pos). %%If there is only one position, it is the most common %%

find_highest_count_position([Count1-Pos1, Count2-Pos2 | Rest], Pos) :-
    %%Compare the counts of the first two positions %%
    (Count1 >= Count2 ->
        %%If the first position has a higher or equal count, keep it %%
        find_highest_count_position([Count1-Pos1 | Rest], Pos)
    ;
        %%Otherwise, keep the second position %%
        find_highest_count_position([Count2-Pos2 | Rest], Pos)).



/*1.Start
#      Call most_common_position_in_team(Team, Pos).

# 2. Initialize
#     Begin with empty lists:
#     ProcessedPlayers = [] (no players counted yet)
#     PositionCounts = [] (no positions tracked yet)

# 3. Process Players
#     For each player in the team:
#     Check: Is this player already processed?
#     If new:
#     Increment their position’s count in PositionCounts (e.g., [1-forward] → [2-forward]).
#     Add them to ProcessedPlayers.

# 4. Stop Condition
#     When all players are in ProcessedPlayers:
#     Find the position with the highest count in PositionCounts.

# 5. Return Result
#     Bind Pos to the most common position (e.g., forward).

*/