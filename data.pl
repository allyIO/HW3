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
% Edges are symmetric.
edgeTo(N0, N1, C):-
    edge(N0, N1, C); edge(N1, N0, C).

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