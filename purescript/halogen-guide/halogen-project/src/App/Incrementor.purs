module App.Incrementor where

import Prelude

import Data.Maybe (Maybe(..))

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

type State
  = Int

data IncAction
  = Inc
  | Dec

component :: forall query input output m. H.Component HH.HTML query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

initialState :: forall input. input -> State
initialState _ = 0

render :: forall m. State -> H.ComponentHTML IncAction () m
render state =
  HH.div_
    [ HH.button [ HE.onClick \_ -> Just Dec ] [ HH.text "-" ]
    , HH.text $ show state
    , HH.button [ HE.onClick \_ -> Just Inc ] [ HH.text "+" ]
    ]

handleAction :: forall o m. IncAction -> H.HalogenM State IncAction () o m Unit
handleAction = case _ of
    Dec -> 
        H.modify_ \state -> state - 1
    Inc ->
        H.modify_ \state -> state + 1