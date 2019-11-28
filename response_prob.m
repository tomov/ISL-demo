function p = response_prob(y, x, u) % gn(yn|xn) = p(yn|xn,un)
    p(y == x) = 0.8;
    p(y ~= x) = 0.2;
end
