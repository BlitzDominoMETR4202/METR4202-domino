function rank = rankDomino(Value)

if Value(1,1) == 0
    rank = 1 + Value(1,2);
elseif Value(1,1) == 1
    rank = 7 + Value(1,2);
elseif Value(1,1) == 2
    rank = 12 + Value(1,2);
elseif Value(1,1) == 3
    rank = 16 + Value(1,2);
elseif Value(1,1) == 4
    rank = 19 + Value(1,2);
elseif Value(1,1) == 5
    rank = 21 + Value(1,2);
elseif Value(1,1) == 6
    rank = 28;
end
    
end