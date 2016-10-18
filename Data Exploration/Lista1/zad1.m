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
sigma1 = 5;
mu2 = 3;
sigma2 = 1;

randXMaly = normrnd(mu1, sigma1, 1, malo);
randYMaly = normrnd(mu2, sigma2, 1, malo);
randXDuzy = normrnd(mu1, sigma1, 1, duzo);
randYDuzy = normrnd(mu2, sigma2, 1, duzo);

%%%%% RYSUJEMY DLA 10^4
figure;
hold on;
scatter(randXMaly, randYMaly,'.');
print('-dpng', '-r300', 'pairs1.png');
close;

%%%%% RYSUJEMY DLA 10^5
figure;
hold on;
scatter(randXDuzy, randYDuzy,'.');
print('-dpng', '-r300', 'pairs2.png');
close;

%%%%%%%%% D %%%%%%%%%
sign(randYMaly - randXMaly) * ones(malo, 1) / malo
sign(randYDuzy - randXDuzy) * ones(duzo, 1) / duzo