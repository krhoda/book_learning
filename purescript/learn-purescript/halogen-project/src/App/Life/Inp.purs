module App.Life.Inp where

import Prelude
import Control.Monad.Rec.Class (forever)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect.Aff (Milliseconds(..))
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff)
import Effect.Exception (error)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Query.EventSource as EventSource

type Slots
  = ( button :: forall q. H.Slot q Void Unit )

_button = SProxy :: SProxy "button"

type ParentState
  = { count :: Int }

data ParentAction
  = Initialize
  | Increment

component :: forall q i o m. MonadAff m => H.Component HH.HTML q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = Just Initialize
              }
    }
  where
  initialState :: i -> ParentState
  initialState _ = { count: 0 }

  render :: ParentState -> H.ComponentHTML ParentAction Slots m
  render { count } = HH.div_ [ HH.slot _button unit button { label: show count } absurd ]

  handleAction :: ParentAction -> H.HalogenM ParentState ParentAction Slots o m Unit
  handleAction = case _ of
    Initialize -> do
      void $ H.subscribe
        $ EventSource.affEventSource \emitter -> do
            fiber <-
              Aff.forkAff
                $ forever do
                    Aff.delay $ Milliseconds 1000.0
                    EventSource.emit emitter Increment
            pure
              $ EventSource.Finalizer do
                  Aff.killFiber (error "Event source finalized") fiber
    Increment -> 
      H.modify_ \st -> st { count = st.count + 1 }


type ButtonInput
  = { label :: String }

type ButtonState
  = { label :: String }

data ButtonAction
  = Receive ButtonInput

button :: forall q o m. H.Component HH.HTML q ButtonInput o m
button =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , receive = Just <<< Receive
              }
    }
  where
  initialState :: ButtonInput -> ButtonState
  initialState { label } = { label }

  render :: forall a. ButtonState -> H.ComponentHTML a () m
  render { label } = HH.button_ [ HH.text label ]

  handleAction :: ButtonAction -> H.HalogenM ButtonState ButtonAction () o m Unit
  handleAction = case _ of
    Receive input -> H.modify_ _ { label = input.label }
