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

xt8088 = Microprocesador { nombre = "xt8088" , memoria = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , programa = [(ifnz [(lodv 3),swap])] }

-- Desarrollar la función NOP
nop :: Instruccion
nop  =  id

ejecutarla :: Instruccion -> Microprocesador -> Microprocesador
ejecutarla unaFuncion microprocesador  
    |etiqueta microprocesador /= " "  = microprocesador
    |otherwise=(incrementarProgramCounter.unaFuncion) microprocesador 


incrementarProgramCounter :: Microprocesador -> Microprocesador
incrementarProgramCounter microprocesador = microprocesador { programCounter = (programCounter microprocesador) + 1 }

-- 3.2 - Desde la consola modele un programa que haga avanzar tres posiciones el program counter

--   (nop.nop.nop)microprocesador  
-- El concepto que interviene para lograr este punto es la composicion

-- 3.3 - Modelar las instrucciones LODV , SWAP y ADD


lodv :: Int -> Instruccion
lodv unValor  =  cargarEnAcumuladorA unValor


cargarEnAcumuladorA :: Int -> Instruccion
cargarEnAcumuladorA unValor microprocesador = microprocesador { acumuladorA = unValor }

swap :: Instruccion
swap  = intercambiarValoresEnAcumuladores


intercambiarValoresEnAcumuladores :: Instruccion
intercambiarValoresEnAcumuladores microprocesador = microprocesador { acumuladorA = acumuladorB microprocesador , acumuladorB = acumuladorA microprocesador}

add :: Instruccion
add  = operarContenidosAcumuladoresAB (+)


operarContenidosAcumuladoresAB :: (Int -> Int -> Int ) -> Microprocesador -> Microprocesador
operarContenidosAcumuladoresAB operacion microprocesador = microprocesador { acumuladorA = (operacion (acumuladorA microprocesador) (acumuladorB microprocesador)), acumuladorB=0}



--Punto 3.3.3.2 Implementar un programa que sume 10 + 22
-- Aca utilizamos el xt8088

-- xt8088 = Microprocesador { nombre = "xt8088" , memoria = [] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " ",programa=[]  }

-- (add.(lodv 22).swap.(lodv 10)) xt8088

--Punto 3.3.4: Modelar las instrucciones DIV, STR Y LOD

-- Instrucción DIVIDE
divide :: Instruccion
divide microprocesador     
 | (acumuladorB microprocesador) /= 0  =  (operarContenidosAcumuladoresAB(div)) microprocesador
 | otherwise = (mensajeError "DIVISION BY ZERO") microprocesador



mensajeError :: String -> Instruccion
mensajeError mensaje microprocesador = microprocesador { etiqueta = mensaje }

--Instrucción STR 
str :: Int -> Int -> Instruccion
str addr valor =  guardarValorEnMemoria addr valor


guardarValorEnMemoria :: Int -> Int -> Microprocesador -> Microprocesador
guardarValorEnMemoria addr valor microprocesador = microprocesador { memoria= take (addr - 1) (memoria microprocesador) ++ [valor] ++ drop addr (memoria microprocesador) }


-- Instrucción LOD
lod :: Int -> Instruccion
lod addr =  guardarValorEnAcumuladorA addr

guardarValorEnAcumuladorA :: Int -> Microprocesador -> Microprocesador
guardarValorEnAcumuladorA addr microprocesador = microprocesador { acumuladorA = (memoria microprocesador) !! (addr-1) }

-- (addr - 1) porque en las listas los sub-indices comienzan por 0


-- Modelado de microprocesador fp20 y microprocesador at8086
fp20 = Microprocesador { nombre = "fp20" , memoria = [] , acumuladorA = 7 , acumuladorB = 24, programCounter = 0 , etiqueta = " " ,programa = [(ifnz [(lodv 3),swap])] }

at8086 = Microprocesador { nombre = "at8086" , memoria = [1..20] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , programa = []  }



--Se asigna las posiciones a la memoria de datos del microcontrolador xt8088
asignarPosicionesMemoria :: Microprocesador -> Microprocesador
asignarPosicionesMemoria microprocesador = microprocesador { memoria = replicate 1024 0 }

--ENTREGA 2

--PUNTO 3.1.1: CARGA DE UN PROGRAMA
cargarUnPrograma :: [Instruccion]->Microprocesador->Microprocesador
cargarUnPrograma unPrograma microprocesador= microprocesador{programa=unPrograma}

--Representar la suma de 10 y 22 
--programa1= [(lodv 10),swap, (lodv 22), add] 
{- MicroEntrega1 > cargarUnPrograma [(lodv 10),swap, (lodv 22), add] fp20
Microprocesador {nombre = "fp20", memoria = [], acumuladorA = 7, acumuladorB = 24, programCounter = 0, etiqueta = " ", programa = [<function>,<function>,<function>,<function>]}
-}

--Representar la division de 2 por 0
--programa2= [(str 1 2),(str 2 0), (lod 2), swap, lod 1, divide]
{- *MicroEntrega1 > cargarUnPrograma [(str 1 2),(str 2 0), (lod 2), swap, (lod 1), divide] xt8088
Microprocesador {nombre = "xt8088", memoria = [], acumuladorA = 0, acumuladorB = 0, programCounter = 0, etiqueta = " ", programa = [<function>,<function>,<function>,<function>,<function>,<function>]}
-}

--PUNTO 3.2.2:EJECUCIÓN DE UN PROGRAMA
at8082 = Microprocesador "at8082"  [] 0 0 0 " " [(str 1 2),(str 2 0), (lodv 0), swap,(lodv 2), divide, (str 3 2), (str 4 3)]
ejecutarUnPrograma:: Microprocesador -> Microprocesador
ejecutarUnPrograma microprocesador = aplicarInstruccionesAlMicro microprocesador (programa microprocesador) 




--PUNTO 3.3.3 : IFNZ
aplicarInstruccionesAlMicro :: Microprocesador -> Microprocesador
aplicarInstruccionesAlMicro microprocesador lista  = foldl (flip (($).ejecutarla)) microprocesador lista

ifnz :: [Instruccion] -> Instruccion
ifnz listaDeInstrucciones microprocesador
    | acumuladorA microprocesador /= 0 = aplicarInstruccionesAlMicro microprocesador listaDeInstrucciones
    |otherwise= microprocesador

{- Al ejecutar la instrución IFNZ de las instrucciones LODV 3 y SWAP sobre el microprocesador fp20, que tiene inicialmente 7 en el
acumulador A y 24 en el acumulador B. El acumulador A debe quedar en 24 , el acumulador en B debe quedar 3 :

*MicroEntrega1> ejecutarUnPrograma fp20
Microprocesador {nombre = "fp20", memoria = [], acumuladorA = 24, acumuladorB = 3, programCounter = 2, etiqueta = " ", programa = [<function>,<function>]}
-}

{- Al ejecutar la instrución IFNZ de las instrucciones LODV 3 y SWAP sobre el microprocesador xt8088 , el acumulador A debe continuar en 0,
el acumulador B debe continuar en 0 .

*MicroEntrega> ejecutarUnPrograma xt8088
Microprocesador {nombre = "xt8088", memoria = [], acumuladorA = 0, acumuladorB = 0, programCounter = 1, etiqueta = " ", programa = [<function>]}

-}


--PUNTO 3.5.5 : MEMORIA ORDENADA
laMemoriaEstaOrdenada :: Microprocesador -> Bool
laMemoriaEstaOrdenada = memoriaOrdenada.memoria

memoriaOrdenada :: [Int] -> Bool
memoriaOrdenada [] = True
memoriaOrdenada [_] = True  
memoriaOrdenada (x:y:xs) = y>=x && memoriaOrdenada xs 


microDesorden = Microprocesador { nombre = "microDesorden" , memoria = [2,5,1,0,6,9] , acumuladorA = 0 , acumuladorB = 0, programCounter = 0 , etiqueta = " " , programa = [] }