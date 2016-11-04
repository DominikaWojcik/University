%%%%%%%%% A %%%%%%%%%
malo = 10000;
duzo = 100000;
przedzialy = 100;

randMaly = 2 * rand(1,malo) - 1;
randDuzy = 2 * rand(1,duzo) - 1;

%%%%% RYSUJEMY DLA 10^4
figure;
hold on;
histogram(randMaly, przedzialy);
plot([-1,1], (malo / przedzialy) * ones(1,2), 'r');
print('-dpng', '-r300', 'uniform1.png');
close;

%%%%% RYSUJEMY DLA 10^5
figure;
hold on;
histogram(randDuzy, przedzialy);
plot([-1,1], (duzo / przedzialy) * ones(1,2), 'r');
print('-dpng', '-r300', 'uniform2.png');
close;

%%%%%%%%% B %%%%%%%%%
mu = 5;
sigma = 3;

randMaly = normrnd(mu,sigma,1,malo);
randDuzy = normrnd(mu,sigma,1,duzo);

%%%%% RYSUJEMY DLA 10^4
figure;
hold on;
histogram(randMaly, przedzialy);
print('-dpng', '-r300', 'normal1.png');
close;

%%%%% RYSUJEMY DLA 10^5
figure;
hold on;
histogram(randDuzy, przedzialy);
print('-dpng', '-r300', 'normal2.png');
close;

%%%%% RYSUJEMY GESTOSC ROZKLADU NORMALNEGO
figure;
hold on;
ix = [mu - 3*sigma:1e-3:mu + 3*sigma];
iy = pdf('Normal', ix, mu, sigma);
plot(ix, iy, 'r');
print('-dpng', '-r300', 'normalDistribution.png');
close;

%%%%%%%%% C %%%%%%%%%
mu1 = 2;
sigma1 = sqrt(5);
mu2 = 3;
sigma2 = sqrt(1);

randXMaly = normrnd(mu1, sigma1, 1, malo);
randYMaly = normrnd(mu2, sigma2, 1, malo);
randXDuzy = normrnd(mu1, sigma1, 1, duzo);
randYDuzy = normrnd(mu2, sigma2, 1, duzo);


ix1 = [mu1 - 4*sigma1 : 1e-2 : mu1 + 4*sigma1];
iy1 = pdf('Normal', ix1, mu1, sigma1);
ix2 = [mu2 - 4*sigma2 : 1e-2 : mu2 + 4*sigma2];
iy2 = pdf('Normal', ix2, mu2, sigma2);
Z = iy2' * iy1;

%%%%% RYSUJEMY DLA 10^4
figure;
hold on;
scatter(randXMaly, randYMaly,'.');
contour(ix1,ix2,Z,25);
print('-dpng', '-r300', 'pairs1.png');
close;

%%%%% RYSUJEMY DLA 10^5
figure;
hold on;
scatter(randXDuzy, randYDuzy,'.');
contour(ix1,ix2,Z,25);
print('-dpng', '-r300', 'pairs2.png');
close;

%%%%% POZIOMICA GESTOSCI
% X ~ N(mu1, sigma1)
% Y ~ N(mu2, sigma2)
% X i Y są niezależne! zatem prawdopodobienstwo 
% P(X w A, Y w B) = P(X w A) * P(Y w B)
figure;
hold on;
contour(ix1,ix2,Z,25);
print('-dpng', '-r300', 'pairsNormalDistribution.png');
close;


%%%%%%%%% D %%%%%%%%%

%%%%% STATYSTYKA Z POPRZEDNIEGO PODPUNKTU
disp('Prawdopodobienstwo dla 10^4:')
max(0, sign(randYMaly - randXMaly)) * ones(malo, 1) / malo
disp('Prawdopodobienstwo dla 10^5:')
max(0, sign(randYDuzy - randXDuzy)) * ones(duzo, 1) / duzo

%%%%% NORMALNE LICZENIE
%X ~ N(mu1, sigma1^2)
%Y ~ N(mu2, sigma2^2)
%X - Y ~ N(mu1 - mu2, sigma1^2 + (-sigma2)^2)
%P(X - Y < 0) = F(X - Y, 0)
mu3 = mu1 - mu2;
sigma3 = sqrt(sigma1^2 + (-sigma2)^2);
disp('Prawdopodobienstwo wyliczone normalnie:')
normcdf(0, mu3, sigma3)