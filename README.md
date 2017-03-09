# biopeter
**Association Rules for regex patterns in amino acid sequences**

Biopeter is a utility intended to find [association rules](https://en.wikipedia.org/wiki/Association_rule_learning) for patterns in amino acid sequences.

## Usage
```
Rscript biopeter.R <file>
```
`<file>` should be a multifasta file containing amino acid sequences. Here is an example:
```
>random sequence 1 consisting of 20 residues.
MIKLIEGKWPHGYNHECDEH

>random sequence 2 consisting of 20 residues.
GKRQEYVCEEEMFVAPCTPS

>random sequence 3 consisting of 20 residues.
QKNKLEWRRAKMTTIFVSDL

>random sequence 4 consisting of 20 residues.
DNPLSPDEMSHEGIHPWFSK

>random sequence 5 consisting of 20 residues.
YIDDTKRNRSDMLGEDVHTQ
```
biopeter will then print out the association rules it has found between combinations of two amino acids each and a distance between them (obviously that makes more sense when the sequences are not random ;-)).

<!---
## Abusing biopeter
Even though biopeter is intended to be used on protein sequences, you can create association rules on all kinds of text patterns.
Say, you want to find out how the words `man`, `brilliance`, `bucket`, and `overconfident` correlate in a book.
Then you could create a `--pattern-file` like this
```
man
brilliance
bucket
overconfident
```
and run biopeter with `--regex-patterns` on an input file that contains all the sentences of the book seperated by empty lines:
```
The fact is, that civilisation requires slaves.

The Greeks were quite right there.

Unless there are slaves to do the ugly, horrible, uninteresting work, culture and contemplation become almost impossible.

Human slavery is wrong, insecure, and demoralizing.

On mechanical slavery, on the slavery of the machine, the future of the world depends.

...
```
Then you may, for example, find out, that in the given text whenever the words `man` and `brilliance` appear in a sentence, most probably
the word `overconfident` also appears which may tell you something about the author's opinion on that matter.
Not with this text, though, Oscar Wilde didn't use these words...
-->
