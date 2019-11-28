
function p = update_prob(x_new, x, u) % fn(xn|xn-1)
    if u == 0
        if x_new ~= x
            p = 0.7;
        else
            p = 0.3;
        end
    else
        if x_new ~= x
            p = 0;
        else
            p = 1;
        end
    end
end

