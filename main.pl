:- include('data.pl').


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
    /* once(dfs_search(Start, Path2, Cost2)), print_path(Path2, Cost2), */
    /* once(a_star_search(Start, Path3, Cost3)), print_path(Path3, Cost3), */
    nl, fail.

/* End of Adi's Code for Finding Path Cost */


/* For the predicate search(N0, P, C),
        there is a search path P from city N0 to 
        Bucharest that costs C.

    Solution is when the last node is Bucharest.
*/

/* Base case is that the start city is Bucharest,
    in which case the search path is simply [bucharest]
    and  the cost is 0. */
search(N0, P, C):-
    N0 = bucharest,
    P = [bucharest],
    C = 0.

/* Recursive: search again on all nodes that have an 
    edge with N0 until the base case of just Bucharest. */
search(N0, [N0|T], C):-
    T = [H|_],
    edge(N0, H, C1), 
    C = C1 + C2,
    search(H, T, C2).






/*************************************\
    ALLY'S LAIR OF EMBARRASSMENT... 
    THE CODE IS BAD NOW, DON'T LOOK
\*************************************/

dfs_search(N1, P, C):-
    dfs_search(N1, P, [], C).

dfs_search(N1, [N1], _, 0):-
    N1 = 'Bucharest'.

/* Q is queue of nodes from which to check. Q is maintained 
    depending on the search strategy. */
dfs_search(N0, [N0|T], [N1|QR], C):-
    print([N0|T]),
    /* Update queue based on new current node N1*/
    dfs_enqueue(N1, QR, Q1),
    /* The next node is N1 */
    edge(N0, N1, CE),
    /* The cost of the search is equal to the cost of the first 
        edge + the cost of the search on the remaining tail */
    C = CE + C0,
    dfs_search(N1, T, Q1, C0).


/* Append children of node N to the front of Q0 to get Q. */
/* In DFS, the children of the current node are put at the 
    front of the queue. */
dfs_enqueue(N, Q0, Q):-
    % edge(N, N1, _),
    % if(N1 and not in Q0):
    %     Q = [N1|Q0],
    % else:
    %     Q = Q0.
    findall(City, edge(N, City), Children),
    Q = [Children|Q0].

% findall(city, edge(_, city), Children).


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