--CASOS DE PRUEBA

-- Punto 4.4.1.2
-- Se escribe en la consola el siguiente codigo: ((nop).(nop).(nop))xt8088
--Microprocesador {nombre = "xt8088", memoria = [], acumuladorA = 0, acumuladorB = 0, programCounter = 3, etiqueta = " ",programa=[]}


-- PUNTO 4.4.2.3
-- LODV 5
-- Se escribe en la consola: lodv 5 xt8088 y se cumplen las pre y post condiciones.
--Microprocesador {nombre = "xt8088", memoria = [], acumuladorA = 5, acumuladorB = 0, programCounter = 1, etiqueta = " ",programa=[]}

-- Ejecutar SWAP 
fp20 = Microprocesador { nombre = "fp20" , memoria = [] , acumuladorA = 7 , acumuladorB = 24, programCounter = 0 , etiqueta = " " ,programa = [] }
-- Se escribe en la consola: swap fp20 y podemos ver que se intercambian los valores entre el acumulador A y el acumulador B
--Microprocesador {nombre = "fp20", memoria = [], acumuladorA = 24, acumuladorB = 7, programCounter = 1, etiqueta = " ", programa=[]}

-- Ejecutar funcionSumar10Mas22
-- Se escibre en la consola funcionSumar10Mas22 fp20 y vemos que en acumulador A esta en 32 y el acumulador B en 0
--Microprocesador {nombre = "fp20", memoria = [], acumuladorA = 32, acumuladorB = 0, programCounter = 4, etiqueta = " ", programa=[]}


--PUNTO 4.3.4.1
at8086 = Microprocesador { nombre = "at8086" , memoria = [1..20] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , programa = []  }
-- Se escribe en la consola str 2 5 at8086 y vemos que se cumplen las condiciones.
--Microprocesador {nombre = "at8086", memoria = [1,5,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], acumuladorA = 0, acumuladorB = 0, programCounter = 1, etiqueta = " ", programa=[]}


--PUNTO 4.3.4.2
--Se asigna las posiciones a la memoria de datos del microcontrolador xt8088
asignarPosicionesMemoria :: Microprocesador -> Microprocesador
asignarPosicionesMemoria microprocesador = microprocesador { memoria = replicate 1024 0 }
-- Luego escribimos en la consola el siguiente codigo: ((lod 2).asignarPosicionesMemoria)xt8088
--Microprocesador {nombre = "xt8088", memoria = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], acumuladorA = 0, acumuladorB = 0, programCounter = 1, etiqueta = " ", programa=[]}


-- PUNTO 4.3.4.3
-- Escribimos en la consola el siguiente codigo : (divide.(lod 1).swap.(lod 2).(str 2 0).(str 1 2))xt8088
--Microprocesador {nombre = "xt8088", memoria = [2,0], acumuladorA = 2, acumuladorB = 0, programCounter = 6, etiqueta = "DIVISION BY ZERO", programa=[]}

-- PUNTO 4.3.4.4
-- Se escribe en la consola: (divide.(lod 1).swap.(lod 2).(str 2 4).(str 1 12))xt8088
--Microprocesador {nombre = "xt8088", memoria = [12,4], acumuladorA = 3, acumuladorB = 0, programCounter = 6, etiqueta = " ", programa=[]}



