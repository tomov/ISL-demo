function y = resp(x, u) % draw from gn(yn|xn)
    if rand < 0.8
        y = x;
    else
        y = 1 - x;
    end
end

