function x_new = update(x, u) % draw from fn(xn|xn-1) = p(xn | xn-1, un)
    if u == 0
        if rand < 0.7
            x_new = 1 - x;
        else
            x_new = x;
        end
    else
        x_new = x;
    end
end

