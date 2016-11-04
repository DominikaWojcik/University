import numpy as np

def KMeans(K, data):
    d = np.size(data, axis=0)
    N = np.size(data, axis=1)
    
    #Centra grup (losowe wektory z danych)
    R = data[:, np.random.randint(N, size=K)]
    #Przynależnosc do grupy (na poczatku wszyscy do zero)
    C = np.zeros((1,N), dtype=np.int64)

    groupsChanged = True
    while groupsChanged:
        #Interesuje nas minimalna wartość <r,r> -2<u,r>, gdzie u to wektor z danych a r to jakies centrum
        iloczynySkalarne = -2. * np.dot(data.T, R)
        R**=2
        kwadratyDlugosciR = np.sum(R, axis=0, keepdims=True)
        iloczynySkalarne += kwadratyDlugosciR

        #Dla kazdego wektora z danych wybieramy najblizszy wektor z R i aktualizujemy grupy
        newC = np.argmin(iloczynySkalarne, axis=1)
        groupsChanged = np.array_equal(C, newC)
        C = newC

        #Obliczamy srodki ciezkosci dla kazdej grupy
        macierzPrzynaleznosci = np.zeros((N,K))
        for i in range N:
            macierzPrzynaleznosci[i][C[i]] = 1
        #Sumy danych w każdej z grup
        R = np.dot(data, macierzPrzynaleznosci)
        liczebnosciGrup = np.sum(macierzPrzynaleznosci, axis=0, keepdims=True)
        R /= liczebnosciGrup

    return C





    
    

    
