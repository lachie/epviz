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
    { range : ( Float, Float )
    , fader : ( Float, Float ) -> Float -> HSL
    }


type alias HSL =
    { h : Float, s : Float, l : Float }


fadeDown : Float -> ( Float, Float ) -> Float -> HSL
fadeDown baseHue ( lo, hi ) value =
    let
        prop =
            proportion lo hi (value * 10)

        h =
            baseHue / total

        s =
            (1 - 0.5) * prop + 0.5

        l =
            (0.65 - 0.5) * (1 - prop) + 0.5
    in
    { h = h, s = s, l = l }


fadeUp : Float -> ( Float, Float ) -> Float -> HSL
fadeUp baseHue ( lo, hi ) value =
    let
        prop =
            1 - proportion lo hi (value * 10)

        h =
            baseHue / total

        s =
            (1 - 0.5) * prop + 0.5

        l =
            (0.65 - 0.5) * (1 - prop) + 0.5
    in
    { h = h, s = s, l = l }


bottomStop =
    Stop ( 0, 5 ) (fadeUp 0)


ranges =
    [ bottomStop
    , Stop ( 5, 6 ) (fadeDown 290)
    , Stop ( 6, 7 ) (fadeDown 70)
    , Stop ( 7, 8 ) (fadeDown 170)
    , Stop ( 8, 9 ) (fadeDown 200)
    , Stop ( 9, 10 ) (fadeDown 120)
    ]


findStop : Float -> Stop
findStop v =
    stop_ (List.reverse ranges) (v * 10)


stop_ : List Stop -> Float -> Stop
stop_ stops v =
    case stops of
        x :: rest ->
            let
                ( lo, _ ) =
                    x.range
            in
            if lo <= v then
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
        stop =
            findStop value

        { h, s, l } =
            stop.fader stop.range value
    in
    Color.hsl h s l |> colorToElmUIColor



-- s lo hi v =


proportion lo hi v =
    (v - lo) / (hi - lo)
