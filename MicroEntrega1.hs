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
