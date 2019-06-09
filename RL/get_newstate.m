function new_state = get_newstate(a,s)
    switch a 
        case 1
            new_state = s - 1; 
        case 2
            new_state = s + 10;
        case 3
            new_state = s + 1;
        case 4
            new_state = s - 10;
    end
end