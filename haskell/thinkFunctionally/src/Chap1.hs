module Chap1 where
import qualified Data.Map as Map
import qualified Data.List as List
import qualified Data.Char as Char

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

convert2 :: Int -> String
convert2 n = combine2 (fst x) (snd x)
  where
    x = digits2 n 10

convert3 :: Int -> String
convert3 n  
    | h==0 = convert2 t
    | t==0 = units !! h ++ " hundred"
    | otherwise = units !! h ++ " hundred and " ++ convert2 t
    where (h, t) = digits2 n 100

link :: Int -> String
link i 
    | i<100 = " and "
    | otherwise = ""

convertThousands :: Int -> String
convertThousands n
    | t==0 = convert3 h
    | h==0 = convert3 t ++ " thousand"
    | otherwise = convert3 t ++ " thousand " ++ link h ++ convert3 h
    where (t, h) = digits2 n 1000 


-- anagrams takes a string and constructs an anagram dictionary page out of them.
anagrams :: String -> Map.Map String [String]
anagrams input = anagramsInner (words  (map Char.toLower input)) Map.empty

anagramsInner :: [String] -> Map.Map String [String] -> Map.Map String [String]
anagramsInner [] m = m
anagramsInner (x:xs) m = anagramsInner xs next
  where (_, next) =  Map.insertLookupWithKey anagramInsert (List.sort x) [x] m

anagramInsert :: String -> [String] -> [String] -> [String]
anagramInsert _ new old = new ++ old

testStr :: [Char]
testStr = "The gods of dogs made dame rats a star"