module Backend exposing(..)
import Models exposing(Movie, Preferences)
import List exposing(sortBy,filter,any)

completaAca = identity

-- **************
-- Requerimiento: filtrar películas por su título a medida que se escribe en el buscador;
-- **************

filtrarPeliculasPorPalabrasClave : String -> List Movie -> List Movie
filtrarPeliculasPorPalabrasClave palabras = List.filter (peliculaTienePalabrasClave palabras)

peliculaTienePalabrasClave : String -> Movie -> Bool
peliculaTienePalabrasClave palabras pelicula = List.all(\palabra->String.contains (String.toLower palabra) (String.toLower pelicula.title)) (String.split " " palabras)

-- esta función la dejamos casi lista, pero tiene un pequeño bug. ¡Corregilo!
--
-- Además tiene dos problemas, que también deberías corregir:
--
-- * distingue mayúsculas de minúsculas, pero debería encontrar a "Lion King" aunque escriba "kINg"
-- * busca una coincidencia exacta, pero si escribís "Avengers Ultron" debería encontrar a "Avengers: Age Of Ultron"
--
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
incrementarLikes id pelicula = if (id == pelicula.id) then { pelicula | likes = pelicula.likes + 1 } else { pelicula | likes = pelicula.likes }

-- **************
-- Requerimiento: cargar preferencias a través de un popup modal,
--                calcular índice de coincidencia de cada película y
--                mostrarlo junto a la misma;
-- **************

calcularPorcentajeDeCoincidencia : Preferences -> List Movie -> List Movie
calcularPorcentajeDeCoincidencia preferencias = ((map (ajustarPorcentajes)) <<  (map (incrementarPorcentaje preferencias)))

incrementarPorcentaje : Preferences -> Movie -> Movie
incrementarPorcentaje preferencias pelicula = if (esPelicula preferencias pelicula.title) then { pelicula | matchPercentage = (incrementarPorcentajePorKeywords preferencias pelicula) + (incrementarPorcentajePorActores preferencias pelicula) + (incrementarPorcentajePorGenero preferencias pelicula) } else { pelicula | matchPercentage = pelicula.matchPercentage }

esPelicula : Preferences -> String -> Bool
esPelicula preferencias tituloPelicula = List.all (\palabra -> String.contains palabra tituloPelicula) (String.split " " preferencias.keywords)

incrementarPorcentajePorKeywords : Preferences -> Movie -> Int
incrementarPorcentajePorKeywords preferencias pelicula = ( (*) 20 << List.length << filter (flip (String.contains) pelicula.title)  <<  String.split " " ) preferencias.keywords

incrementarPorcentajePorActores : Preferences -> Movie -> Int
incrementarPorcentajePorActores preferencias pelicula = if (List.member preferencias.favoriteActor pelicula.actors) then 50 else 0

incrementarPorcentajePorGenero : Preferences -> Movie -> Int
incrementarPorcentajePorGenero preferencias pelicula = if (List.member preferencias.genre pelicula.genre) then 60 else 0

ajustarPorcentajes : Movie -> Movie
ajustarPorcentajes pelicula = if (pelicula.matchPercentage > 100) then { pelicula | matchPercentage = 100 } else { pelicula | matchPercentage = pelicula.matchPercentage }
