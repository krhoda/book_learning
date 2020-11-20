module Test.MySolutions where

import Prelude
import Data.AddressBook (Entry, AddressBook, findEntry)
import Data.List (filter, head, nubBy)
import Data.Maybe (Maybe(..))

-- Note to reader: Add your solutions to this file
findEntryByStreet :: String -> AddressBook -> Maybe Entry
findEntryByStreet address = head <<< filter filterStreetEntry
  where
  filterStreetEntry :: Entry -> Boolean
  -- for full address:
  -- filterStreetEntry entry = (AB.showAddress entry.address) == address
  filterStreetEntry entry = entry.address.street == address

isInBook :: String -> String -> AddressBook -> Boolean
isInBook firstname lastname book = case useFind of
  Nothing -> false
  Just _ -> true
  where
  useFind = findEntry firstname lastname book

removeDuplicates :: AddressBook -> AddressBook
removeDuplicates = nubBy nameTest
  where
  nameTest :: Entry -> Entry -> Boolean
  nameTest a b = a.firstName == b.firstName && a.lastName == b.lastName
