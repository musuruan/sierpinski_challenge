# Sierpinski challenge

La [Sierpinski challenge](https://www.facebook.com/groups/retroprogramming/posts/879754189371504) è una sfida di programmazione lanciata da Felice Nardella sul gruppo Facebook [RetroProgramming Italia](https://www.facebook.com/groups/retroprogramming/).

> Eccoci qua! Siete pronti per una nuova entusiasmante sfida? La nostra nuova CHALLENGE stavolta riguarda i FRATTALI!  
> Ebbene sì, vi stiamo chiedendo di riprodurre sulle nostre amate Retro-Macchine un TRIANGOLO DI SIERPINSKI.  
> Si tratta di un frattale molto semplice da ottenere, che prende il nome dal matematico che per primo ne studiò le proprietà. Tale triangolo può avere forme e dimensioni diverse e può essere ottenuto in vari modi. Uno dei metodi per crearlo è il cosiddetto "Gioco del caos”.  
> Il frattale viene costruito creando iterativamente una sequenza di punti, a partire da un punto casuale iniziale, in cui ogni punto della sequenza è una data frazione della distanza tra il punto precedente e uno dei vertici del poligono; il vertice è scelto a caso in ogni iterazione. Ripetendo questo processo iterativo un gran numero di volte, selezionando il vertice a caso ad ogni iterazione, spesso (ma non sempre) si produce una forma frattale. Utilizzando un triangolo regolare e il fattore 1/2 si otterrà un triangolo di Sierpinski.  
> Per dare un’idea su come approcciarsi ad un algoritmo del genere, viene mostrato qui, a mo’ di esempio, un programma scritto in Basic v2, non ottimizzato, che riproduce 3000 punti di un triangolo di Sierpinski, in alta risoluzione (Bitmap Mode).  
> Come potete osservare nel video, esso impiega circa 7,3 minuti per plottare 3000 punti.  
> La sfida consiste nel riprodurre **10000** punti del triangolo come quello del video, nel minor tempo possibile.

Per un po' di teoria, vi rimando al [video](https://www.youtube.com/watch?v=kbKtFN71Lfs) sul canale Numberphile.

Ho realizzato **3 versioni in Basic** per i computer Commodre:
- una per C64 con Simon's Basic
- una per VIC20 con Super Expander
- una per Plus4

Il listato è praticamente lo stesso, modificato solo nella parte di plotting dei punti.

La stampa di 10000 punti impiega 5m21s sul C64, 4m29s sul VIC20 e 5m06s sul Plus4.

Per ottimizzare in velocità mi sono basato sullo studio [Writing fast Commodore 64 Basic code](http://microheaven.com/FastC64Basic/index.html) di Fredrik Ramsberg.

Il Basic Commodore non ha una gestione dell'aritmetica dei numeri interi e questi sono convertiti in float per fare le operazioni e il risultato è nuovamente convertito in un numero intero. Quindi nienti interi ma solo numeri in virgola mobile.

Ho minimizzato il numero di righe, cercando di mettere più statement sulla stessa riga. Il Basic infatti impiega più tempo a passare alla riga successiva che a interpretare il separatore ":". 

Ho evitato tutti gli spazi negli statement e non ho messo commenti REM perché avrebbero solo rallentato inutilmente il programma.

Ho cercato di avere numeri di linea più brevi possibili, in modo da avere GOTO più veloci.

Ho usato un ciclo FOR invece della simulazione del ciclo REPEAT/UNTIL che c'era nel codice originario di Felice e non ho usato 3 IF ma il più veloce ON ... GOTO.

E' meglio inoltre avere nomi brevi per le variabili, quindi di un carattere al massimo e ho usato variabili al posto delle costanti (le costanti sono più lente perché i valori devono essere parsificati ogni volta).

Ho fatto anche una **versione in C** con cc65 che gira su C64. Impiega 9 secondi per 10000 punti. Per [generare i numeri casuali](https://archive.org/details/1986-05-compute-magazine/page/n77/mode/2up) uso il SID invece delle routine di libreria, ottenendo un lieve incremento prestazionale. Inoltre, invece di usare la funzione modulo, che è molto dispendiosa, uso una tabella precalcolata per fare il modulo3 del numero casuale generato dal SID.

Mi sono cimentato anche in una **versione in assembly**. Erano 25 anni che non scrivevo niente per il 6502. Non è stato semplice, ma man mano riaffioravano vecchi ricordi. 

Per praticità, visto che ci sono alcune operazioni a 16 bit, ho usato le [macro di geoProgrammer](https://thornton2.com/programming/geos/geoprogrammer-macros.html). Anche in questo caso uso una tabella per effettuare il modulo3 del numero casuale.

Con 10k iterazioni, il programma impega 1778371 cicli (1778371/985248 = 1.80 sec) per disegnare 10 mila punti. Sicuramente manca qualche ottimizzazione, ma non arriverò mai ai 898000 cicli (0.91 secondi) di Antonio Savona. Attendo con impazienza di vedere il suo codice 🙂


