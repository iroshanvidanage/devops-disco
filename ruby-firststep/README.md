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


## Comparison Operators

- `==` (Equal To): Returns true if operands are equal in value. It does not perform type coercion (e.g., 4 == "4" is false).
- `!=` (Not Equal To): Returns true if operands are not equal in value.
- `>` (Greater Than): Returns true if the left operand is greater than the right.
- `<` (Less Than): Returns true if the left operand is less than the right.
- `>=` (Greater Than or Equal To): Returns true if the left operand is greater than or equal to the right.
- `<=` (Less Than or Equal To): Returns true if the left operand is less than or equal to the right. 


### Special Comparison Operators

- `<=>` (Spaceship Operator): Used for sorting. Returns -1 (*less than*), 0 (*equal*), or 1 (*greater than*). It returns *nil* if the objects are not comparable.
- `===` (Case Equality): Used commonly in case statements to determine if a value matches a pattern.
- `.eql?` (Type and Value): Returns true only if both operands have the same type and equal values (e.g., 1.eql? 1.0 is false).
- `.equal?` (Object Identity): Returns true if both operands are the exact same object in memory.


## Assignment Operators

- `+=` (*Add and Assign*): `a += b` is shorthand for `a = a + b`
- `-=` (*Subtract and Assign*): `a -= b` is shorthand for `a = a - b`
- `*=` (*Multiply and Assign*): `a *= b` is shorthand for `a = a * b`
- `/=` (*Divide and Assign*): `a /= b` is shorthand for `a = a / b`
- `%=` (*Modulus and Assign*): `a %= b` is shorthand for `a = a % b`
- `**=` (*Exponent and Assign*): `a **= b` is shorthand for `a = a ** b`


### Advance Assignment

- **Parallel Assignment**: Assigns multiple values to multiple variables in one line.
```bash
a, b = 10, 20
# a = 10, b = 20
```
- **Splat Operator (`*`)**: Used in parallel assignment to collect multiple values into an array.
```bash
a, *b = 1, 2, 3 # a = 1, b = [2, 3]
```
- **Conditional Assignment** (`||=`): Assigns a value only if the variable is currently `nil` or `false`.
```bash
name ||= "Guest" # Sets name to "Guest" if it was previously undefined or nil
```


## Conditional Statements

### Primary Conditional Statements

- **If/Elsif/Else:** Evaluates conditions in order, running the block for the first true condition.
- **Unless**: Runs code only if the condition is false.
- **Ternary Operator**: A concise if-else for assignments or simple choices (condition ? true_case : false_case).
- **Case Expression**: Similar to switch statements in other languages, using when to match patterns.


### Modifier Conditionals

- **if/unless modifier**
- [conditions](conditions.rb)

>[!NOTE]
> *Truthiness*: In Ruby, only `false` and `nil` are `falsy`. `0`, `""` (`empty string`), and `[]` (`empty array`) are all `truthy`.
> *Return Values*: `if` expressions return the value of the last statement executed


## Arrays

- An array can include different types of data simultaneously.
- Index of an array starts at 0.
- Negative indexing supports.
- Index outofscopes returns `nil`, no error.
- Can do arithmatic operations if the data is numerical.
- Arrays can include variables.
- Arrays can include other arrays(*multi-dimensional arrays*).


## Hashes

- Similar to a dictionary.
- Has a key and a value, and seperates by a *hash rocket* `=>`.
- [hashes](hashes.rb)


## Loops - Iterators

>[!TIP]
> To create a range, use `(1..5)` or just `1..10`.
> Can use a variables to decide the upper and lower limits of the range.

- [rube-iterators](https://womanonrails.com/ruby-iterators)


### Looping Constructs

- `while`: Repeats while a condition is true.
- `until`: Repeats until a condition is true (opposite of `while`).
- `for`: Iterates over a range or collection.
- `loop`: Creates an infinite loop; typically used with break (`while true`).


### Iterators

- `.each`: For iterating over arrays and hashes.
- `.map`/`.collect`: Returns a new array with results from the block.
- `.map!`/`.collect!`: Returns the same array with modified results.
- `.select`/`.find_all`: Returns elements that satisfy a condition.
- `.times`: Executes a block a specific number of times.
- `.each_with_index`: Provides the current element and it's index.


### Specialized Iteration & Enumerators

- `.step`: Iterates over ranges with a specific step.

- [loops](loops.rb)


## Exercise: FizzBuzz

- [fizzbuzz](fizzbuzz.rb)


## Methods - Functions

- In plain Ruby, generally it's better to define any method before calling it.
- But when Ruby script runs via handlers/plugins the the full ruby file is loaded first, then it's executed, therefore, for such cases it's okay to define your methods at bottom.
- So behavior depends on when the method is invoked, not just where it's written.

>[!NOTE]
> A method must be defined before it is executed at runtime

- 