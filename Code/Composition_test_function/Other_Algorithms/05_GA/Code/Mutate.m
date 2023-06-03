function y=Mutate(x,mu,VarMin,VarMax,nVar)

nmu=ceil(mu*nVar);  % Lam tron

j=randsample(nVar,nmu); % Lay so ngau nhien n so tu nVar den nmu
k = length(j); % lay do dai cua lua chon ngau nhien
sigma = zeros(k,1);
for i  = 1:k
    sigma(i,1)=0.1*(VarMax(j(i,1))-VarMin(j(i,1))); % He so dot bien
    
    y=x;
    y(1,j(i,1))=x(1,j(i,1))+sigma(i,1)*randn(size(j(i,1)));
    
    y(1,j(i,1))=max(y(1,j(i,1)),VarMin(j(i,1)));
    y(1,j(i,1))=min(y(1,j(i,1)),VarMax(j(i,1)));
end
end