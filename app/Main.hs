module Main where

import System.Environment
import System.Exit
import System.IO (hSetBuffering, stdout, stderr, BufferMode (NoBuffering))

matchDigit :: Char -> String -> Bool
matchDigit _ [] = False
matchDigit char input
  | char=='d' = any (`elem` input) ['0'..'9']
  | otherwise =  elem char input

match_single_wildcards :: Char -> String ->Bool
match_single_wildcards wildcard input
  | wildcard=='d' =  matchDigit wildcard input
  | otherwise = False

matchPattern :: String -> String -> Bool
matchPattern pattern input
  | lp==1 = elem (head pattern) input
  | lp==2 && head pattern == '\\' = match_single_wildcards (last pattern) input
  | otherwise = error $ "Unhandled pattern: " ++ pattern
  where
    lp = length pattern

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
    else do if matchPattern pattern input_line
              then exitSuccess
              else exitFailure
