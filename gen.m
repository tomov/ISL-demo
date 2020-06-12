function [u,x,y] = gen(left_is_corr)

    % super simple reversal learning
    %
    % u = inputs = feedback from previous timestep
    % x = beliefs = which ans is correct
    % y = outputs = choices
    %
    % run it generatively


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

    y(n) = resp(x(n), u(n));
end
