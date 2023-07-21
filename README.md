# UART_PROJECT
La UART si comporrà di due principali moduli: trasmettitore e ricevitore. 

Trasmettitore: si occupa di serializzare i bit che arrivano in input su “UART_B_IN[7]”, aggiunge lo start bit all’inizio e il parity bit alla fine, concludendo la trasmissione con la linea alta (livello logico 1). La trasmissione avviene non appena il segnale in input “UART_START” diventa alto, sempre che l’input “UART_CTS” sia anch’esso a livello logico alto. La frequenza a cui vengono trasmessi i bit è pari al baudrate scelto.  Si comporrà a sua volta dei seguenti moduli: “Start Management”, “Parity Bit Generator”, “PISO”, “Bit Counter”, “Tick Counter”. 

Ricevitore: Riceve in input su “UART_RX_IN” i bit serializzati. “UART_RX_IN” a “riposo” è sempre a livello alto, non appena viene visto un livello basso, significa che la trasmissione è iniziata. Da quando inizia la trasmissione, il ricevitore deve cominciare a contare i colpi di clock veloce fino a 8 per arrivare nel mezzo della trasmissione del bit, campionarlo e contare da quel momento in poi 16 colpi prima di campionare un nuovo bit. Andrà poi a parallelizzare in output i bit ricevuti “togliendo” lo start bit, il parity bit e l'end bit. Quando il ricevitore è sicuro di aver ricevuto tutti i bit e averli correttamente parallelizzati, viene messo un bit di "ready" alto per 4 colpi di clock veloce durante i quali l’utilizzatore potrà prelevare i dati e sapere se si sono riscontrati degli errori. Si comporrà a sua volta dei seguenti moduli: “Parity Bit Generator”, SIPO”, “Bit Counter”, “Tick Counter”. 


