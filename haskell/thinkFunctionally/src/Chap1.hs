module Chap1 where

import qualified Data.Char as Char
import qualified Data.List as List
import qualified Data.Map  as Map

-- TODO: Impl commonWords
-- commonWords :: Int -> [Char] -> [Char]
-- commonWords n =
--   concat .
--   map showRun . take n . sortRuns . countRuns . sortWords . words . map toLower
units, teens, tens :: [String]
units =
  [ "zero"
  , "one"
  , "two"
  , "three"
  , "four"
  , "five"
  , "six"
  , "seven"
  , "eight"
  , "nine"
  ]

teens =
  [ "ten"
  , "eleven"
  , "twelve"
  , "thirteen"
  , "fourteen"
  , "fifteen"
  , "sixteen"
  , "seventeen"
  , "eighteen"
  , "nineteen"
  ]

tens =
  [ "twenty"
  , "thirty"
  , "fourty"
  , "fifty"
  , "sixty"
  , "seventy"
  , "eighty"
  , "ninety"
  ]

convert1 :: Int -> String
convert1 n = units !! n

-- As written in text book, had a HC denominator. Seems silly.
digits2 :: Int -> Int -> (Int, Int)
digits2 n d = (div n d, mod n d)

combine2 :: Int -> Int -> String
combine2 0 n = units !! n
combine2 1 n = teens !! n
combine2 m 0 = tens !! (m - 2)
combine2 m n = tens !! (m - 2) ++ "-" ++ units !! n

-- Silly me thought to do this frst, which is valid, but pointful
-- the typechecker complains about not using uncurry. Why?
-- convert2 n = combine2 (fst x) (snd x)
--   where
--     x = digits2 n 10
convert2 :: Int -> String
convert2 = uncurry combine2 . flip digits2 10

convert3 :: Int -> String
convert3 n
  | h == 0 = convert2 t
  | t == 0 = units !! h ++ " hundred"
  | otherwise = units !! h ++ " hundred and " ++ convert2 t
  where
    (h, t) = digits2 n 100

link :: Int -> String
link i
  | i < 100 = " and "
  | otherwise = ""

convertThousands :: Int -> String
convertThousands n
  | t == 0 = convert3 h
  | h == 0 = convert3 t ++ " thousand"
  | otherwise = convert3 t ++ " thousand " ++ link h ++ convert3 h
  where
    (t, h) = digits2 n 1000

-- anagrams takes a string and constructs an anagram dictionary page out of them.
anagrams :: String -> Map.Map String [String]
anagrams input = anagramsInner (words (map Char.toLower input)) Map.empty

anagramsInner :: [String] -> Map.Map String [String] -> Map.Map String [String]
anagramsInner [] m = m
anagramsInner (x:xs) m = anagramsInner xs next
  where
    (_, next) = Map.insertLookupWithKey anagramInsert (List.sort x) [x] m

-- anagramInsert ignores it's first arg to meet the needs of insertLookupWithKey
anagramInsert :: String -> [String] -> [String] -> [String]
anagramInsert _ new old = new ++ old

testStr :: [Char]
testStr = "The gods of dogs made dame rats a star"

songPrefix :: Int -> String
songPrefix 1 = "One man went to mow\nWent to mow a meadow\n"
songPrefix x =
  capitalize1 $ convert2 x ++ " men went to mow\nWent to mow a meadow\n"

songSuffix :: Int -> String
songSuffix x = rf x []
  where
    rf :: Int -> String -> String
    rf 1 s = s ++ "one man and his dog,\nWent to mow a meadow\n"
    rf i s = rf (i - 1) (s ++ convert2 i ++ " men, ")

song :: Int -> String
song x
  | x < 1 =
    "Imaginary song detected! Please enter a positive number between 1 and 1000"
  | x > 999 = "Too large of song requested."
  | otherwise = songInner x []
  where
    songInner :: Int -> String -> String
    songInner 0 s = s
    songInner i s = verse ++ songInner (i-1) s
      where
        verse = (songPrefix i ++ capitalize1 (songSuffix i)) ++ s 


capitalize1 :: String -> String
capitalize1 [] = []
capitalize1 (x:xs) = Char.toUpper x : xs
