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
  | lp==1 = 
      case pattern of 
          "." -> True
          _  -> elem input pattern
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

matchPattern_zero_or_one :: [String]->String->Bool
matchPattern_zero_or_one [] []= True
matchPattern_zero_or_one [] _ = False
matchPattern_zero_or_one _ [] = False
matchPattern_zero_or_one pattern@(first_pattern:"?":rest_pattern) input@(first_input:rest_input)
  | matchPattern first_pattern first_input = matchPattern_parent rest_pattern rest_input
  | otherwise = matchPattern_parent rest_pattern input

matchPattern_one_or_more :: [String]->String->Bool
matchPattern_one_or_more [] []= True
matchPattern_one_or_more [] _ = False
matchPattern_one_or_more _ [] = False
-- second_pattern here is '+'
matchPattern_one_or_more pattern@(first_pattern:"+":rest_pattern) input@(first_input:rest_input)
  | matchPattern first_pattern first_input = matchPattern_one_or_more pattern rest_input || 
                                           matchPattern_parent rest_pattern rest_input ||
                                           matchPattern_parent pattern rest_input
  | otherwise = matchPattern_parent pattern rest_input

split_alternation_patterns :: String -> [String]
split_alternation_patterns "" = [""]
split_alternation_patterns pattern@(first_char:rest)
  | first_char=='|' = "" : split_alternation_patterns rest
  | otherwise = first_part : remaining_parts
    where
      (first_part, remaining) = break (=='|') pattern
      remaining_parts = if null remaining 
                        then [] 
                        else split_alternation_patterns (tail remaining)

match_splitted_patterns :: [String]-> [String] -> String ->Bool
match_splitted_patterns [] _ _ = False
match_splitted_patterns (first_possible_pattern:rest_possible_patterns) patterns input =
  matchPattern_parent ((tokenize_pattern first_possible_pattern) ++ patterns) input || 
  match_splitted_patterns rest_possible_patterns patterns input
  

matchPattern_parent :: [String]->String->Bool
matchPattern_parent [] [] = True
matchPattern_parent [] _ = True
matchPattern_parent _ [] = False
matchPattern_parent (['^']:rest_of_pattern) input = matchPattern_string_anchor rest_of_pattern input
matchPattern_parent pattern input
    | last pattern == "$" = matchPattern_string_anchor (init pattern) input
    | length pattern >=2 && second_pattern == "+" = matchPattern_one_or_more pattern input
    | length pattern >=2 && second_pattern == "?" = matchPattern_zero_or_one pattern input 
    | first_pattern_char=='(' && last_pattern_char==')' = let potential_patterns = split_alternation_patterns trimmed_patterns_for_alternation in
                                                            match_splitted_patterns potential_patterns (tail pattern) input 
    | matchPattern (head pattern) (head input) = matchPattern_parent (tail pattern) processed_input || matchPattern_parent pattern processed_input
    | otherwise = matchPattern_parent pattern processed_input
      where 
        processed_input = tail input
        second_pattern = head (tail pattern)
        first_pattern = head pattern
        first_pattern_char = head first_pattern
        last_pattern_char = last first_pattern
        trimmed_patterns_for_alternation = init (tail first_pattern)

tokenize_pattern :: String->[String]
tokenize_pattern [] = []
tokenize_pattern ('\\':character:rest) = [['\\',character]] ++ tokenize_pattern rest
tokenize_pattern pattern@(first_char:rest)
  | elem first_char ['^','$','+','?','.'] = [[first_char]] ++ tokenize_pattern rest
  | elem first_char ['[','('] = let (before,after) = break (==closing_char) pattern
                               in case after of 
                                    [closing_char] ->[before ++ [closing_char]]
                                    _ -> [before ++ [closing_char]] ++ (tokenize_pattern (tail after) )
  | otherwise = [[first_char]] ++ (tokenize_pattern rest) 
    where
      closing_char
        | first_char == '(' = ')'
        | otherwise = ']'

tokenize_patterns_and_match :: String->String->Bool
tokenize_patterns_and_match _ [] = False
tokenize_patterns_and_match [] _ = False
tokenize_patterns_and_match pattern input = matchPattern_parent patterns input
                                              where
                                                patterns = tokenize_pattern pattern

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  hSetBuffering stderr NoBuffering

  args <- getArgs
  let pattern = args !! 1
  input_line <- getLine
  if head args /= "-E"
    then do
      putStrLn "Expected first argument to be '-E'"
      exitFailure
    else do if tokenize_patterns_and_match pattern input_line
              then exitSuccess
              else exitFailure
