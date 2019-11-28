function scratch

    left_is_corr = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0]; 
    prob = 0.8;


    x.left_is_corr = 1;



function x = update(x, u) % draw from fn(xn|xn-1) = p(xn | xn-1, un)
    if u.rew == 0
        if rand < 0.3
            x = 1 - x;
        end
    end
end

function y = resp(x, u)
    if rand < 0.8
        y = x;
    else
        y = 1 - x;
    end
end

function p = response_prob(y, x, u) % gn(yn|xn) = p(yn|xn,un)

    if y == x
        p = 0.8;
    else
        p = 0.2;
    end
end


function [x,y] = sim(left_is_corr)
    x = nan(size(left_is_corr));
    u = nan(size(left_is_corr));
    y = nan(size(left_is_corr));


    x(1) = rand > 0.5;

    u(1) = NaN;
    for i = 1:length(left_is_corr)

        % generate response (subj)
        y(i) = resp(x(i), u(i));

        % compute feedback (env)
        u(i+1) = y(i) == left_is_corr(i);

        % update belief (subj)
        x(i+1) = update(x(i), u(i+1));
    end
end
