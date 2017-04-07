# biopeter
[![Build Status](https://travis-ci.org/Thyra/biopeter.svg?branch=master)](https://travis-ci.org/Thyra/biopeter)

**Association Rules for regex patterns in amino acid sequences**

## Purpose
Biopeter is a utility intended to find [association rules](https://en.wikipedia.org/wiki/Association_rule_learning) for patterns in amino acid sequences.
It takes a collection of amino acid sequences in [fasta format](https://en.wikipedia.org/wiki/FASTA_format)\* and deduces rules like *if the pattern X is present in the sequence, the pattern Y is also contained with a probability of p percent*.
This can help biologists and bioinformaticians to discover functional relationships between different amino acid patterns in a set of related sequences.

By default, biopeter works with patterns in the *XYn* form. *X* and *Y* are two amino acids and *n* denotes a distance between them. For example, *MK2* would mean a pattern where the amino acid Methionine (M) appears in the sequence, then there are 2 arbitrary amino acids, and then Lysine (K) follows. *LE1* means Leucin (L), one arbitrary amino acid, and then Glutamic acid. The following examplary sequence contains both these patterns: `MIPKLIEGKWPHGYNHECDE`

If the *XYn* form does not fulfill your needs, it is also possible to work with custom regular expressions for patterns. This way you can create more complex patterns like `[MK][CTP]{2,5}[DL]`.

\* In contrast to the standard format, biopeter will treat empty lines as the beginning of a new sequence. So the following file would contain three, not two sequences:

```
>random sequence 1 consisting of 20 residues.
MIPKLIEGKWPHGYNHECDE

>random sequence 2 consisting of 20 residues.
GKRQEYVCEEEMFVAPCTPS

QKNKLEWRRAKMTTIFVSDL
```

## Usage
```
Rscript biopeter.R <file>
```
`<file>` should be a multifasta file containing amino acid sequences. Here is an example:
```
>random sequence 1 consisting of 20 residues.
MIPKLIEGKWPHGYNHECDE

>random sequence 2 consisting of 20 residues.
GKRQEYVCEEEMFVAPCTPS

>random sequence 3 consisting of 20 residues.
QKNKLEWRRAKMTTIFVSDL

>random sequence 4 consisting of 20 residues.
DNPLSPDEMSHEGIHPWFSK

>random sequence 5 consisting of 20 residues.
YIDDTKRNRSDMLGEDVHTQ
```
Biopeter will then print out the association rules it has found between combinations of two amino acids each and a distance between them (obviously that makes more sense when the sequences are not random ;-)).

## Specifying Patterns
### Generate Patterns
You can specify the amino acids to examine in the XYn patterns with the following three options:
```
	--aa=AA
		By default, biopeter creates associations between patterns of the form XYn,
              where X and Y are two amino acids and n is the distance between them. With this
              option the amino acids used to create these patterns can be limited to the ones
              supplied. Example: %prog --aa="AVCT" . If not otherwise specified, the following
              amino acids are used to create the patterns: "GPAVLIMCFYWHKRQNEDST"

	--aa-left=AA-LEFT
		Similar to the --aa option, but only limits the amino acids on the left of
              the pattern – the X of XYn. [default: NULL]

	--aa-right=AA-RIGHT
		Similar to the --aa option, but only limits the amino acids on the right of
              the pattern – the Y of XYn. [default: NULL]
```
The range of n can also be specified:
```
	--n-min=N-MIN
		Patterns are generated for a range of n values. This is the minimum value.
              [default: 3]

	--n-max=N-MAX
		Patterns are generated for a range of n values. This is the maximum value.
              [default: 9]
``` 
Here are some examples:
``` 
Rscript biopeter.R --aa="ABC" --n-min=1 --n-max=3 <file>

 [1] "AA1" "AA2" "AA3" "AB1" "AB2" "AB3" "AC1" "AC2" "AC3" "BA1" "BA2" "BA3"
[13] "BB1" "BB2" "BB3" "BC1" "BC2" "BC3" "CA1" "CA2" "CA3" "CB1" "CB2" "CB3"
[25] "CC1" "CC2" "CC3"
``` 
``` 
Rscript biopeter.R --aa-left="AB" --aa-right="DE" --n-max=4 <file>

[1] "AD3" "AD4" "AE3" "AE4" "BD3" "BD4" "BE3" "BE4"
``` 
### Provide Patterns Manually
If you are only interested in a select set of patterns you can also provide them manually in a file, one per line
``` 
AD2
BP1
VQ4
``` 
and pass the file via the `--patterns-file` option.

### Going beyond XYn Patterns
If you have more complicated patterns you want to examine or the XYn scheme simply doesn't fit your needs, you can provide your patterns in complete regex syntax in a text file, again, one per line:
``` 
[MQ]+.{3,5}$
D{2,4}A
^KLE+
``` 
Additionally to the `patterns-file` option you then have to pass the `--regex-patterns` flag: `Rscript biopeter.R --patterns-file="mypatterns.txt" --regex-patterns <sequenceFile>`

#### Abusing biopeter
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
Not with this text, though, Oscar Wilde didn't use these words…
