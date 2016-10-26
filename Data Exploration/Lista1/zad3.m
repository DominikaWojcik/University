%%%%% A %%%%%
d = 100;
x = rand(d,1);
w = rand(d,1);
y = rand(d,1);
sumaWag = (ones(1,d) * w);

dlugoscX = sqrt(x' * x);
sredniaWazonaXW = (x' * w) / sumaWag;
iloczynSkalarnyXY = x' * y;

disp('Wektor x:');
disp(x);
disp('Wektor w:');
disp(w);
disp('Wektor y:');
disp(y);
disp('Dlugosc wektora x:');
disp(dlugoscX);
disp('Srednia wazona wektora x z wagami w:');
disp(sredniaWazonaXW);
disp('Iloczyn skalarny wektorow x i y:');
disp(iloczynSkalarnyXY);

%%%%% B %%%%%
N = 1000;
X = rand(d, N);

dlugosci = sqrt(sum(X.^2))

srednieWazone = (w' * X) / sumaWag;

iloczynySkalarne = y' * X;

kwadratyDlugosci = sum(X.^2);
kwadratDlugY = sum(y.^2)

odleglosciEuklidesowe = sqrt(kwadratDlugY + kwadratyDlugosci - 2 * iloczynySkalarne);



disp('Macierz X:');
disp(X);
disp('Dlugosci wektorów kolumnowych w X:');
disp(dlugosci);
disp('Srednie ważone wektorów kolumnowych w X z wagami z wektora w:');
disp(srednieWazone');
disp('Odleglosci euklidesowe wektorow kolumnowych w X do wektora y:');
disp(odleglosciEuklidesowe);
disp('Iloczyny skalarne wektorow kolumnowych w X z wektorem y');
disp(iloczynySkalarne');
