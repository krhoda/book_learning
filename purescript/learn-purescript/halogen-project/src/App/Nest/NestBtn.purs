module App.Nest.NestBtn where

import Halogen as H
import Halogen.HTML as HH

type Input
  = { label :: String }

type State
  = { label :: String }

button :: forall q o m. H.Component HH.HTML q Input o m
button =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval
    }
  where
  initialState :: Input -> State
  initialState input = input

  render :: forall a. State -> H.ComponentHTML a () m
  render { label } = HH.button [] [ HH.text label ]
