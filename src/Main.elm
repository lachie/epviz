module Main exposing (..)

import Browser
import ColourHeat exposing (heat)
import Dict exposing (Dict)
import Element exposing (Element, column, el, fill, height, newTabLink, none, padding, px, rgb, row, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font exposing (size, underline)
import Element.Lazy exposing (lazy)
import Html exposing (Html)
import Round as Round
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
    , genres : Dict String (List Show)
    , shows : List Show
    , focusedEpisode : Maybe Episode
    }


init : ( Model, Cmd Msg )
init =
    ( { shows = ShowData.shows
      , show = List.head ShowData.shows
      , genres = Types.byGenre ShowData.shows
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
            ( { model | show = Just show, focusedEpisode = Nothing }, Cmd.none )

        FocusEpisode ep ->
            ( { model | focusedEpisode = Just ep }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.layout []
        (column []
            [ showsView model
            , row []
                [ rangeView
                , case model.show of
                    Just show ->
                        showView (showViewModel show model.focusedEpisode)

                    Nothing ->
                        el [] (text "no show bro")
                , epDetailView model.focusedEpisode
                ]
            ]
        )


showsView : Model -> Element Msg
showsView { shows, genres } =
    let
        sortedShows =
            List.sortBy .title shows
    in
    wrappedRow []
        (List.concatMap
            (\s ->
                [ el [ onClick (SelectShow s), underline, Element.pointer ] (text s.title)
                , text " "
                ]
            )
            sortedShows
        )


showViewModel show focusEp =
    { show = show
    , heat = ColourHeat.heatMaybe (Types.minShowRating show) (Types.maxShowRating show)
    , episode = focusEp
    }


type alias ShowViewModel =
    { show : Show
    , episode : Maybe Episode
    , heat : Maybe Float -> Element.Color
    }


showView : ShowViewModel -> Element Msg
showView showV =
    column []
        [ row [] [ el [] (text showV.show.title) ]
        , row [] [ lazy epGridView showV ]
        ]


epDetailView maybeEpisode =
    case maybeEpisode of
        Nothing ->
            none

        Just ep ->
            let
                rawRating =
                    ep.rating |> Maybe.withDefault 0

                rating =
                    Round.round 1 (rawRating * 10)

                --  |> (/) 10
            in
            Element.paragraph []
                [ text ep.title
                , text " "
                , text (rating ++ "/10")
                , text " ("
                , text (String.fromInt ep.votes)
                , text " votes) "
                , text (String.fromInt ep.year)
                , text " "
                , newTabLink [ underline ] { url = "https://www.imdb.com/title/" ++ ep.imdbID, label = text "on imdb" }
                ]


epGridView : ShowViewModel -> Element Msg
epGridView showV =
    let
        indexCol =
            { header = Element.none
            , width = fill
            , view =
                \i _ ->
                    el [] <| text (String.fromInt (i + 1))
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
                color =
                    showV.heat ep.rating

                attrs =
                    [ Background.color color
                    , onClick (FocusEpisode ep)
                    , Element.pointer
                    ]

                borderAttr =
                    -- [ Border.glow (rgb 0 0.7 0) 3 ]
                    [ Border.innerGlow (rgb 0 0 0) 1 ]
            in
            el
                (if showV.episode == Just ep then
                    attrs ++ borderAttr

                 else
                    attrs
                )
            <|
                text " "

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



-- TODO do by ranges


integral : Float -> Bool
integral n =
    n - (n |> truncate |> toFloat) == 0


rangeView : Element Msg
rangeView =
    let
        w =
            25

        h =
            10

        fontSize =
            10

        steps =
            3

        values =
            List.range 0 (steps * 10) |> List.map (\x -> toFloat x / steps / 10) |> List.reverse
    in
    column [ padding 20 ]
        (List.map
            (\v ->
                let
                    heatCol =
                        heat 0 0 v

                    v10 =
                        v * 10

                    tick =
                        el [ Font.size fontSize, Font.alignRight, width (px 15), Element.paddingEach { top = 0, right = 5, left = 0, bottom = 0 } ] <|
                            if integral v10 then
                                text (Round.round 0 v10)

                            else
                                none
                in
                row []
                    [ tick
                    , el [ Background.color heatCol, width (px w), height (px h) ] none
                    ]
            )
            values
        )



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
