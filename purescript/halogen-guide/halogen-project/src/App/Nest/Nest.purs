module App.Nest.Nest where

import Prelude
import App.Nest.NestBtn (button)
import Data.Symbol (SProxy(..))
import Halogen as H
import Halogen.HTML as HH

type Slots
  = ( button :: forall q. H.Slot q Void Int )

_button = SProxy :: SProxy "button"

component :: forall q i o m. H.Component HH.HTML q i o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
    }
  where
  render :: forall state action. state -> H.ComponentHTML action Slots m
  --! As Regular HTML
  -- render _ = HH.div_ [ button { label: "Click Me" } ]
  render _ = HH.div_ [ HH.slot _button 0 button { label: "Click Me" } absurd ]

--! As Regular HTML
-- button :: forall w i. { label :: String } -> HH.HTML w i
-- button { label } = HH.button [] [ HH.text label ]
