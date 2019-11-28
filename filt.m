function [X] = filt(u,y)

    % particle filter for super simple reversal learning
    %

    N = 10;

    X(:,1) = rand(N,1) < 0.5; % q(x1|y1) = prior for x

    W(:,1) = response_prob(X(:,1), repmat(y(1),N,1), nan);

    % initial resampling
    n = 1;
    w = W(:,n) / sum(W(:,n));
    for j = 1:N
        k = find(mnrnd(1,w));
        Xnew(j,:) = X(k,:);
    end
    X = Xnew;

    for n = 2:length(y)
        for j = 1:N
            X(j,n) = update(X(j,n-1), u(n));
        end
        W(:,n) = response_prob(X(:,n), repmat(y(n),N,1), u(n));


        % resample
        clear Xnew;
        w = W(:,n) / sum(W(:,n));
        for j = 1:N
            k = find(mnrnd(1,w));
            Xnew(j,:) = X(k,:);
        end
        X = Xnew;

    end

end


% TODO dedupe
function x = update(x, u) % draw from fn(xn|xn-1) = p(xn | xn-1, un)
    if u == 0
        if rand < 0.8
            x = 1 - x;
        end
    end
end

function p = response_prob(y, x, u) % gn(yn|xn) = p(yn|xn,un)
    p(y == x) = 0.8;
    p(y ~= x) = 0.2;
end

