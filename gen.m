function [u,x,y] = gen()

    % super simple reversal learning
    %
    % u = inputs = feedback from previous timestep
    % x = beliefs = which ans is correct
    % y = outputs = choices
    %
    % run it generatively

    left_is_corr = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0]; 
    prob = 0.8;


    [x,y,u] = sim(left_is_corr);
end



function x = update(x, u) % draw from fn(xn|xn-1) = p(xn | xn-1, un)
    if u == 0
        if rand < 0.8
            x = 1 - x;
        end
    end
end

function y = resp(x, u) % draw from gn(yn|xn)
    if rand < 0.8
        y = x;
    else
        y = 1 - x;
    end
end

function p = response_prob(y, x, u) % gn(yn|xn) = p(yn|xn,un)
    p(y == x) = 0.8;
    p(y ~= x) = 0.2;
end


function [x,y,u] = sim(left_is_corr)
    x = nan(size(left_is_corr));
    u = nan(size(left_is_corr));
    y = nan(size(left_is_corr));


    x(1) = rand > 0.5;

    u(1) = NaN;
    for n = 2:length(left_is_corr)+1

        % generate response (subj)
        y(n-1) = resp(x(n-1), u(n-1));

        % compute feedback (env)
        u(n) = y(n-1) == left_is_corr(n-1);

        % update belief (subj)
        x(n) = update(x(n-1), u(n));
    end
end
