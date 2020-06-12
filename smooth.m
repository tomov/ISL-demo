function [Xold,Wb,X,W,Xbar] = smooth(u,y, N)

    % particle filter for super simple reversal learning
    % see Doucet et al. 2012 
    %
    % smoothing: sum(Wb .* Xold, 1) = marginals p(xn|y1:T,u1:T)
    % filtering: mean(Xbar, 1) or sum(W(:,end) .* X) = p(x1:T|y1:T,u1:T) but only last ones are really good 
    %

    % forward filtering part
    [X,W,Xbar,Xold] = filt(u,y, N);
    N = size(X,1);

    n = length(u);
    Wb = nan(size(W)); % backward weights
    Wb(:,n) = W(:,n);

    % backward smoothing part 
    % Eq. 49 on p. 35 in Doucet et al. 2012
    %
    for n = length(u)-1:-1:1
        % precompute sum in denominator
        sum_updates = zeros(1,N);
        for j = 1:N
            for l = 1:N
                sum_updates(j) = sum_updates(j) + W(l,n) * update_prob(Xold(j,n+1), Xold(l,n), u(n+1));
            end
        end
        % zero means that none of the particles at n could produce particle j at time n+1
        % but this can't be -- every particle at n+1 must have come from a particle at n, even after resampling!
        assert(~any(sum_updates == 0));

        for i = 1:N
            Wb(i,n) = 0;
            for j = 1:N
                Wb(i,n) = Wb(i,n) + Wb(j,n+1) * update_prob(Xold(j,n+1), Xold(i,n), u(n+1)) / sum_updates(j);
            end
            Wb(i,n) = Wb(i,n) * W(i,n);
        end
    end

    %assert(immse(sum(Wb,1) - 1) < 1e-15);


end


