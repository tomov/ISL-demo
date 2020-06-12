function [X,W,Xbar,Xold] = filt(u,y, N)

    % particle filter for super simple reversal learning
    % see Doucet et al. 2012
    %

    N = 10;

    X(:,1) = rand(N,1) < 0.5; % q(x1|y1) = prior for x

    W(:,1) = response_prob(X(:,1), repmat(y(1),N,1), nan);
    Xold(:,1) = X(:,1);

    % initial resampling
    % SIR/SMC for filtering (p. 20 in Doucet et al. 2012
    %
    n = 1;
    W(:,n) = W(:,n) / sum(W(:,n));
    for j = 1:N
        k = find(mnrnd(1,W(:,n)));
        Xbar(j,:) = X(k,:);
    end

    for n = 2:length(y)

        X = Xbar; % X is just Xbar before the last resampling

        for i = 1:N
            X(i,n) = update(Xbar(i,n-1), u(n));
        end
        W(:,n) = response_prob(X(:,n), repmat(y(n),N,1), u(n));

        Xold(:,n) = X(:,n); % for backward pass TODO is this legit???


        % resample
        clear Xbar;
        W(:,n) = W(:,n) / sum(W(:,n));
        for i = 1:N
            k = find(mnrnd(1,W(:,n)));
            Xbar(i,:) = X(k,:);
        end

    end

end



