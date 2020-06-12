module Main exposing (..)

import Browser
import Element exposing (Element, el, text, column, row, fill)
import Html exposing (Html)



---- MODEL ----


type alias Episode =
    { title : String
    , rating : Float
    }


type alias Season =
    { title : String
    , episodes : List Episode
    }


type alias Show =
    { title : String
    , seasons : List Season
    }


breakingBadSeasons =
    [ Season "1" [ (Episode "Pilot" 0.9), (Episode "Cat's in the Bag..." 0.87) ]
    , Season "2" [ (Episode "Seven Thirty-Seven" 0.87), (Episode "Grilled" 0.93), (Episode "Bit by a Dead Bee" 0.84) ]
    ]


breakingBad =
    Show "Breaking Bad" breakingBadSeasons


type alias Model =
    { show : Maybe Show
    }


init : ( Model, Cmd Msg )
init =
    ( { show = Just breakingBad }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.layout []
      (case model.show of
        Just show -> showView show
        Nothing -> (el [] (text "no show bro"))
        )

showView : Show -> Element msg
showView show = 
  column [] 
    [ row [] [ (el [] (text show.title)) ]
    , row [] [ epGridView show.seasons ]
    ]

epGridView : List Season -> Element msg
epGridView seasons = 
  Element.table []
    { data = (epGridCells seasons)
    , columns = (epGridColumns epCellView seasons )
    }

type alias Row = List (Maybe Episode)

nth : Int -> List a -> Maybe a
nth n = List.head << List.drop (n-1)

episodeInRowAtColumn : Int -> Row -> Maybe Episode
episodeInRowAtColumn n = List.drop (n-1) >> List.head >> Maybe.withDefault Nothing

seasonRow : List Season -> Int -> Row
seasonRow seasons index =
  List.map ((nth index) << .episodes) seasons

epGridCells : List Season -> (List Row)
epGridCells seasons = 
  let
      length = seasons |> (List.map (List.length << .episodes)) |> List.maximum |> Maybe.withDefault 0
  in
    List.map (seasonRow seasons) (List.range 0 (length-1))

epGridColumns : (Int -> Row -> Element msg) -> List Season -> List (Element.Column Row msg)
epGridColumns cellView = 
  let
      col = \i season -> { header = (text season.title)
                        , width = fill
                        , view = (cellView i)
                        }
  in
  List.indexedMap col

epCellView : Int -> Row -> Element msg
epCellView column row =
  let
      maybeEp = episodeInRowAtColumn column row
  in
  case maybeEp of
    Just ep -> el [] (text ep.title)
    Nothing -> el [] (text "x")

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
