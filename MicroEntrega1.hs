module MicroEntrega where

import Text.Show.Functions

-- Modelado de tipo de dato
{- Elegimos trabajar con data porque nos pareció más practico , es más expresivo, y a su vez nos permite trabajar con las funciones 
que se crean dentro de la misma -}

data Microcontrolador = Microcontrolador{
	nombre :: String,
	memoriaDeDatos :: [Int],
	acumuladorA :: Int ,
	acumuladorB :: Int,
	programCounter :: Int ,
	etiqueta :: String,
	instrucciones :: [Instruccion]
}deriving (Show)

type Instruccion = Microcontrolador -> Microcontrolador


-- 3.1- Modelar un procesador xt 8088

xt8088 = Microcontrolador { nombre = "xt8088" , memoriaDeDatos = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , instrucciones = [] }

-- Desarrollar la función NOP

nop :: Instruccion
nop  = incrementarProgramCounter.seguirProximaInstruccion

seguirProximaInstruccion :: Microcontrolador -> Microcontrolador
seguirProximaInstruccion microcontrolador = microcontrolador { instrucciones = tail (instrucciones microcontrolador)}

-- 3.2 - Desde la consola modele un programa que haga avanzar tres posiciones el program counter

--   (nop.nop.nop)microcontrolador  
-- El concepto que interviene para lograr este punto es la composicion

-- 3.3 - Modelar las instrucciones LODV , SWAP y ADD

lodV :: Int -> Instruccion
lodV unValor  = incrementarProgramCounter.(cargarEnAcumuladorA unValor)

incrementarProgramCounter :: Microcontrolador -> Microcontrolador
incrementarProgramCounter microcontrolador = microcontrolador { programCounter = (programCounter microcontrolador) + 1 }

cargarEnAcumuladorA :: Int -> Instruccion
cargarEnAcumuladorA unValor microcontrolador = microcontrolador { acumuladorA = unValor }

cargarEnAcumuladorB :: Int -> Instruccion
cargarEnAcumuladorB unValor microcontrolador = microcontrolador { acumuladorB = unValor }

swap :: Instruccion
swap  = incrementarProgramCounter.intercambiarValoresEnAcumuladores 

intercambiarValoresEnAcumuladores :: Instruccion
intercambiarValoresEnAcumuladores microcontrolador = microcontrolador { acumuladorA = (acumuladorB microcontrolador) , acumuladorB = (acumuladorA microcontrolador)}

add :: Instruccion
add  = ((incrementarProgramCounter).(vaciarAcumuladorB).(operarContenidosAcumuladoresAB (+)))

operarContenidosAcumuladoresAB :: (Int -> Int -> Int ) -> Microcontrolador -> Microcontrolador
operarContenidosAcumuladoresAB operacion microcontrolador = microcontrolador { acumuladorA = (operacion (acumuladorA microcontrolador) (acumuladorB microcontrolador)) }

vaciarAcumuladorB :: Microcontrolador -> Microcontrolador
vaciarAcumuladorB microcontrolador = microcontrolador { acumuladorB = (acumuladorB microcontrolador) * 0 }

--Punto 3.3.3.2 Implementar un programa que sume 10 + 22
-- Aca utilizamos el xt8088

-- xt8088 = Microcontrolador { nombre = "xt8088" , memoriaDeDatos = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , instrucciones = [] }

funcionSumar10Mas22 :: Microcontrolador -> Microcontrolador
funcionSumar10Mas22 xt8088 = ((add).(lodV (12)).(intercambiarValoresEnAcumuladores).(lodV 10)) xt8088

--Punto 3.3.4

--Accion divide 

divide :: Instruccion
divide microcontrolador     
 | (acumuladorB microcontrolador) /= 0  =  (incrementarProgramCounter.vaciarAcumuladorB.(operarContenidosAcumuladoresAB(div)))microcontrolador
 | otherwise = ((incrementarProgramCounter).(mensajeDeError "DIVISION BY CERO")) microcontrolador

mensajeDeError :: String -> Instruccion
mensajeDeError mensaje microcontrolador = microcontrolador { etiqueta = mensaje }



str :: Int -> Int -> Instruccion
str addr valor = ((incrementarProgramCounter).(guardarValorEnMemoria addr valor))

guardarValorEnMemoria :: Int -> Int -> Microcontrolador -> Microcontrolador
guardarValorEnMemoria addr valor microcontrolador = microcontrolador { memoriaDeDatos = take (addr - 1) (memoriaDeDatos microcontrolador) ++ [valor] ++ drop (addr) (memoriaDeDatos microcontrolador) }


--Accion LOD

lod :: Int -> Instruccion
lod addr = (incrementarProgramCounter.(guardarValorEnAcumuladorA addr))

guardarValorEnAcumuladorA :: Int -> Microcontrolador -> Microcontrolador
guardarValorEnAcumuladorA addr microcontrolador = microcontrolador { acumuladorA = ((!!) (memoriaDeDatos microcontrolador) (addr-1)) }

-- (addr - 1) porque en las listas los sub-indices comienzan por 0

-- Punto 3.4.4.2

--  Poniendo el siguiente codigo en la linea de comandos de GHCi, modelamos un programa que divida 2 por 0 y nos de el mensaje de error "DIVISON BY ZERO" ((divide).(lod 1).(swap).(lod (2)).(str 2 0).(str 1 2))xt8088

-- Punto 4.4.1.2

-- Se escribe en la consola el siguiente codigo: ((nop).(nop).(nop))xt8088

-- Punto 4.4.2.3

-- LODV 5

-- Se escribe en la consola: lodv 5 xt8088 y se cumplen las pre y post condiciones.

-- Ejecutar SWAP 

fp20 = Microcontrolador { nombre = "fp20" , memoriaDeDatos = [] , acumuladorA = 7 , acumuladorB = 24, programCounter = 0 , etiqueta = " " , instrucciones = [] }

-- Se escribe en la consola: swap fp20 y podemos ver que se intercambian los valores entre el acumulador A y el acumulador B

-- Sumar 10 + 22

-- Se escibre en la consola funcionSumar10Mas22 y vemos que en acumulador A esta en 32 y el acumulador B en 0

--Punto 4.3.4.1

at8086 = Microcontrolador { nombre = "at8086" , memoriaDeDatos = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , instrucciones = [] }

-- Se escribe en la consola str 2 5 at8086 y vemos que se cumplen las condiciones.

--Punto 4.3.4.2

--Se asigna las posiciones a la memoria de datos del microcontrolador xt8088

asignarPosicionesMemoria :: Microcontrolador -> Microcontrolador
asignarPosicionesMemoria microcontrolador = microcontrolador { memoriaDeDatos = replicate 1024 0 }

-- Luego escribimos en la consola el siguiente codigo: ((lod 2).(asignarPosicionesMemoria))xt8088

-- 4.3.4.3

-- Escribimos en la consola el siguiente codigo : ((divide).(lod 1).(swap).(lod (2)).(str 2 0).(str 1 2))xt8088

-- 4.3.4.4

-- Se escribe en la consola: ((divide).(lod 1).(swap).(lod (2)).(str 2 4).(str 1 2))xt8088
