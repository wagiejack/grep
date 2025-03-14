# 🤯 Oh Boy! You implemented the entire Grep like a based Boi?

No 

![image](https://github.com/user-attachments/assets/96d57077-83a0-4bb3-b7b2-21d8d079c02d)

This is a toy grep functionality implemented for learning **`Hasal, Haskal, Haskal, Haskal`**

At the time of writing this code, I only have knowledge upto Higher order functions, not the intimidating stuff (functors and Monads) so the implementation of Grep is pretty basic

[Codecrafters link for the challenge](https://app.codecrafters.io/courses/grep/stages/).

# :suspect: Is it Gud?

Even this version constructed with the lack of skilled Haskal, Haskal, Haskal, Haskal is just `128 LOC` (80 akshually) and ik that is not always a indicator of good code but rather a signal that some undreadable clusterfuck has been made,

But truly, with my limited knowledge, this is pretty straightforward and easy to understand and with other languages (okay i expected those numbers to be way more) it would still be a bit...eh....clusterfucked (for the lack of better words or a reflection of my master over other langs)

<img width="779" alt="image" src="https://github.com/user-attachments/assets/d6f93ce8-14dc-4abf-a4b6-7496ba10b3c6" />

# 🚨 Did it pass Codecrafters tests

This passed all the code-crafters tests except the additional ones 

https://github.com/user-attachments/assets/5d9970b9-cc1c-4a52-9070-4f78f44da457

Before you throw a Gotcha, Ik it fails, but it fails at the additional tests and passes the basic ones 

<img width="294" alt="image" src="https://github.com/user-attachments/assets/e2229b46-94d0-42f9-94c1-6eb0c1c6cee2" />

# 📌 Features (We all know its summarized with LLM so...yeah)

Here's the regex matcher features in a markdown table:

| Feature | Syntax | Description |
|---------|--------|-------------|
| Single wildcards | `\d` | Matches any digit (0-9) |
| | `\w` | Matches any word character (alphanumeric + underscore) |
| Character classes | `[abc]` | Matches any character in the set (e.g., 'a', 'b', or 'c') |
| | `[^abc]` | Matches any character not in the set |
| Anchors | `^` | Matches the start of the string |
| | `$` | Matches the end of the string |
| Quantifiers | `+` | Matches one or more of the preceding pattern |
| | `?` | Matches zero or one of the preceding pattern |
| Alternation | `(a\|b)` | Matches either 'a' or 'b' |
| Dot (.) | `.` | Matches any single character |

# 📋 Kay, how do I run it tho

Tbh, easiest way is to install [ghc](https://www.haskell.org/downloads/), navigate to /app and run `ghci` and run the command `:l Main.hs` which will load the file up

LLM summarized instructions below btw
- Install Stack:  
- Download and install Stack from the official guide.  
- Ensure Git is installed for cloning the repository (Windows users can use Git for Windows, macOS/Linux often have it pre-installed). 
- Use git clone https://github.com/wagiejack/grep, replacing the URL with your repository's address.
- Open your terminal or command prompt and navigate to the cloned directory. 
- Run stack build to compile the code. 
- Execute with stack exec your-package-name -E "<pattern>" "<input>", replacing your-package-name with the package name from package.yaml.  

Alternatively, on Unix-like systems (macOS, Linux), run ./your_program.sh if available. For Windows, use Git Bash or WSL to run the script.

# 🙌 Thanks for Visiting

![wrote haskal award](https://github.com/user-attachments/assets/e3371255-a658-45f4-8b69-b434367ff662)
