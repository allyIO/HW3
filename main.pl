:- include('data.pl').
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