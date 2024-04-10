rng(12139);

left_is_corr = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0]; 

N = 100;

[u,x,y] = gen(left_is_corr);


%% ------------ A: subject's view --------------

figure('pos', [1000 1078 851 260]);

subplot(2,1,1);
hold on;
plot(left_is_corr, 'linewidth', 2, 'color', 'black');
plot(x*0.95 + 0.025, 'linewidth', 2, 'color', '#0072BD');
plot(y, '*', 'color', '#77AC30', 'markersize', 10);
ylim([-0.1 1.1]);
lgd1 = legend({'rewarding side (block)', 'subject''s belief (h)', 'subject''s choice (a)'});
lgd1.FontSize = 14;
lgd1.Position = [0.7415 0.6956 0.1904 0.2096];
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',12);
xlabel('trial');
ylabel('choose left');
text(-2.10, 1.36, 'A', 'FontSize', 25, 'FontWeight', 'bold');
title('Subject''s view', 'fontsize', 16);


%% ------------ B: experimenter's view --------------


xs = []; 
for j = 1:N
    [~,xtmp,~] = gen(left_is_corr);
    xs(j,:) = xtmp;
end
gen_x = mean(xs,1); % estimated ignoring the responses



[Xold,Wb,X,W,Xbar] = smooth(u,y, N);

marg_smooth = sum(Wb .* Xold); % p(xn|y1:T,u1:T)
post_filter = sum(W(:,end) .* X); % p(x1:T|y1:T,u1:T)

subplot(2,1,2);
hold on;
plot(x*0.95 + 0.025, 'linewidth', 2);
plot(gen_x, '--', 'linewidth', 2);
plot(post_filter*0.9 + 0.05, 'linewidth', 2);
plot(marg_smooth, 'linewidth', 2);
ylim([-0.1 1.1]);
lgd2 = legend({'subject''s belief (h)', 'generative', 'posterior (filtered)', 'marginal (smoothed)'});
lgd2.FontSize = 14;
lgd2.Position= [0.7415 0.2595 0.1986 0.2750];
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',12);
xlabel('trial');
ylabel('choose left');
text(-2.10, 1.36, 'B', 'FontSize', 25, 'FontWeight', 'bold');
title('Experimenter''s view', 'fontsize', 16);


h = gcf;
%set(h, 'PaperPositionMode', 'auto');
set(h, 'PaperOrientation', 'landscape');
print('reversal', '-dpdf');
