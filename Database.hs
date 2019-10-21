module Database where

import Data.Maybe
import Types

-- Prints the working dataset to the terminal.
-- db       the dataset as of this iteration
printDb :: [QA] -> IO ()
printDb db = do putStrLn (show db)

-- Looks up the query in the database to check
-- for a saved answer.
-- q        the parsed question
-- db       the hash table to look through
-- returns  the answer, if found
search :: Query -> [QA] -> Maybe String
search q db =
  foldr (\ e acc -> 
          if isJust acc then acc
          else if fst e == q then Just (snd e)
          else acc
        ) Nothing db

-- Saves or overwrites an answer in the database.
-- q            the corresponding question keywords
-- maybeInput   a possible new answer to this query
-- db           the database to modify
-- returns      the database, possibly updated
insert :: Query -> Maybe String -> [QA] -> [QA]
insert _ Nothing db = db
insert q (Just input) db = ((q, input):filteredList)
  where filteredList = filter (\ x -> (fst x) /= q) db

-- The database to use for searches, before any
-- user additions.
initialData :: [QA]
initialData = [
    (("what", "canada", "capital city"), "Ottawa"),
    (("what", "canada", "currency"), "Canadian Dollar (CAD)"),
    (("how many", "canada", "provinces"), "10 provinces"),
    (("what", "canada", "largest city"), "Toronto"),
    (("what", "canada", "population"), "37-38 million"),
    (("who", "canada", "prime minister"), "Justin Trudeau"),
    (("who", "canada", "monarch"), "Elizabeth II"),
    (("who", "canada", "governor general"), "Julie Payette"),
    (("when", "canada", "independence day"), "July 1"),
    (("what", "us", "capital city"), "Washington D.C."),
    (("what", "us", "currency"), "US Dollar (USD)"),
    (("how many", "us", "provinces"), "50 provinces"),
    (("what", "us", "largest city"), "Jacksonville"),
    (("what", "us", "population"), "327 million"),
    (("who", "us", "president"), "Donald Trump"),
    (("when", "us", "independence day"), "July 4")
  ]
