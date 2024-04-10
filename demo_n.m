num_sims = 106;

rng(1213);

left_is_corr = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0]; 

N = 100;

z_gens = [];
z_filters = [];
z_smooths = [];
r_gens = [];
r_filters = [];
r_smooths = [];

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

    
    r_gen = corr(gen_x', x');
    r_filter = corr(post_filter', x');
    r_smooth = corr(marg_smooth', x');
    
    z_gen = atanh(corr(gen_x', x'));
    z_filter = atanh(corr(post_filter', x'));
    z_smooth = atanh(corr(marg_smooth', x'));
    
    if isinf(z_gen) || isinf(z_filter) || isinf(z_smooth)
        continue
    end
      
    r_gens = [r_gens r_gen];
    r_filters = [r_filters r_filter];
    r_smooths = [r_smooths r_smooth];
    
    z_gens = [z_gens z_gen];
    z_filters = [z_filters z_filter];
    z_smooths = [z_smooths z_smooth];
end

[h,p,ci,stats] = ttest(z_gens);
fprintf('gen: r = %.2f +- %.2f, T(%d) = %.2f, p = %e\n', mean(r_gens), std(r_gens) / sqrt(length(r_gens)), stats.df, stats.tstat, p);


[h,p,ci,stats] = ttest(z_filters, z_gens);
fprintf('filter vs. gen: r = %.2f +- %.2f, T(%d) = %.2f, p = %e\n', mean(r_filters), std(r_filters) / sqrt(length(r_filters)), stats.df, stats.tstat, p);

[h,p,ci,stats] = ttest(z_smooths, z_gens);
fprintf('smooth vs. gen: r = %.2f +- %.2f, T(%d) = %.2f, p = %e\n', mean(r_smooths), std(r_smooths) / sqrt(length(r_smooths)), stats.df, stats.tstat, p);

[h,p,ci,stats] = ttest(z_smooths, z_filters);
fprintf('smooth vs. filter: T(%d) = %.2f, p = %e\n', stats.df, stats.tstat, p);
