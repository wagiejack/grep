module Main where

import System.Environment
import System.Exit
import System.IO (hSetBuffering, stdout, stderr, BufferMode (NoBuffering))

match_single_wildcards :: Char -> Char ->Bool
match_single_wildcards wildcard input
  | wildcard=='d' = elem input ['0'..'9']
  | wildcard=='w' = elem input (['0'..'9']++['a'..'z']++['A'..'Z']++['_'])
  | otherwise = error $ "Unhandled single wildcard pattern: " ++ [wildcard]

matchPattern :: String -> Char -> Bool
matchPattern pattern input
  | lp==1 = elem input pattern
  | lp==2 && head pattern == '\\' = match_single_wildcards (last pattern) input
  | head pattern == '[' && last pattern == ']' = case pattern of 
                                                  ('[':'^':rest_of_pattern) -> notElem input (init rest_of_pattern)
                                                  _ -> elem input content_between_brackets
  | otherwise = error $ "Unhandled pattern: " ++ pattern
  where
    lp = length pattern
    content_between_brackets = (init (tail pattern))

matchPattern_string_anchor :: [String]->String->Bool
matchPattern_string_anchor [] [] = True
matchPattern_string_anchor [] _ = False
matchPattern_string_anchor _ [] = False
matchPattern_string_anchor patterns (input:rest_inputs) = (matchPattern (head patterns) input) && (matchPattern_string_anchor (tail patterns) rest_inputs)

-- we need one more level of abstraction between the first pattern matcher and the processor where
  -- if we have a \ then we also send the next character 
  -- if we have a [ then we send upto and including ]
  -- otherwise we send a single character for pattern matching, we can return false and the parent of this will take care

--we will have to send the same length of input as the pattern for matching, there are some specific changes of course
 -- if simple pattern or \ <something> then we can send single input
 -- if '[]' then we can send length pattern - 2 size of input and increment by the same for if else cases
 -- if ^something then we can send length of pattern -1 and increment accordingly the input processing for other cases
matchPattern_parent :: [String]->String->Bool
matchPattern_parent [] _ = True
matchPattern_parent _ [] = False
-- start of string anchor matching
matchPattern_parent (['^']:rest_of_pattern) input = matchPattern_string_anchor rest_of_pattern input
-- other matching
matchPattern_parent pattern input
  -- let 
  --   (input_to_be_sent, length_of_input_to_be_taken, match_input, no_match_input) = case head (head pattern) of 
  --                         '\\' ->  (take 1 input, 1, drop 1 input, drop 1 input)
  --                         '^'  -> (take (length pattern - 1) input , (length pattern) - 1, drop ((length pattern)-1) input, drop 1 input)
  --                         '[' -> (take (length pattern - 2) input , (length pattern) - 2, drop ((length pattern)-2) input, drop 1 input)
    | last pattern == "$" = matchPattern_string_anchor (init pattern) input
  -- in
    -- Now we match the first pattern with the input, if it's true we do the following
    -- Initiate matching of rest of the pattern w/ rest of the input
    -- Initiate matching of same pattern w/ rest of the input
    | matchPattern (head pattern) (head input) = matchPattern_parent (tail pattern) processed_input || matchPattern_parent pattern processed_input
    -- otherwise if the pattern has not matched then we keep the pattern and match the rest of the input
    | otherwise = matchPattern_parent pattern processed_input
      where 
        processed_input = tail input

--At the very modular level, we need to tokenize and collect the pattern tokens and invoke the parent matching function
tokenize_pattern :: String->[String]
tokenize_pattern [] = []
tokenize_pattern ('\\':character:rest) = [['\\',character]] ++ tokenize_pattern rest
tokenize_pattern ('^':rest) = ["^"] ++ tokenize_pattern rest
tokenize_pattern ('$':rest) = ["$"] ++ tokenize_pattern rest
tokenize_pattern pattern@('[':rest) = 
  let (before,after) = break (==']') pattern
      in case after of 
          [']'] ->[before ++ "]"]
          _ -> [before ++ "]"] ++ (tokenize_pattern (tail after) )
tokenize_pattern (first_char:rest) = [[first_char]] ++ (tokenize_pattern rest) 


tokenize_patterns_and_match :: String->String->Bool
tokenize_patterns_and_match _ [] = False
tokenize_patterns_and_match [] _ = False
tokenize_patterns_and_match pattern input = matchPattern_parent (tokenize_pattern pattern) input

main :: IO ()
main = do
  -- Disable output buffering
  hSetBuffering stdout NoBuffering
  hSetBuffering stderr NoBuffering

  args <- getArgs
  let pattern = args !! 1
  input_line <- getLine

  -- You can use print statements as follows for debugging, they'll be visible when running tests.
  -- hPutStrLn stderr "Logs from your program will appear here"

  -- Uncomment this block to pass stage 1
  if head args /= "-E"
    then do
      putStrLn "Expected first argument to be '-E'"
      exitFailure
    else do if tokenize_patterns_and_match pattern input_line
              then exitSuccess
              else exitFailure
