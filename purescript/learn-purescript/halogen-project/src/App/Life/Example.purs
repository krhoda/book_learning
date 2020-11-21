module App.Life.Example where

import Prelude
import Data.Maybe (Maybe(..), maybe)
import Effect.Class (class MonadEffect)
import Effect.Class.Console (log)
import Effect.Random (random)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

data Action
  = Initialize
  | Regenerate
  | Finalize

type State
  = Maybe Number

initialState :: forall i. i -> State
initialState _ = Nothing

component :: forall query input output m. MonadEffect m => H.Component HH.HTML query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = Just Initialize
              , finalize = Just Finalize
              }
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
  Initialize -> do
    handleAction Regenerate
    newNumber <- H.get
    log ("Initialized: " <> show newNumber)
  Regenerate -> do
    newNumber <- H.liftEffect random
    H.modify_ \_ -> Just newNumber
  Finalize -> do
    number <- H.get
    log ("Finalized! Last Number was: " <> show number)