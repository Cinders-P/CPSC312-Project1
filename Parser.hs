module Parser (parse) where

import Types
import Data.Char

-- The only exported function. Converts user
-- question into Query format, if it is valid.
-- str      the question
-- returns  a query, if parsable
parse :: String -> Maybe Query
parse str =
  if isValid keywords
    then do
      let a:b:c:rest = keywords
      Just (a,b,c)
    else Nothing
  where keywords = getKeywords str

-- Predicate for accepted quesiton format.
-- lst      list of keywords found by parser
-- returns  whether the keywords fit question
--          criteria for the chatbot
isValid :: [String] -> Bool
isValid lst = length lst == 3

-- Reads a list of important words from a string.
-- str      question string
-- returns  ordered list of identifying keywords
getKeywords :: String -> [String]
getKeywords str = usa (orderfst (removedup (delspace (theremoves (delspace (splitwstr (delpunc str)))))))

-- splitsep separates a list of elements into a list of list of elements by the given separator
splitsep :: (a -> Bool) -> [a] -> [[a]]
splitsep fn [] = [[]]
splitsep fn (h:t) =
    if fn h
       then ([]: splitsep fn t)
       else ((h:i):rest)
            where i:rest = splitsep fn t

-- filterwords filter a list of list of elements
filterwords :: (Eq a) => [[a]] -> [[a]] -> [[a]]
filterwords [] lst = lst
filterwords _ [] = []
filterwords removelst lst = filter (flip notElem removelst) lst
-- filterwords ["There", "is", "store"] ["There", "is", "the", "book", "store"]
-- output ["the","book"]

-- sepwords splits a string into list of list of elements and removing empty elements from the list
sepwords :: [Char] -> [[Char]]
sepwords [] = [[]]
sepwords lst = filterwords [" ",""] (splitsep (flip elem " ,.?!:;@#$%&/'") lst)
-- sepwords "What? is this thing? ... called Love."
-- output ["What","is","this","thing","called","Love"]

-- delpunc deletes any punctuation in the list of elements
delpunc :: [Char] -> [Char]
delpunc [] = []
delpunc (h:t) =
    if (flip elem ",.?!:;@#$%&/") h
       then (delpunc t)
       else (h : delpunc t)
-- delpunc "What? is this thing? ... called Love."
-- output "What is this thing  called Love"

-- splitwstr split list of elements by a specific word
splitwstr :: [Char] -> [[Char]]
splitwstr "" = [[]]
splitwstr lst = func lst [[]]
    where
        func [] z = reverse $ map (reverse) z
        func (y:ys) (z:zs) = if (take 3 (y:ys)) `elem` [" is", " of", "'s ", " in"] then
            func (drop 3 (y:ys)) ([]:(z:zs))
        else
            func ys ((y:z):zs)
-- splitwstr "What is this thing is called is Love"
-- output ["What"," this thing"," called"," Love"]

-- lowcase lowercased all the words in the list of list of elements
lowcase :: [[Char]] -> [[Char]]
lowcase [] = []
lowcase lst = map fn lst
        where
             fn word = map toLower word
-- lowcase ["What","this thing","called","Love"]
-- output ["what","this thing","called","love"]

-- delspace delete extra space in the list of words
delspace :: [[Char]] -> [[Char]]
delspace [] = []
delspace lst = map trim lst
-- delspace ["what   ","  this     thing  ","  called","love   "]
-- output ["what","this     thing","called","love"]

-- trim delete extra space in a word
trim xs = dropspace "" $ dropWhile isSpace xs
dropspace word "" = ""
dropspace word (x:xs)
        | isSpace x = dropspace (x:word) xs
        | null word = x : dropspace "" xs
        | otherwise       = reverse word ++ x : dropspace "" xs
-- trim "   what  "
-- output "what"

filword1 :: [[Char]] -> [[Char]]
filword1 [] = []
filword1 lst = filter (`notElem` keywords) lst
          where
              keywords = ["is","the","of","this","in"]

-- filword delete extra unneeded words in the list of words
filword :: [[Char]] -> [[Char]]
filword [] = []
filword lst = filter (`elem` keywords) lst
          where
              keywords = ["what","who","when","how many"
                          ,"canada","us","population","currency"
                          ,"largest city","capital city","prime minister","president"
                          ,"monarch","governor general","independence day"
                          ,"province","territory"]
-- filword ["what","asd","hias","governor general"]
-- output ["what","governor general"]

-- orderfst order the filtered list of words
orderfst :: [[Char]] -> [[Char]]
orderfst [] = []
orderfst (x:xs) = if x `elem` ["what","who","when","how many"]
                     then x: (orderscnd xs)
                     else orderfst (xs) ++ [x]
orderscnd :: [[Char]] -> [[Char]]
orderscnd [] = []
orderscnd (x:xs) = if x `elem` ["us","canada","united states"]
                     then x:xs
                     else orderscnd (xs) ++ [x]
-- orderfst ["canada","governor general","what"]
-- output ["what","canada","governor general"]

-- checkqmark to check whether the input is a question or not
checkqmark :: [Char] -> Bool
checkqmark lst = (last lst) `elem` "?"
-- checkqmark "What is ?"
-- output True

-- checkelem to check whether the ordered list of words has exactly 3 keywords needed
checkelem :: [[Char]] -> Bool
checkelem lst = length lst == 3
-- checkelem ["canada","governor general","what"]
-- output True

--theremoves removes s from every words on the list to sanitize it
theremoves :: [[Char]] -> [[Char]]
theremoves [] = []
theremoves (x:xs) =
         if (x == "us")
            then [x] ++ (theremoves xs)
            else [theremove x] ++ (theremoves xs)
-- theremoves ["the what", "the canada"]
-- output [" what", " canada"]

theremove :: [Char] -> [Char]
theremove "" = ""
theremove str = if (take 3 str) == "the"
                 then (drop 3 str)
                 else str

-- removedup remove duplicated on the list keeping the first occurences
removedup :: [[Char]] -> [[Char]]
removedup lst = remdupfirst lst []
    where
        remdupfirst [] _ = []
        remdupfirst (h:t) lst2
            | h `elem` lst2 = remdupfirst t lst2
            | otherwise     = h : remdupfirst t (h:lst2)

-- usa convert "united states" to "us"
usa :: [[Char]] -> [[Char]]
usa [] = []
usa (x:xs) =
       if (x == "united states")
          then ["us"] ++ (usa xs)
          else [x] ++ (usa xs)
