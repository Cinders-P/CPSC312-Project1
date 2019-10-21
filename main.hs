import Data.Maybe

import Types
import Database
import Parser
import InputReader

-- Entry point to the program.
start :: IO ()
start = do
  putStrLn "\n*** Welcome to GeoBot. ***"
  putStrLn "You can ask me basic questions about the US & Canada"
  putStrLn "like 'What is the largest city in Canada?'"
  putStrLn "or you can submit blank to quit."
  loop initialData

-- Main program loop which calls itself recursively after
-- each question and answer, until the user exits.
-- db        list of known answers to queries
loop :: [QA] -> IO ()
loop db = do
  r <- ask "What would you like to know?"
  if isQuitCmd r then return ()
  else if isDbCmd r then do { printDb db; loop db }
  else do
    case (parse r) of
      Nothing -> do
        putStrLn "Sorry, I didn't understand your question."
        loop db
      Just query -> do
        nextDb <- respondToQuery query db
        loop nextDb
  where
    isQuitCmd r = r == "" || r == "quit" || r == "q"
    isDbCmd r = r == "db"

-- The part of the system that responds to the valid
-- query and updates the dataset with the user response.
-- q              the user question in parsed format
-- db             hash table to lookup the query in
-- returns        the dataset, possibly edited
respondToQuery :: Query -> [QA] -> IO [QA]
respondToQuery q db = do
  let lookupResult = search q db
  maybeNewAnswer <- answer lookupResult
  return (insert q maybeNewAnswer db)

-- Prints out the search result and optionally
-- gets user input for this query.
-- maybeResult      maybe an answer to the query
-- returns          maybe a new answer to save
answer :: Maybe String -> IO (Maybe String) 
answer Nothing = promptMaybeInput
  "Hm. I don't have the answer to that."
  "Would you like to save an answer for this question? "
answer (Just result) = promptMaybeInput
  ("My data tells me it is " ++ result ++ ".")
  "Would you like to overwrite my answer? "
