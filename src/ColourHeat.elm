module ColourHeat exposing (heat)

import Color
import Element


-- heat : Float -> Float -> Float -> Element.Color
-- heat =
    -- heatHSL >> colorToElmUIColor

hot = 0
cold = 120
total = 360


colorToElmUIColor : Color.Color -> Element.Color
colorToElmUIColor c =
    let
        { red, green, blue } =
            Color.toRgba c
    in
    Element.rgb red green blue


heat : Float -> Float -> Float -> Element.Color
heat lo hi value =
    let
        dist = (cold - hot) / total
        ratio =
            (value - lo) / (hi - lo)
    in
    Color.hsl (dist * ratio) 0.5 0.5 |> colorToElmUIColor
