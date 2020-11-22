module Main where

import Prelude
import Control.Coroutine as CR
import Data.Array as Array
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI component unit body
    let
      logMessage str = void $ io.query $ H.tell $ AppendMessage str
    io.subscribe
      $ CR.consumer \(Toggled newState) -> do
          logMessage $ "Button was internally toggled to: " <> show newState
          pure Nothing
    state0 <- io.query $ H.request IsOn
    logMessage $ "The button state is now: " <> show state0
    _ <- io.query $ H.tell $ SetEnabled true
    state1 <- io.query $ H.request IsOn
    logMessage $ "The button state is now: " <> show state1
    _ <- io.query $ H.tell $ SetEnabled false
    state2 <- io.query $ H.request IsOn
    logMessage $ "The button state is now: " <> show state2

data Query a
  = IsOn (Boolean -> a)
  | SetEnabled Boolean a
  | AppendMessage String a

data Output
  = Toggled Boolean

data Action
  = Toggle

type State
  = { enabled :: Boolean, messages :: Array String }

component :: forall input m. H.Component HH.HTML Query input Output m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , handleQuery = handleQuery
              }
    }
  where
  initialState :: input -> State
  initialState _ = { enabled: false, messages: [] }

  render :: State -> H.ComponentHTML Action () m
  render state =
    HH.div_
      [ HH.div_ (map (\str -> HH.p_ [ HH.text str ]) state.messages)
      , HH.button
          [ HE.onClick \_ -> Just Toggle ]
          [ HH.text $ if state.enabled then "On" else "Off" ]
      ]

  handleAction :: Action -> H.HalogenM State Action () Output m Unit
  handleAction = case _ of
    Toggle -> do
      newState <- H.modify \st -> st { enabled = not st.enabled }
      H.raise (Toggled newState.enabled)

  handleQuery :: forall a. Query a -> H.HalogenM State Action () Output m (Maybe a)
  handleQuery = case _ of
    IsOn reply -> do
      enabled <- H.gets _.enabled
      pure (Just (reply enabled))
    SetEnabled enabled a -> do
      H.modify_ _ { enabled = enabled }
      pure (Just a)
    AppendMessage str a -> do
      H.modify_ \st -> st { messages = Array.snoc st.messages str }
      pure (Just a)
