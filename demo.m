
left_is_corr = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0]; 

[u,x,y] = gen(left_is_corr);

figure;

subplot(2,1,1);
hold on;
plot(x);
plot(y, '*');
plot(left_is_corr);
legend({'belief', 'choice', 'truth'});

[Xold,Wb,X,W,Xbar] = smooth(u,y);

marg_smooth = sum(Wb .* Xold); % p(xn|y1:T,u1:T)
post_filter = sum(W(:,end) .* X); % p(x1:T|y1:T,u1:T)

subplot(2,1,2);
hold on;
plot(x);
plot(marg_smooth);
plot(post_filter);
legend({'belief', 'marginal (smoothed)', 'posterior (filtered)'});


