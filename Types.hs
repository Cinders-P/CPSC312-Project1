module Types where

-- Represents a parsed question. We choose
-- a 3-keyword format instead of arbitrarily
-- lengthed questions because of the questions
-- we came up with while brainstorming, they were
-- most commonly of this format. Provides a hard
-- line for the scope of the project as well.
type Query = (String, String, String)

-- A question and answer pair. Our database
-- is stored as a hash table for easy lookup,
-- since the questions are of a standard format.
-- It also makes it easy to read while debugging
-- with the "db" print command.
type QA = (Query, String)
