module Main where

import Prelude

-- import App.Button (component) 
-- import App.Incrementor (component)
-- import App.EffExample.Rand (component)
-- import App.AffExample.Network (component)
-- import App.Life.Example (component)
-- import App.Life.Timer (component)
-- import App.Life.Listen (component)
-- import App.Nest.Nest (component)

import App.Life.Inp (component)
import Effect (Effect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI component unit body
