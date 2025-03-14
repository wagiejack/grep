## when do we go back to the parent function? 

We have to keep in mind that this is 0 or 1 so we can forgive this matching and go forward with the rest of the pattern or we can shift one of the input if we are accomodating this, we cannot shift infinite inputs like we did with one or more. In case of a no-match, we can skip this pattern and go to the parent function for rest of the pattern with the same input. So boling down the cases we have
  -- in case of a match
  -- next pattern next input(parent)
  -- in case of no match
  -- next pattern same input (parent)

-- at one point, when we have moved on from this mathcing, we want to return to matchPattern_parent for the matching to continue normal matching
-- when do we go back to the parent function? We do a match, we do two things
 -- same pattern next input
 -- next pattern next input (pass to parent)
 -- same pattern next input (pass to parent)
-- in case of no match  
 --same pattern same input (pass to parent)

## Abstracting 

-- we need one more level of abstraction between the first pattern matcher and the processor where
  -- if we have a \ then we also send the next character 
  -- if we have a [ then we send upto and including ]
  -- otherwise we send a single character for pattern matching, we can return false and the parent of this will take care

--we will have to send the same length of input as the pattern for matching, there are some specific changes of course
 -- if simple pattern or \ <something> then we can send single input
 -- if '[]' then we can send length pattern - 2 size of input and increment by the same for if else cases
 -- if ^something then we can send length of pattern -1 and increment accordingly the input processing for other cases

 -- now to introduce alternation, we are capturing the pattern as (<a>|<b>), what we can do is when we enounter this, we can tokenize <a> and allocate it with rest of the pattern and fire up the match pattern, we can also tokenize <b> and allocate it with rest of the pattern and fire up the pattern, this would inroduce no other changes or introduce any other function and would also help in achieving the functionality so to summarize, we can do
  -- On ecountering pattern token divided by (), pass it into a function that separates by "|" and return a [String] so, String->[String]
  -- The [String] obtained are the possible patterns, what we want to do is we want to tokenize this and attach it to the rest of the pattern and send the same input to matchPattern_parent and we want the result to be a OR of all the possible patterns

## Misc pattern matching notes

  -- let 
  --   (input_to_be_sent, length_of_input_to_be_taken, match_input, no_match_input) = case head (head pattern) of 
  --                         '\\' ->  (take 1 input, 1, drop 1 input, drop 1 input)
  --                         '^'  -> (take (length pattern - 1) input , (length pattern) - 1, drop ((length pattern)-1) input, drop 1 input)
  --                         '[' -> (take (length pattern - 2) input , (length pattern) - 2, drop ((length pattern)-2) input, drop 1 input)