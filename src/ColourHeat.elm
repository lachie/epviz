module ColourHeat exposing (heat, heatMaybe, ranges)

import Color
import Element



-- heat : Float -> Float -> Float -> Element.Color
-- heat =
-- heatHSL >> colorToElmUIColor


hot =
    0


cold =
    120


total =
    360


type alias Stop =
    { lo : Float
    , hi : Float
    , h : Float

    -- , s : Float
    -- , l : Float
    }


bottomStop =
    Stop 0 3 0


ranges =
    [ bottomStop
    , Stop 3 5 5
    , Stop 5 6 19
    , Stop 6 7 43
    , Stop 7 8 60
    , Stop 8 9 200
    , Stop 9 10 120
    ]


findStop : Float -> Stop
findStop v =
    stop_ (List.reverse ranges) (v * 10)


stop_ : List Stop -> Float -> Stop
stop_ stops v =
    case stops of
        x :: rest ->
            if x.lo <= v then
                x

            else
                stop_ rest v

        _ ->
            bottomStop


noHeat =
    Color.lightGrey |> colorToElmUIColor


colorToElmUIColor : Color.Color -> Element.Color
colorToElmUIColor c =
    let
        { red, green, blue } =
            Color.toRgba c
    in
    Element.rgb red green blue


heatMaybe : Float -> Float -> Maybe Float -> Element.Color
heatMaybe lo hi maybeValue =
    case maybeValue of
        Nothing ->
            noHeat

        Just value ->
            heat lo hi value


heat : Float -> Float -> Float -> Element.Color
heat _ _ value =
    let
        { h, lo, hi } =
            findStop value

        prop =
            proportion lo hi (value * 10)

        hRatio =
            h / total

        s =
            (1 - 0.5) * prop + 0.5

        l =
            (0.65 - 0.5) * (1 - prop) + 0.5
    in
    Color.hsl hRatio s l |> colorToElmUIColor



-- s lo hi v =


proportion lo hi v =
    (v - lo) / (hi - lo)
