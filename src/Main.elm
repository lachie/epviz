module Main exposing (..)

--Element, alignBottom, alignTop, alignLeft column, el, fill, fillPortion, height, maximum, minimum, newTabLink, none, padding, pointer, px, rgb, rgb255, row, scrollbarY, text, width, wrappedRow)

import Browser
import ColourHeat exposing (heat)
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font exposing (size, underline)
import Element.Input as Input
import Element.Lazy exposing (lazy)
import Html exposing (Html)
import Round as Round
import ShowData
import Types exposing (Episode, Season, Show, byGenre, searchShows)



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
    , searchTerm : String
    , shows : List Show
    , focusedEpisode : Maybe Episode
    }


init : ( Model, Cmd Msg )
init =
    ( { shows = ShowData.shows
      , show = Nothing
      , searchTerm = ""
      , genres = byGenre ShowData.shows
      , focusedEpisode = Nothing
      }
    , Cmd.none
    )


genreList : String -> List Show -> Dict String (List Show)
genreList term =
    searchShows term >> byGenre



---- UPDATE ----


type Msg
    = SelectShow Types.Show
    | FocusEpisode Types.Episode
    | ClearShow
    | SearchTermChanged String
    | ClearSearchTerm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectShow show ->
            ( { model | show = Just show, focusedEpisode = Nothing }, Cmd.none )

        FocusEpisode ep ->
            ( { model | focusedEpisode = Just ep }, Cmd.none )

        ClearShow ->
            ( { model | show = Nothing }, Cmd.none )

        SearchTermChanged term ->
            ( { model | searchTerm = term, genres = genreList term model.shows }, Cmd.none )

        ClearSearchTerm ->
            ( { model | searchTerm = "", genres = byGenre ShowData.shows }, Cmd.none )



---- VIEW ----


white =
    rgb255 255 255 255


red =
    rgb255 200 0 0


titleColor =
    rgb255 5 150 240


infoBg =
    rgb255 240 240 240


view : Model -> Html Msg
view model =
    Element.layout [ height fill ] <| appPanel model


info =
    """
Hey!
"""


infoPanel =
    let
        p t =
            paragraph [ width <| px 400, padding 20, Font.alignLeft, centerX ] [ text t ]
    in
    column
        [ height fill
        , width <| fillPortion 4
        , Background.color infoBg
        , padding 20
        ]
        [ paragraph [ Font.size 24, Font.italic, padding 20, Font.bold ] [ text "epviz" ]
        , p """
            Epviz is an IMDB TV episode rating visualiser. 
            It's inspired by a few reddit posts showing similar visualisations,
            but epviz works with any show there's IMDB data for.
            """
        , p """
            The colour scheme is meant to show various ranges of ratings in distinct colours. It's sort of ugly, but it works pretty well for the visualisation!
            """
        , p """
            Getting data from IMDB is a bit tricky, so I've just embedded the static data I had for a handful of shows I enjoy. Even so, the data we do have is a bit patchy!
            """
        , p """
            """
        , paragraph []
            [ newTabLink [ underline, pointer ]
                { url = "https://github.com/lachie/epviz"
                , label = text "source"
                }
            , text " · "
            , newTabLink [ underline, pointer ]
                { url = "https://twitter.com/lachiecox"
                , label = text "twitter"
                }
            ]
        , paragraph [ centerX, padding 20, Font.italic ] [ text "© 2020 Lachie Cox, Data © IMDB" ]
        ]


appPanel : Model -> Element Msg
appPanel model =
    row [ height fill, width fill ]
        [ showListPanel model
        , case model.show of
            Just _ ->
                showPanel model

            Nothing ->
                infoPanel
        ]


plink : Msg -> String -> Element Msg
plink m t =
    el [ underline, pointer, onClick m ] <| text t


titlePanel : Element Msg
titlePanel =
    el
        [ alignTop
        , width fill
        , Background.color titleColor
        , padding 10
        ]
    <|
        row [ width fill ]
            [ el [ Font.size 18, alignLeft, Font.italic, Font.bold ] <| text "epviz"
            , el [ Font.size 10, alignRight, underline, onClick ClearShow ] <| text "by Lachie"
            ]


showListPanel : Model -> Element Msg
showListPanel model =
    let
        { genres } =
            model
    in
    Element.textColumn
        [ Font.alignLeft, Element.scrollbarY, alignTop, width <| fillPortion 1, height fill ]
    <|
        [ titlePanel, searchPanel model ]
            ++ (genres
                    |> Dict.toList
                    |> List.concatMap
                        (\( g, shows ) ->
                            (el [ Font.color (rgb 0 0.75 0), Font.bold ] <| text <| g ++ " ")
                                :: showLinks shows
                        )
               )


searchPanel : Model -> Element Msg
searchPanel { searchTerm } =
    Input.search
        [ Border.rounded 20
        , Font.size 15
        , Element.inFront (el [ alignRight, centerY, paddingEach { right = 10, top = 0, left = 0, bottom = 0 }, onClick ClearSearchTerm, pointer, Font.bold ] (text "x"))
        ]
        { onChange = SearchTermChanged
        , text = searchTerm
        , placeholder = Just <| Input.placeholder [] <| text "search..."
        , label = Input.labelHidden "search"
        }


showLinks : List Show -> List (Element Msg)
showLinks shows =
    let
        sortedShows =
            List.sortBy .title shows
    in
    sortedShows
        |> List.concatMap
            (\show ->
                [ el [ onClick (SelectShow show), underline, Element.pointer ] (text show.title)
                ]
            )


showPanel : Model -> Element Msg
showPanel model =
    case model.show of
        Just show ->
            showPanel_ (showViewModel show model.focusedEpisode)

        Nothing ->
            text "choose a show"


showPanel_ : ShowViewModel -> Element Msg
showPanel_ showV =
    column [ Element.alignTop, height fill, width <| fillPortion 4 ]
        [ row [ width fill, padding 10, Font.size 20, Font.bold ]
            [ text showV.show.title
            , text " ("
            , text <| String.fromInt showV.show.fromYear
            , text "-"
            , text <| String.fromInt showV.show.toYear
            , text ")"
            ]
        , row [ width fill, height fill ]
            [ rangeView
            , ratingsGridView showV
            , episodeDetailView showV.episode
            ]
        ]


showViewModel : Types.Show -> Maybe Types.Episode -> ShowViewModel
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


episodeDetailView : Maybe Episode -> Element Msg
episodeDetailView maybeEpisode =
    el [ width (fill |> minimum 200 |> maximum 400), alignTop ] <|
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
                Element.textColumn [ width fill, alignTop, Font.alignLeft, padding 20, Border.color borderColor, Border.width 1 ]
                    [ el [] <| text <| ep.title ++ " (" ++ String.fromInt ep.year ++ ")"
                    , text (rating ++ "/10")
                    , text " ("
                    , text (String.fromInt ep.votes)
                    , text " votes) "
                    , text " "
                    , newTabLink [ underline ] { url = "https://www.imdb.com/title/" ++ ep.imdbID, label = text "on imdb" }
                    ]


ratingsGridView : ShowViewModel -> Element Msg
ratingsGridView showV =
    let
        indexCol =
            { header = Element.none
            , width = px 100
            , view =
                \i _ ->
                    el [] <| text (String.fromInt (i + 1))
            }

        seasons =
            showV.show.seasons
    in
    Element.indexedTable [ width fill, alignTop, padding 20, Border.color borderColor, Border.width 1 ]
        { data = transposeSeasons seasons
        , columns = indexCol :: episodeGridColumns (episodeCell showV) seasons
        }


episodeCell : ShowViewModel -> Int -> Maybe Episode -> Element Msg
episodeCell showV _ maybeEp =
    case maybeEp of
        Just ep ->
            let
                color =
                    showV.heat ep.rating

                attrs =
                    [ Background.color color
                    , onClick (FocusEpisode ep)
                    , Element.pointer
                    , width <| px 100
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


episodeGridColumns : (Int -> Maybe Episode -> Element Msg) -> List Season -> List (Element.IndexedColumn Row Msg)
episodeGridColumns cellView =
    let
        col =
            \i season ->
                { header = text ("s" ++ season.title)
                , width = px 50
                , view = \rowI -> episodeInRowAtColumn i >> cellView rowI
                }
    in
    List.indexedMap col



-- TODO do by ranges


borderColor =
    rgb 0.8 0.8 0.8


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
    column [ width <| px 100, Element.alignTop, padding 20, Border.color borderColor, Border.width 1 ]
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
