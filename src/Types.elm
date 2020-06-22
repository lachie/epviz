module Types exposing (Episode, Season, Show, byGenre, maxShowRating, minShowRating, searchShows)

import Dict exposing (Dict)


type alias Show =
    { imdbID : String
    , title : String
    , seasons : List Season
    , fromYear : Int
    , toYear : Int
    , genres : List String
    }


type alias Season =
    { title : String
    , episodes : List Episode
    }


type alias Episode =
    { imdbID : String
    , title : String
    , rating : Maybe Float
    , votes : Int
    , year : Int
    , runtimeMinutes : Int
    }


type alias Genre =
    { name : String
    , shows : List Show
    }


searchShows : String -> List Show -> List Show
searchShows term shows =
    case term of
        "" ->
            shows

        _ ->
            shows |> List.filter (.title >> String.toLower >> String.contains term)


genrePairs : Show -> List ( String, Show )
genrePairs show =
    show.genres |> List.map (\g -> ( g, show ))


mappend : a -> Maybe (List a) -> Maybe (List a)
mappend s list =
    case list of
        Just l ->
            Just (s :: l)

        Nothing ->
            Just [ s ]


byGenre : List Show -> Dict String (List Show)
byGenre shows =
    let
        pairs =
            shows |> List.concatMap genrePairs
    in
    pairs |> List.foldl (\( g, s ) -> Dict.update g (mappend s)) Dict.empty


showRatings : Show -> List Float
showRatings s =
    s.seasons |> List.concatMap .episodes |> List.map .rating |> List.filterMap identity


maxShowRating : Show -> Float
maxShowRating =
    showRatings >> List.maximum >> Maybe.withDefault 0.0


minShowRating : Show -> Float
minShowRating =
    showRatings >> List.minimum >> Maybe.withDefault 0.0
