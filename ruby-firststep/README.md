# Ruby Programming for Everyone

- Ruby is an Object oriented programming language.

>[!TIP]
> Use `system "clear"` in the top of the script file to clear the screen everytime a script is executed.
> It will clear the teminal.

- [Ruby docs](https://ruby-doc.org/3.4.1/index.html)


## String Manipulation

- [class String](https://ruby-doc.org/3.4.1/String.html) this web page has all the string methods.


## Variables

- In Ruby variables are not explicitly *declared* with a keyword. It is created the moment first assign a value.
- Ruby uses dynamic typing; do not need to specify a data type for the variables.
- [variables](https://ruby-doc.org/docs/ruby-doc-bundle/UsersGuide/rg/variables.html)


### Variable Types and Naming Conventions

- The scope and type of a variable are determined by the first character of its name.
- **Local Variables**: Start with a lowercase letter or underscore (_). They are only accessible within the block, method, or class where they are defined.
    - `age = 25` or `_status = "active"`
- **Instance Variables**: Start with a single "at" symbol (@). These belong to a specific instance of an object and are shared across all methods within that object.
    - `@name = "Alice"`
- **Class Variables**: Start with double "at" symbols (@@). These are shared among all instances of a class and its descendants.
    - `@@user_count = 0`
- **Global Variables**: Start with a dollar sign ($). These can be accessed from anywhere in the Ruby program, though their use is generally discouraged to avoid side effects.
    - `$system_mode = "production"`
- **Constants**: Start with an uppercase letter. While they can technically be changed, Ruby will issue a warning if you reassign a value to a constant.
    - `PI = 3.14159`


### Key Behavior

- *Automatic Initialization*: Uninitialized instance and global variables return nil rather than throwing an error.
- *Strict Locals*: Referring to an uninitialized local variable will raise a NameError because Ruby interprets it as a method call.
- *Reassignment*: You can change the value and even the data type of a variable at any time.
    - `x = 10; x = "now a string"`


## Write Data to std output

| Method | Newline at End? | Array Behavior | Best Use Case |
| ---- | ---- | ---- | ---- |
| `puts` | Yes | Prints each element on a new line | Standard user-facing output. |
| `print` | No | Prints the raw array (e.g., [1, 2, 3]) | Sequential output on the same line. |
| `p` | Yes	| Prints raw structure (with quotes/brackets) | Debugging; shows the actual object. |


## User Input

- Use `gets` method to get user input.
- [user_input](./user_input.rb)


## Arithmatic Operators

- Integer operations always return integers.
- If one of them is a float the return will be a float.
- Use `.to_i` to convert to an Integer.
- Use `.to_f` to convert to a Float.
- Use `.to_s` to convert to a String.
