module MicroEntrega where

import Text.Show.Functions

-- Modelado de tipo de dato
{- Elegimos trabajar con data porque nos pareció más practico , es más expresivo, y a su vez nos permite trabajar con las funciones 
que se crean dentro de la misma -}

data Microprocesador = Microprocesador{
nombre:: String,
memoria:: [Int],
acumuladorA:: Int ,
acumuladorB:: Int,
programCounter:: Int ,
etiqueta:: String
}deriving (Show)

type Instruccion = Microprocesador -> Microprocesador


-- 3.1- Modelar un procesador xt 8088

xt8088 = Microprocesador { nombre = "xt8088" , memoria = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " "  }

-- Desarrollar la función NOP

nop :: Instruccion
nop  = incrementarProgramCounter


incrementarProgramCounter :: Microprocesador -> Microprocesador
incrementarProgramCounter microprocesador = microprocesador { programCounter = (programCounter microprocesador) + 1 }

-- 3.2 - Desde la consola modele un programa que haga avanzar tres posiciones el program counter

--   (nop.nop.nop)microprocesador  
-- El concepto que interviene para lograr este punto es la composicion

-- 3.3 - Modelar las instrucciones LODV , SWAP y ADD

lodv :: Int -> Instruccion
lodv unValor  = incrementarProgramCounter.(cargarEnAcumuladorA unValor)


cargarEnAcumuladorA :: Int -> Instruccion
cargarEnAcumuladorA unValor microprocesador = microprocesador { acumuladorA = unValor }

swap :: Instruccion
swap  = incrementarProgramCounter.intercambiarValoresEnAcumuladores 

intercambiarValoresEnAcumuladores :: Instruccion
intercambiarValoresEnAcumuladores microprocesador = microprocesador { acumuladorA = (acumuladorB microprocesador) , acumuladorB = (acumuladorA microprocesador)}

add :: Instruccion
add  = ((incrementarProgramCounter).(vaciarAcumuladorB).(operarContenidosAcumuladoresAB (+)))

operarContenidosAcumuladoresAB :: (Int -> Int -> Int ) -> Microprocesador -> Microprocesador
operarContenidosAcumuladoresAB operacion microprocesador = microprocesador { acumuladorA = (operacion (acumuladorA microprocesador) (acumuladorB microprocesador)) }

vaciarAcumuladorB :: Microprocesador -> Microprocesador
vaciarAcumuladorB microprocesador = microprocesador { acumuladorB = (acumuladorB microprocesador) * 0 }

--Punto 3.3.3.2 Implementar un programa que sume 10 + 22
-- Aca utilizamos el xt8088

-- xt8088 = Microprocesador { nombre = "xt8088" , memoria = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " "  }

funcionSumar10Mas22 :: Microprocesador -> Microprocesador
funcionSumar10Mas22 xt8088 = (add.(lodv 22).swap.(lodv 10)) xt8088

--Punto 3.3.4: Modelar las instrucciones DIV, STR Y LOD

--Accion divide 

divide :: Instruccion
divide microprocesador     
 | (acumuladorB microprocesador) /= 0  =  (incrementarProgramCounter.vaciarAcumuladorB.(operarContenidosAcumuladoresAB(div)))microprocesador
 | otherwise = ((incrementarProgramCounter).(mensajeError "DIVISION BY CERO")) microprocesador

mensajeError :: String -> Instruccion
mensajeError mensaje microprocesador = microprocesador { etiqueta = mensaje }

--Accion STR 

str :: Int -> Int -> Instruccion
str addr valor = ((incrementarProgramCounter).(guardarValorEnMemoria addr valor))

guardarValorEnMemoria :: Int -> Int -> Microprocesador -> Microprocesador
guardarValorEnMemoria addr valor microprocesador = microprocesador { memoria= take (addr - 1) (memoria microprocesador) ++ [valor] ++ drop (addr) (memoria microprocesador) }


--Accion LOD

lod :: Int -> Instruccion
lod addr = (incrementarProgramCounter.(guardarValorEnAcumuladorA addr))

guardarValorEnAcumuladorA :: Int -> Microprocesador -> Microprocesador
guardarValorEnAcumuladorA addr microprocesador = microprocesador { acumuladorA = ((!!) (memoria microprocesador) (addr-1)) }

-- (addr - 1) porque en las listas los sub-indices comienzan por 0

-- PUNTO 3.4.4.2

--  Poniendo el siguiente codigo en la linea de comandos de GHCi, modelamos un programa que divida 2 por 0 y nos de el mensaje de error "DIVISON BY ZERO" ((divide).(lod 1).(swap).(lod (2)).(str 2 0).(str 1 2))xt8088




--CASOS DE PRUEBA

-- Punto 4.4.1.2
-- Se escribe en la consola el siguiente codigo: ((nop).(nop).(nop))xt8088
--Microprocesador {nombre = "xt8088", memoria = [], acumuladorA = 0, acumuladorB = 0, programCounter = 3, etiqueta = " "}


-- PUNTO 4.4.2.3
-- LODV 5
-- Se escribe en la consola: lodv 5 xt8088 y se cumplen las pre y post condiciones.
--Microprocesador {nombre = "xt8088", memoria = [], acumuladorA = 5, acumuladorB = 0, programCounter = 1, etiqueta = " "}

-- Ejecutar SWAP 
fp20 = Microprocesador { nombre = "fp20" , memoria = [] , acumuladorA = 7 , acumuladorB = 24, programCounter = 0 , etiqueta = " "  }
-- Se escribe en la consola: swap fp20 y podemos ver que se intercambian los valores entre el acumulador A y el acumulador B
--Microprocesador {nombre = "fp20", memoria = [], acumuladorA = 24, acumuladorB = 7, programCounter = 1, etiqueta = " "}

-- Ejecutar funcionSumar10Mas22
-- Se escibre en la consola funcionSumar10Mas22 fp20 y vemos que en acumulador A esta en 32 y el acumulador B en 0
--Microprocesador {nombre = "fp20", memoria = [], acumuladorA = 32, acumuladorB = 0, programCounter = 4, etiqueta = " "}


--PUNTO 4.3.4.1
at8086 = Microprocesador { nombre = "at8086" , memoria = [1..20] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " "  }
-- Se escribe en la consola str 2 5 at8086 y vemos que se cumplen las condiciones.
--Microprocesador {nombre = "at8086", memoria = [1,5,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], acumuladorA = 0, acumuladorB = 0, programCounter = 1, etiqueta = " "}


--PUNTO 4.3.4.2
--Se asigna las posiciones a la memoria de datos del microcontrolador xt8088
asignarPosicionesMemoria :: Microprocesador -> Microprocesador
asignarPosicionesMemoria microprocesador = microprocesador { memoria = replicate 1024 0 }
-- Luego escribimos en la consola el siguiente codigo: ((lod 2).asignarPosicionesMemoria)xt8088
--Microprocesador {nombre = "xt8088", memoria = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], acumuladorA = 0, acumuladorB = 0, programCounter = 1, etiqueta = " "}


-- PUNTO 4.3.4.3
-- Escribimos en la consola el siguiente codigo : (divide.(lod 1).swap.(lod 2).(str 2 0).(str 1 2))xt8088
--Microprocesador {nombre = "xt8088", memoria = [2,0], acumuladorA = 2, acumuladorB = 0, programCounter = 6, etiqueta = "DIVISION BY ZERO"}


-- PUNTO 4.3.4.4
-- Se escribe en la consola: (divide.(lod 1).swap.(lod 2).(str 2 4).(str 1 12))xt8088
--Microprocesador {nombre = "xt8088", memoria = [12,4], acumuladorA = 3, acumuladorB = 0, programCounter = 6, etiqueta = " "}
