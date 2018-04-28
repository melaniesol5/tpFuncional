module MicroEntrega where

import Text.Show.Functions

-- Modelado de tipo de dato

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

xt8088 = Microcontrolador { nombre = "xt8088" , memoriaDeDatos = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " :" , instrucciones = [] }
--RECORDAR: una vez finalizadas las funciones , agregarlas a la lista de instrucciones


-- Desarrollar la función NOP

nop :: Instruccion
nop  = incrementarProgramCounter.seguirProximaInstruccion

seguirProximaInstruccion microcontrolador = microcontrolador { instrucciones = tail (instrucciones microcontrolador)}

-- 3.2 - Desde la consola modele un programa que haga avanzar tres posiciones el program counter

--   (nop.nop.nop)microcontrolador  
-- El concepto que interviene para lograr este punto es la composicion

-- 3.3 - Modelar las instrucciones LODV , SWAP y ADD

lodv :: Int -> Instruccion
lodv unValor  = incrementarProgramCounter.(cargarEnAcumuladorA unValor)

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

operarContenidosAcumuladoresAB operacion microcontrolador = microcontrolador { acumuladorA = (operacion (acumuladorA microcontrolador) (acumuladorB microcontrolador)) }

vaciarAcumuladorB microcontrolador = microcontrolador { acumuladorB = (acumuladorB microcontrolador) * 0 }

--Punto 3.3.3.2 Implementar un programa que sume 10 + 22
-- Aca utilizamos el xt8088
{-
xt8088 = Microcontrolador { nombre = "xt8088" , memoriaDeDatos = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " :" , instrucciones = [swap,add] }

funcionSumar10Mas22 xt8088 = ((add).(lodV (12)).(intercambiarValoresEnAcumuladores).(lodV 10)) xt8088

-}

--Punto 3.3.4

--Accion divide 


divide :: Instruccion
divide microcontrolador     
 | (acumuladorB microcontrolador) /= 0  =  (incrementarProgramCounter.vaciarAcumuladorB.(operarContenidosAcumuladoresAB(div)))microcontrolador
 | otherwise = mensajeDeError "DIVISION BY CERO" microcontrolador

mensajeDeError :: String -> Instruccion
mensajeDeError mensaje microcontrolador = microcontrolador { etiqueta = mensaje }


--Accion STR (Aca medio que me quede estancado porque hay que utilizar la posicion de memoria para guardar el valor que nos dan)

--str :: Int -> Int -> Accion

--str addr valor = (incrementarContadorPrograma.(guardarValorEnMemoria addr valor))

--guardarValorEnMemoria addr valor microprocesador = microprocesador { memoria = (memoria microprocesador) ++ val }

--Accion LOD

lod :: Int -> Instruccion

lod addr = (incrementarProgramCounter.(guardarValorEnAcumuladorA addr))

guardarValorEnAcumuladorA addr microcontrolador = microcontrolador { acumuladorA = ((!!) (memoriaDeDatos microcontrolador) (addr-1)) }

-- (addr - 1) porque en las listas los sub-indices comienzan por 0
