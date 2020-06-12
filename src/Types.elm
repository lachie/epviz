module Types exposing (Episode, Season, Show, maxShowRating, minShowRating)


type alias Show =
    { title : String
    , seasons : List Season
    }


type alias Season =
    { title : String
    , episodes : List Episode
    }


type alias Episode =
    { title : String
    , rating : Float
    }


showRatings : Show -> List Float
showRatings s =
    s.seasons |> List.concatMap .episodes |> List.map .rating


maxShowRating : Show -> Float
maxShowRating =
    showRatings >> List.maximum >> Maybe.withDefault 0.0


minShowRating : Show -> Float
minShowRating =
    showRatings >> List.minimum >> Maybe.withDefault 0.0
