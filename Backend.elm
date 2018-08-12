module Backend exposing(..)
import Models exposing(Movie, Preferences)
import List exposing(sortBy,filter,any)

completaAca = identity

-- **************
-- Requerimiento: filtrar películas por su título a medida que se escribe en el buscador;
-- **************

filtrarPeliculasPorPalabrasClave : String -> List Movie -> List Movie
filtrarPeliculasPorPalabrasClave palabras = List.filter (peliculaTienePalabrasClave palabras)

-- esta función la dejamos casi lista, pero tiene un pequeño bug. ¡Corregilo!
--
-- Además tiene dos problemas, que también deberías corregir:
--
-- * distingue mayúsculas de minúsculas, pero debería encontrar a "Lion King" aunque escriba "kINg"
-- * busca una coincidencia exacta, pero si escribís "Avengers Ultron" debería encontrar a "Avengers: Age Of Ultron"
--
peliculaTienePalabrasClave palabras pelicula = String.contains palabras pelicula.title

-- **************
-- Requerimiento: visualizar las películas según el género elegido en un selector;
-- **************


filtrarPeliculasPorGenero : String -> List Movie -> List Movie
filtrarPeliculasPorGenero genero  = filter (tieneAlgunoDeLosGeneros genero) 

tieneAlgunoDeLosGeneros : String -> Movie -> Bool
tieneAlgunoDeLosGeneros genero pelicula = any ((==) genero) pelicula.genre

-- **************
-- Requerimiento: filtrar las películas que sean aptas para menores de edad,
--                usando un checkbox;
-- **************

filtrarPeliculasPorMenoresDeEdad : Bool -> List Movie -> List Movie
filtrarPeliculasPorMenoresDeEdad mostrarSoloMenores = List.filter(esParaChicos mostrarSoloMenores)

esParaChicos : Bool -> Movie -> Bool
esParaChicos mostrarSoloMenores pelicula = mostrarSoloMenores == pelicula.forKids

-- **************
-- Requerimiento: ordenar las películas por su rating;
-- **************


ordenarPeliculasPorRating : List Movie -> List Movie
ordenarPeliculasPorRating  = sortBy .rating 

-- **************
-- Requerimiento: dar like a una película
-- **************

darLikeAPelicula : Int -> List Movie -> List Movie
darLikeAPelicula id =  map (incrementarLikes id)

incrementarLikes : Int -> Movie -> Movie
incrementarLikes id pelicula = case (id == pelicula.id) of
                              True  -> { pelicula | likes = pelicula.likes + 1 }
                              False -> { pelicula | likes = pelicula.likes }

-- **************
-- Requerimiento: cargar preferencias a través de un popup modal,
--                calcular índice de coincidencia de cada película y
--                mostrarlo junto a la misma;
-- **************

calcularPorcentajeDeCoincidencia : Preferences -> List Movie -> List Movie
calcularPorcentajeDeCoincidencia preferencias = completaAca

