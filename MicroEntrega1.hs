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
etiqueta:: String,
programa:: [Instruccion]
}deriving (Show)

type Instruccion = Microprocesador -> Microprocesador


-- 3.1- Modelar un procesador xt 8088

xt8088 = Microprocesador { nombre = "xt8088" , memoria = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , programa = [] }

-- Desarrollar la función NOP


nop :: Instruccion
nop  =  ejecutarla id



ejecutarla :: Instruccion -> Microprocesador -> Microprocesador
ejecutarla unaFuncion  = incrementarProgramCounter.unaFuncion



incrementarProgramCounter :: Microprocesador -> Microprocesador
incrementarProgramCounter microprocesador = microprocesador { programCounter = (programCounter microprocesador) + 1 }

-- 3.2 - Desde la consola modele un programa que haga avanzar tres posiciones el program counter

--   (nop.nop.nop)microprocesador  
-- El concepto que interviene para lograr este punto es la composicion

-- 3.3 - Modelar las instrucciones LODV , SWAP y ADD


lodv :: Int -> Instruccion
lodv unValor  =  ejecutarla (cargarEnAcumuladorA unValor) 


cargarEnAcumuladorA :: Int -> Instruccion
cargarEnAcumuladorA unValor microprocesador = microprocesador { acumuladorA = unValor }

swap :: Instruccion
swap  = ejecutarla intercambiarValoresEnAcumuladores


intercambiarValoresEnAcumuladores :: Instruccion
intercambiarValoresEnAcumuladores microprocesador = microprocesador { acumuladorA = acumuladorB microprocesador , acumuladorB = acumuladorA microprocesador}

add :: Instruccion
add  = ejecutarla (operarContenidosAcumuladoresAB (+))


operarContenidosAcumuladoresAB :: (Int -> Int -> Int ) -> Microprocesador -> Microprocesador
operarContenidosAcumuladoresAB operacion microprocesador = microprocesador { acumuladorA = (operacion (acumuladorA microprocesador) (acumuladorB microprocesador)), acumuladorB=0}



--Punto 3.3.3.2 Implementar un programa que sume 10 + 22
-- Aca utilizamos el xt8088

-- xt8088 = Microprocesador { nombre = "xt8088" , memoria = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " ",programa=[]  }

-- (add.(lodv 22).swap.(lodv 10)) xt8088

--Punto 3.3.4: Modelar las instrucciones DIV, STR Y LOD

--Accion divide 

divide :: Instruccion
divide microprocesador     
 | (acumuladorB microprocesador) /= 0  =  ejecutarla (operarContenidosAcumuladoresAB(div))microprocesador
 | otherwise = ejecutarla (mensajeError "DIVISION BY ZERO") microprocesador



mensajeError :: String -> Instruccion
mensajeError mensaje microprocesador = microprocesador { etiqueta = mensaje }

--Accion STR 

str :: Int -> Int -> Instruccion
str addr valor = ejecutarla (guardarValorEnMemoria addr valor)


guardarValorEnMemoria :: Int -> Int -> Microprocesador -> Microprocesador
guardarValorEnMemoria addr valor microprocesador = microprocesador { memoria= take (addr - 1) (memoria microprocesador) ++ [valor] ++ drop addr (memoria microprocesador) }


--Accion LOD

lod :: Int -> Instruccion
lod addr = ejecutarla (guardarValorEnAcumuladorA addr)


guardarValorEnAcumuladorA :: Int -> Microprocesador -> Microprocesador
guardarValorEnAcumuladorA addr microprocesador = microprocesador { acumuladorA = (memoria microprocesador) !! (addr-1) }

-- (addr - 1) porque en las listas los sub-indices comienzan por 0

-- PUNTO 3.4.4.2

--  Poniendo el siguiente codigo en la linea de comandos de GHCi, modelamos un programa que divida 2 por 0 y nos de el mensaje de error "DIVISON BY ZERO" ((divide).(lod 1).(swap).(lod (2)).(str 2 0).(str 1 2))xt8088


fp20 = Microprocesador { nombre = "fp20" , memoria = [] , acumuladorA = 7 , acumuladorB = 24, programCounter = 0 , etiqueta = " " ,programa = [] }

at8086 = Microprocesador { nombre = "at8086" , memoria = [1..20] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , programa = []  }

--Se asigna las posiciones a la memoria de datos del microcontrolador xt8088
asignarPosicionesMemoria :: Microprocesador -> Microprocesador
asignarPosicionesMemoria microprocesador = microprocesador { memoria = replicate 1024 0 }

--ENTREGA 2

--PUNTO 3.1.1: CARGA DE UN PROGRAMA
cargarUnPrograma :: [Instruccion]->Microprocesador->Microprocesador
cargarUnPrograma unPrograma microprocesador= Microprocesador{programa=unPrograma}
--Representar la suma de 10 y 22 
--programa1= [(lodv 10),swap, (lodv 22), add] 
--Representar la division de 2 por 0
--programa2= [(str 1 2),(str 2 0), (lod 2), swap, lod 1, div}

--PUNTO 3.2.2:EJECUCIÓN DE UN PROGRAMA
--ejecutarUnPrograma microprocesador= foldl (flip ($ microprocesador)) microprocesador (programa microprocesador) 

--PUNTO 3.3.3 : IFNZ

ifnz microprocesador
  | (/=0).(acumuladorA microprocesador)=ejecutarUnPrograma microprocesador
  |otherwise= microprocesador







