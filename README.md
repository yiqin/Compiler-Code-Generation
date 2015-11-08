Exercise 1
=======
I used the template from http://alumni.cs.ucr.edu/~lgao/teaching/bison.html. The template includes basic files to run Bison. It is a desk calculator which performs '+' and '*' on unsigned integers.

Based on these, I did the exercise 1.

To run the project, type ``` make ``` in the terminal.

The binary file is ``calc``.

Type
```
./calc <testCase.txt
```
to run the test case.

Type ``` make clean ``` to clean files.


Question 1
=======
More details are in the file ``symbol_table.hpp``
```
class Symbol_Table
{
public:
  const void add (std::string key, int value) {
    m[key] = value;
  };
  const int get_value (std::string key) {
    return m[key];
  };
  const bool is_variable_defined (std::string key) {
    if (m.find(key) != m.end()) {
      return true;
    } else {
      return false;
    }
  };
protected:
  std::map<std::string, int> m;
};
```

Question 2
=======
The code can create a calculator. Semantic rules are in ``calc.y``
Here are some example
```
input:
		| intermediate SEMICOLON input	{ 
        cout << $1 << "; "  << endl;
      }
    | {}
		;

intermediate:
      VARIABLE ASSIGN exp { 
        $$ = $3; 
        symbol_table.add(*$1, $3);
      }
    | exp { $$ = $1; }
    | {}
    ;
```


Question 3
=======
type 
```
./calc <testCase.txt 
```
to calculate a:=5; a*a +2


Reference
=======
http://alumni.cs.ucr.edu/~lgao/teaching/bison.html

