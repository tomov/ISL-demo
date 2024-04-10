num_sims = 106;

rng(1213);

left_is_corr = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0]; 

N = 100;

z_gens = [];
z_filters = [];
z_smooths = [];

for sim = 1:num_sims
    [u,x,y] = gen(left_is_corr);

    xs = []; 
    for j = 1:N
        [~,xtmp,~] = gen(left_is_corr);
        xs(j,:) = xtmp;
    end
    gen_x = mean(xs,1); % estimated ignoring the responses

    
    [Xold,Wb,X,W,Xbar] = smooth(u,y, N);

    marg_smooth = sum(Wb .* Xold); % p(xn|y1:T,u1:T)
    post_filter = sum(W(:,end) .* X); % p(x1:T|y1:T,u1:T)

    
    z_gen = atanh(corr(gen_x', x'));
    z_filter = atanh(corr(post_filter', x'));
    z_smooth = atanh(corr(marg_smooth', x'));
    
    if isinf(z_gen) || isinf(z_filter) || isinf(z_smooth)
        continue
    end
    
    z_gens = [z_gens z_gen];
    z_filters = [z_filters z_filter];
    z_smooths = [z_smooths z_smooth];
end


[h,p,ci,stats] = ttest(z_filters, z_gens);
fprintf('filter vs. gen: T(%d) = %.2f, p = %e\n', stats.df, stats.tstat, p);

[h,p,ci,stats] = ttest(z_smooths, z_gens);
fprintf('smooth vs. gen: T(%d) = %.2f, p = %e\n', stats.df, stats.tstat, p);

[h,p,ci,stats] = ttest(z_smooths, z_filters);
fprintf('smooth vs. filter: T(%d) = %.2f, p = %e\n', stats.df, stats.tstat, p);
