module Test.MySolutions where

import Prelude
import Global (readFloat)
import Math (e, pi, pow, sqrt)

diagonal :: Number -> Number -> Number
diagonal a b = sqrt $ (a * a) + (b * b)

circleArea :: Number -> Number
circleArea radius = (pow radius 2.0) * pi

addE :: String -> Number
addE s = (readFloat s) + e
