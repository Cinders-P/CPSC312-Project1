# Test Cases
These are terminal logs showing test inputs
and the corresponding program output.

## Success
### Standard Question
This is probably the most frequent usage.
```
Who is the Prime Minister of Canada ?
My data tells me it is Justin Trudeau.
```
### Flipped Question
A secondary way to phrase the above question. Supported
as part of our 'natural language' parsing goal.
```
who is canada's prime minister?
My data tells me it is Justin Trudeau.
```
### New Question
When the system does not have this question registered,
the user can add an answer.
```
What is Canada's national bird
Hm. I don't have the answer to that.
Would you like to save an answer for this question? yes
Input answer: Jay bird
Answer saved!

What would you like to know?
What is Canada's national bird
My data tells me it is Jay bird.
```
### Overwriting an Answer
If the user is not satisfied with an answer, they can
edit its record.
```
What would you like to know?
who is the prime minister of canada
My data tells me it is Justin Trudeau.
Would you like to overwrite my answer? yes
Input answer: Justin Bieber
Answer saved!

What would you like to know?
who is canada's prime minister
My data tells me it is Justin Bieber.
```


## Bad Inputs
### Question Too Complex
Most of the questions we came up with had a standard 3 keyword format,
which we decided to limit our scope to.
```
What would you like to know?
what is the most frequent song that canadian likes to hear ?
Sorry, I didn't understand your question.
```
### Garbage Input
Failed parsing is handled gracefully.
```
What would you like to know?
asdasd
Sorry, I didn't understand your question.
```
### Word Capitalization
Inputs are mapped by `toLower` to ensure that comparisons are not an issue.
```
What would you like to know?
WHAT IS CANADA'S POPULATIOn
My data tells me it is 37-38 million.
```
### Backspaces in Input
`\DEL` is filtered out of inputs in case the user makes a mistake.
```
What would you like to know?
Who is the mone^?arch of CAn^?^?^?canada?
My data tells me it is Elizabeth II.
Would you like to overwrite my answer? yes
Input answer: Batman^?^?^?king
Answer saved!

What would you like to know?
who is the monarc ^?h of canada?
My data tells me it is Batking.
```
