# biopeter
[![Build Status](https://travis-ci.org/Thyra/biopeter.svg?branch=master)](https://travis-ci.org/Thyra/biopeter)

**Association Rules for regex patterns in amino acid sequences**

## Purpose
Biopeter is a utility intended to find [association rules](https://en.wikipedia.org/wiki/Association_rule_learning) for patterns in amino acid sequences.
It takes a collection of amino acid sequences in [fasta format](https://en.wikipedia.org/wiki/FASTA_format)\* and deduces rules like *if the patterns A and B are present in the sequence, the pattern C is also contained with a probability of p percent*.
This can help biologists and bioinformaticians to discover functional relationships between different amino acid patterns in a set of related sequences.

By default, biopeter works with patterns in the *XYn* form. *X* and *Y* are two amino acids and *n* denotes a distance between them. For example, *MK2* would mean a pattern where the amino acid Methionine (M) appears in the sequence, then there are 2 arbitrary amino acids, and then Lysine (K) follows. *LE1* means Leucin (L), one arbitrary amino acid, and then Glutamic acid. The following examplary sequence contains both these patterns: `MPLKE`

If the *XYn* form does not fulfill your needs, it is also possible to work with custom regular expressions for patterns. This way you can create more complex patterns like `[MK][CTP]{2,5}[DL]`.

\* In contrast to the standard fasta format, biopeter will treat empty lines as the beginning of a new sequence. So the following file would contain three, not two sequences:

```
>random sequence 1 consisting of 20 residues.
MIPKLIEGKWPHGYNHECDE

>random sequence 2 consisting of 20 residues.
GKRQEYVCEEEMFVAPCTPS

QKNKLEWRRAKMTTIFVSDL
```

## Installation
biopeter depends on the R packages arules and optparse so install these first:
```
install.packages(c("arules", "optparse"))
```
Then you need to download biopeter itself. Probably the easiest way is to clone the distribution branch of this repository:
```
git clone -b distribution --single-branch https://github.com/Thyra/biopeter.git biopeter
```

If you want to use the [exploration feature](https://github.com/Thyra/biopeter#specifying-patterns) you also have to install the shiny and arulesViz package:
```
install.packages(c("shiny", "arulesViz"))
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
Biopeter will then print out the association rules it has found between the XYn patterns (obviously that makes more sense when the sequences are not random ;-)).

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
Additionally to the `patterns-file` option you then have to pass the `--regex-patterns` flag: `Rscript biopeter.R --regex-patterns --patterns-file="mypatterns.txt" <sequenceFile>`

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

## Tuning the Algorithm
A very important part in mining association rules is to select only those that fit certain critera (i.e. namely a certain [support](https://en.wikipedia.org/wiki/Association_rule_learning#Support) and [confidence](https://en.wikipedia.org/wiki/Association_rule_learning#Confidence)). You can specify these criteria via the following options: 
```
	--support=SUPPORT
		Minimal support for the mined rules/itemsets. [default: 0.9]

	--confidence=CONFIDENCE
		Minimal confidence for the mined rules. [default: 0.9]

	--maxlen=MAXLEN
		Maximal number of items to be considered in one rule. [default: 10]
```
As you can see the default values are very restrictive. The reason is the sheer amount of generated patterns and possible combinations thereof (2800 patterns -> 2^2800 combinations with default settings). So be careful when loosening the restrictions or your machine might run out of memory and freeze (happened to me many times while testing…)

## Saving the results
By default, biopeter prints the rules he found on screen. In many cases you might want to process them further, though.
It is therefore possible to save the rules in a CSV-like file via the `--outfile` option.
Be careful, though, the resulting file has numbers as its first column and no header for it:
```
"rules","support","confidence","lift"
"1","{} => {F.{4}L}",0.900770712909441,0.900770712909441,1
"2","{} => {F.{3}L}",0.92485549132948,0.92485549132948,1
"3","{} => {L.{3}A}",0.968208092485549,0.968208092485549,1
"4","{} => {L.{3}L}",0.975915221579961,0.975915221579961,1
"5","{} => {L.{4}L}",0.980732177263969,0.980732177263969,1
"6","{F.{3}L} => {L.{3}L}",0.903660886319846,0.977083333333333,1.00119693978282
"7","{L.{3}L} => {F.{3}L}",0.903660886319846,0.925962487660415,1.00119693978282
"8","{F.{3}L} => {L.{4}L}",0.907514450867052,0.98125,1.00052799607073
"9","{L.{4}L} => {F.{3}L}",0.907514450867052,0.925343811394892,1.00052799607073
"10","{L.{3}A} => {L.{3}L}",0.946050096339114,0.977114427860696,1.00122880169734
"11","{L.{3}L} => {L.{3}A}",0.946050096339114,0.969397828232971,1.00122880169734
"12","{L.{3}A} => {L.{4}L}",0.951830443159923,0.983084577114428,1.00239861595754
"13","{L.{4}L} => {L.{3}A}",0.951830443159923,0.970530451866405,1.00239861595754
"14","{L.{3}L} => {L.{4}L}",0.961464354527938,0.985192497532083,1.00454794935
"15","{L.{4}L} => {L.{3}L}",0.961464354527938,0.980353634577603,1.00454794935
"16","{L.{3}L,L.{3}A} => {L.{4}L}",0.934489402697495,0.987780040733198,1.00718632837039
"17","{L.{4}L,L.{3}A} => {L.{3}L}",0.934489402697495,0.981781376518219,1.0060109267778
"18","{L.{3}L,L.{4}L} => {L.{3}A}",0.934489402697495,0.971943887775551,1.00385846319505
```
If you're on Linux you can easily fix this with the following bash command `echo -e "$(head -1 outfile.csv)\n$(tail -n +2 outfile.csv | cut -d"," -f 2-)" > new_outfile.csv` where outfile.csv is the name of your CSV file.

If you don't like commas as separators, you can also provide a different `--separator` character.

## Exploring Rules
This is probably the coolest feature biopeter has to offer: You can interactively explore the rules visually in an application that is based on Andrew Brooks' [Interactive association rules exploration app](http://brooksandrew.github.io/simpleblog/articles/association-rules-explore-app/). Simply launch biopeter with the `--explore` flag and enjoy!
