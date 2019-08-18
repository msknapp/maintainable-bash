
# How to Keep Bash Code Maintainable

1.  Encapsulate code in functions.  This helps isolate it so you have more reliable results.
    - use #!/usr/bin/env bash
    - check bash version (supports arrays?)
2.  Limit use of export and global environment variables.
3.  Use named parameters everywhere, avoid positional parameters.
13. Check your assumptions in the code.  Exit early if they are not met.
    - confirm that arguments are all set.  Assign defaults where possible.  Exit early if
      a value is mandatory and there is no default.
    - confirm that software is installed using which.
    - Confirm that files exist beforehand.
22. Make code idempotent as much as possible.
x.  Make your code readable using aliases like "alias keep_rows_containing=grep"
9.  Use return to deliver status of your function.
10. Prefer to check the return status of functions you call.
15. Use default values, or lookup values, if the user did not provide them.  Fall back to
    using environment variables as a last resort.
6.  Avoid specifying a log file in functions, let higher level functions decide on that.
    Instead, make use of std out and err.
4.  Add a help parameter to every function.
12. Help documents should declare assumptions and pre-conditions.
5.  Add a --debug, --dry-run, --verbose, --source, etc. to each function.
7.  Use std out to return values.  If your function does not return a value, then you may use
    std out as your log.
8.  Use std err as a log.
11. If you want a function to return multiple values or an object, just return a json document as text.
17. Prefer placing commands onto the common path instead of placing them into .bashrc or .bash_profile.
18. Use .bashrc or .bash_profile for functions that must alter your global environment variables.
19. Prefer functions over aliases.
20. Use an IDE with color/context highlighting.  Intellij with plugin, or vi with colors on.
23. Instead of using an argument, prefer to lookup a value from the source.
24. Prefer to use long-named commands and parameters for readability by peers.  It also depends
    less on your memory.
16. Strongly prefer to automate and script everything.
14. Avoid prompting for input.
21. Avoid having too much code in one file.

The only thing worse than "code without documentation" is "documentation without code".  All too often I see
confluent pages that have command line

# Bash tricks:
* return text without worrying about escaping quotes or back slashes: here documents.
* Using awk to select one column.
* Removing blank lines in results.
* Check if a function was successful.
* Select a sub-string
* Process one line at a time, not one word/token at a time.
* Use curl
  - encoding arguments with special characters
  - passing basic auth credentials.
* Using jq to select a few columns.
* Using cut
* regex matching
* printing to standard error.
* accepting multiple values for a parameter
* Having a parent function that routes to sub-functions.
* Short method of if then
* Turn colors on in vi
* joining strings into one.
* do simple integer math.
* format json
* filters depending on an argument.
* remove quotes from text.
* Avoiding passwords in scripts.

# Common Anti-Patterns:
* Using echo on repeated lines instead of a here document.
* Not using functions.
* Using global variables and export to pass around arguments.
* Excessive use of if-then-fi
* Code Lines that are very long instead of using \ and wrapping them.
* Excessively using wc -l in if statements.
* Not using local for variables
* Excessive use of $?
* Trying to count something, but it's in a sub-shell because you used a pipe.
* hard coding values
* Not putting scripts on your path.
* copying/pasting instead of re-using code.
* Not putting quotes around variables.
* Using positional parameters instead of named ones.
* commands that write out to a log file.
* excessive use of sudo.
* not supporting multiple operating systems.
* Not checking if a command worked.
* Not formatting output
* passwords in code.
* redundant code, instead of making functions.
* Not designing code to be easier to test and debug.
* Not designing code to let people manually run individual pieces.
* picket fences in sed.
* chmod 777
* sourcing other scripts instead of putting them on the path.
* cat <file> | or echo <text> |
* lack of comments and/or documentation.
* Not knowing about CLI commands and/or their options.
* Not switching to a higher language for complicated things.
* repeated use of elif instead of a case statement.
* Writing code that only works on your computer, or only one computer (like a build server).