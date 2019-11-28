
left_is_corr = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0]; 

[u,x,y] = gen(left_is_corr);

[Xold,Wb,X,W,Xbar] = smooth(u,y);
