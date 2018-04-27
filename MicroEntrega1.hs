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

--add :: Instruccion
--add  = (cargarEnAcumuladorB 0 (cargarEnAcumuladorA(resultadoDeOperarConAcumuladores (+) microcontrolador)))

resultadoDeOperarConAcumuladores :: (Int -> Int -> Int) -> Microcontrolador -> Int
resultadoDeOperarConAcumuladores funcion microcontrolador = funcion (acumuladorA microcontrolador) (acumuladorB microcontrolador)