for p = 4:40
    isgood = 1;
    for a = 2:p/2+1
        b = p-a;
        if isprime(b) && isprime(a)
            isgood = 0;
            break;
        end
    end
    if isgood
        disp(p);
    end
end