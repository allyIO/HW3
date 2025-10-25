% City declarations.
city(arad).
city(bucharest).
city(craiova).
city(drobeta).
city(eforie).
city(fagaras).
city(giurgiu).
city(hirsova).
city(iasi).
city(lugoj).
city(mehadia).
city(neamt).
city(oradea).
city(pitesti).
city(rimnicu_vilcea).
city(sibiu).
city(timisoara).
city(urziceni).
city(vaslui).
city(zerind).

% Edge declarations.
edge(arad, sibiu, 140).
edge(arad, timisoara, 118).
edge(arad, zerind, 75).
edge(bucharest, fagaras, 211).
edge(bucharest, giurgiu, 90).
edge(bucharest, pitesti, 101).
edge(bucharest, urziceni, 85).
edge(craiova, drobeta, 120).
edge(craiova, pitesti, 138).
edge(craiova, rimnicu_vilcea, 146).
edge(drobeta, mehadia, 75).
edge(eforie, hirsova, 86).
edge(fagaras, sibiu, 99).
edge(hirsova, urziceni, 98).
edge(iasi, neamt, 87).
edge(iasi, vaslui, 92).
edge(lugoj, mehadia, 70).
edge(lugoj, timisoara, 111).
edge(oradea, sibiu, 151).
edge(oradea, zerind, 71).
edge(pitesti, rimnicu_vilcea, 97).
edge(rimnicu_vilcea, sibiu, 80).
edge(urziceni, vaslui, 142).

connected(X, Y, C) :-
    edge(X, Y, C).
connected(X, Y, C) :-
    edge(Y, X, C).

% SLD to Bucharest declarations
sld_bucharest(arad, 366).
sld_bucharest(bucharest, 0).
sld_bucharest(craiova, 160).
sld_bucharest(drobeta, 242).
sld_bucharest(eforie, 161).
sld_bucharest(fagaras, 176).
sld_bucharest(giurgiu, 77).
sld_bucharest(hirsova, 151).
sld_bucharest(iasi, 226).
sld_bucharest(lugoj, 244).
sld_bucharest(mehadia, 241).
sld_bucharest(neamt, 234).
sld_bucharest(oradea, 380).
sld_bucharest(pitesti, 100).
sld_bucharest(rimnicu_vilcea, 193).
sld_bucharest(sibiu, 253).
sld_bucharest(timisoara, 329).
sld_bucharest(urziceni, 80).
sld_bucharest(vaslui, 199).
sld_bucharest(zerind, 374).

/* Adi's Code for Finding Path Cost */
               
goal(bucharest).

% Expand a node into its connected neighbors with costs.

expand(Node, Children):- 
    findall((Child, Cost), edge(Node, Child, Cost), Children).

% Calculate the cost of a given path. 

path_cost([_], 0). % Base case: cost of single-node path is 0.
path_cost([A, B | T], Cost) :-
    ( connected(A, B, C1) ; connected(B, A, C1) ),
    path_cost([B | T], C2), % Cost from B to end of path
    Cost is C1 + C2. % Total cost is sum of costs

% Print a path and the cost.

print_path(Path,Cost):-
    write('Path: '), write(Path), nl,
    write('Cost: '), write(Cost), nl, nl.

% Running all searches

run_all:- 
    member(Start, [oradea,timisoara, neamt]), % 
    write('Starting from '), write(Start), write(' to Bucharest'), nl,
    once(solve_bfs(Start, Path1, Cost1)), print_path(Path1, Cost1),
    once(solve_dfs(Start, Path2, Cost2)), print_path(Path2, Cost2),
    once(solve_a_star(Start, Path3, Cost3)), print_path(Path3, Cost3), 
    nl, fail.

/* End of Adi's Code for Finding Path Cost */


/* 
 *  solve_dfs(Start, Path, Cost)
 *      Start: The first node of the path
 *      Path: The path from Start node to bucharest
 *      Cost: The cost of path Path 
 */
solve_dfs(Start, Path, Cost):-
    dfs_search(Start, [], Path),
    path_cost(Path, Cost).

/* 
 *  dfs_search(N0, Visited, Path)
 *      N0: Start node
 *      Visited: Nodes visited so far while generating path
 *      Path: List of nodes from N0 to bucharest
 *  Base case: There is only one node, and that node is bucharest
 */
dfs_search(N0, _, [N0]):-
    N0 = bucharest.

dfs_search(N0, Visited, [N0|T]):-
    connected(N0, N1, _),
    \+ member(N1, Visited), % don't pursue N1 if it has been visited
    dfs_search(N1, [N0|Visited], T).



/* Breadth-First Search Implementation */
% Start a BFS from Start, return Path and its total Cost
% Paths are represented as reversed lists during search
solve_bfs(Start, Path, Cost) :-
    % Find a solution path, reverse it and compute cost
    bfs_search([[Start]], RevPath),
    reverse(RevPath, Path),
    path_cost(Path, Cost).

% First path in the queue reaches the goal which is always bucharest
bfs_search([[Goal | Path] | _], [Goal | Path]) :-
    Goal = bucharest.

% Take first path, expand current node to generate new paths, append these to the end of the queue, and repeat 
bfs_search([[Node | Path] | Rest], Solution) :-
    findall([Next, Node | Path],
            ( connected(Node, Next, _),         
              \+ member(Next, [Node | Path])   
            ),
            NewPaths),
    append(Rest, NewPaths, NewRest),
    bfs_search(NewRest, Solution).

/* Braden's code containing A* implementation */
solve_a_star(Start, Path, Cost) :-
    % Get the heuristic for the start node
    sld_bucharest(Start, H_start),
    
    % F = G + H. G is 0 at the start.
    F_start is 0 + H_start,
    
    % The initial queue: (F_score, G_score, Path)
    InitialQueue = [(F_start, 0, [Start])],
    
    % Call the main search predicate
    a_star_search(InitialQueue, RevPath),
    
    % Process the solution
    reverse(RevPath, Path),
    path_cost(Path, Cost).

/* A* Search - Main Predicates */

% Base Case: Found the goal!
a_star_search([(_, _, [Goal | Path]) | _], [Goal | Path]) :-
    Goal = bucharest.

% Recursive Step: Expand the best node (front of queue)
a_star_search([(_, G, [Node | Path]) | Rest], Solution) :-
    findall(
        (F_new, G_new, [Next, Node | Path]),
        (
            connected(Node, Next, Cost),
            \+ member(Next, [Node | Path]), 
            
            % A* Calculations
            G_new is G + Cost,
            
            % h(n): Get the heuristic value for the neighbor
            sld_bucharest(Next, H_new),
            
            % f(n) = g(n) + h(n)
            F_new is G_new + H_new
        ),
        NewTuples
    ),
    
    append(Rest, NewTuples, UnsortedQueue),
    
    % Sort queue by F_score
    sort(UnsortedQueue, NewRest),
    
    a_star_search(NewRest, Solution).