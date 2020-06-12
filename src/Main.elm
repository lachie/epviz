module Main exposing (..)

import Browser
import ColourHeat exposing (heat)
import Element exposing (Element, column, el, fill, rgb, row, text)
import Element.Background as Background
import Element.Events exposing (onClick)
import Html exposing (Html)
import ShowData
import Types exposing (Episode, Season, Show)



---- MODEL ----
-- breakingBadSeasons =
-- [ Season "1" [ Episode "Pilot" 0.9, Episode "Cat's in the Bag..." 0.87 ]
-- , Season "2" [ Episode "Seven Thirty-Seven" 0.87, Episode "Grilled" 0.93, Episode "Bit by a Dead Bee" 0.84 ]
-- ]
-- breakingBad =
-- Show "Breaking Bad" breakingBadSeasons


type alias Model =
    { show : Maybe Show
    , shows : List Show
    , focusedEpisode : Maybe Episode
    }


init : ( Model, Cmd Msg )
init =
    ( { shows = ShowData.shows
      , show = List.head ShowData.shows
      , focusedEpisode = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = SelectShow Types.Show
    | FocusEpisode Types.Episode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectShow show ->
            ( { model | show = Just show }, Cmd.none )

        FocusEpisode ep ->
            ( { model | focusedEpisode = Just ep }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.layout []
        (column []
            [ showsView model.shows
            , case model.show of
                Just show ->
                    showView (showViewModel show model.focusedEpisode)

                Nothing ->
                    el [] (text "no show bro")
            ]
        )


showsView : List Show -> Element Msg
showsView shows =
    row []
        (List.map
            (\s ->
                el [ onClick (SelectShow s) ] (text s.title)
            )
            shows
        )


showViewModel show focusEp =
    { show = show
    , heat = ColourHeat.heat (Types.minShowRating show) (Types.maxShowRating show)
    , episode = focusEp
    }


type alias ShowViewModel =
    { show : Show
    , episode : Maybe Episode
    , heat : Float -> Element.Color
    }


showView : ShowViewModel -> Element Msg
showView showV =
    column []
        [ row [] [ el [] (text showV.show.title) ]
        , row [] [ epGridView showV ]
        , row [] [ epDetailView showV ]
        ]


epDetailView showV =
    case showV.episode of
        Nothing ->
            Element.none

        Just ep ->
            let
                rating =
                    (ep.rating * 100) |> round |> toFloat |> (*) 0.1

                --  |> (/) 10
            in
            Element.paragraph []
                [ text ep.title
                , text (String.fromFloat rating ++ "/10")
                ]


epGridView : ShowViewModel -> Element Msg
epGridView showV =
    let
        indexCol =
            { header = Element.none
            , width = fill
            , view = \i _ -> text (String.fromInt (i + 1))
            }

        seasons =
            showV.show.seasons
    in
    Element.indexedTable []
        { data = transposeSeasons seasons
        , columns = indexCol :: epGridColumns (epCellView showV) seasons
        }


epCellView : ShowViewModel -> Int -> Maybe Episode -> Element Msg
epCellView showV _ maybeEp =
    case maybeEp of
        Just ep ->
            let
                r =
                    ep.rating

                color =
                    showV.heat r
            in
            el
                [ Background.color color
                , onClick (FocusEpisode ep)
                ]
                (text " ")

        Nothing ->
            el [] Element.none


transposeSeasons : List Season -> List (List (Maybe Episode))
transposeSeasons seasons =
    seasons |> List.map .episodes |> transposeJagged


type alias Row =
    List (Maybe Episode)


episodeInRowAtColumn : Int -> Row -> Maybe Episode
episodeInRowAtColumn n =
    List.drop n >> List.head >> Maybe.withDefault Nothing


epGridColumns : (Int -> Maybe Episode -> Element Msg) -> List Season -> List (Element.IndexedColumn Row Msg)
epGridColumns cellView =
    let
        col =
            \i season ->
                { header = text ("s" ++ season.title)
                , width = fill
                , view = \rowI -> episodeInRowAtColumn i >> cellView rowI
                }
    in
    List.indexedMap col



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }


transposeJagged : List (List a) -> List (List (Maybe a))
transposeJagged listOfLists =
    let
        rowLength =
            Maybe.withDefault 0 <|
                List.maximum <|
                    List.map List.length listOfLists

        maybify =
            padNothing rowLength << List.map Just

        padNothing maxLength list =
            list ++ List.repeat (maxLength - List.length list) Nothing
    in
    List.foldr
        (List.map2 (::))
        (List.repeat rowLength [])
        (List.map maybify listOfLists)
