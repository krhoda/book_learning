-- HalogenM in handleAction signatures:
--* Only using the HalogenM monad:
-- handleAction :: forall output m. Action -> HalogenM State Action () output m Unit
--* Using the Effect monad:
-- handleAction :: forall output. Action -> HalogenM State Action () output Effect Unit
--* Using the Aff monad:
-- handleAction :: forall output. Action -> HalogenM State Action () output Aff Unit
--* More commonly, use a type constraint:
-- handleAction :: forall output m. MonadAff m => Action -> HalogenM State Action () output m Unit

--! The MonadAff is a specialized MonadEffect

module App.EffExample.Rand where

import Prelude
import Data.Maybe (Maybe(..), maybe)
import Effect.Class (class MonadEffect)
import Effect.Random (random)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

data Action
  = Regenerate

type State
  = Maybe Number

initialState :: forall i. i -> State
initialState _ = Nothing

component :: forall query input output m. MonadEffect m => H.Component HH.HTML query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }

render :: forall m. State -> H.ComponentHTML Action () m
render state = do
  let
    value = maybe "No number generated yet" show state
  HH.div_
    [ HH.h1_
        [ HH.text "random number" ]
    , HH.p_
        [ HH.text ("Current Value: " <> value) ]
    , HH.button
        [ HE.onClick \_ -> Just Regenerate ]
        [ HH.text "Generate New Number" ]
    ]

handleAction :: forall output m. MonadEffect m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Regenerate -> do
    newNumber <- H.liftEffect random
    H.modify_ \_ -> Just newNumber
