module InputReader (ask, promptMaybeInput) where

import Data.Maybe
import Data.Char

-- A question and answer IO, encapsulated.
-- q          question to print
-- returns    sanitized user response
ask :: String -> IO String
ask q = do
  putStrLn ('\n':q)
  line <- getLine
  return (strToLower (strFilterDel line))

-- Generates a boolean from user input.
getYesNo :: IO Bool
getYesNo = do
  line <- getLine
  let l = strToLower (strFilterDel line)
  return (l == "yes" || l == "y") 

-- Possibly reads a line from the user. Note that
-- this read is not lowercased like the other getLine usages.
-- shouldAddAnswer    whether the user wanted to save a response
-- returns            maybe a line of input
getMaybeInput :: Bool -> IO (Maybe String)
getMaybeInput shouldAddAnswer
  | shouldAddAnswer = do
      putStr "Input answer: "
      line <- getLine
      putStrLn "Answer saved!"
      return (Just (strFilterDel line))
  | otherwise = do return Nothing

-- Informs the user and asks if they want to
-- save a response, getting the input if so.
-- msg        information for the user
-- prompt     a yes-no question
-- returns    maybe an answer if they choose to provide one
promptMaybeInput :: String -> String -> IO (Maybe String)
promptMaybeInput msg prompt = do
  putStrLn msg
  putStr prompt
  shouldAddAnswer <- getYesNo
  getMaybeInput shouldAddAnswer

-- Changes the String to all lowercase characters
-- str        String to manipulate
-- returns    str using only lowercase characters
strToLower :: String -> String
strToLower str = [toLower c|c <- str]

-- Applies backspaces to the input String.
-- str      unsanitized string
-- returns  string without bksp or deleted characters
strFilterDel :: String -> String
strFilterDel str = snd 
  (foldr
    (\ char (delCount, str) ->
      if char == '\DEL' then (delCount+1, str)
      else if delCount > 0 then (delCount-1, str)
      else (delCount, char:str))
    (0, "")
    str)
