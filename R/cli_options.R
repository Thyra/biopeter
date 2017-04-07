# These options will be implemented:
#  --aa = Only use these AAs
#  --aa-left = Only use these AAs for left
#  --aa-right = Only use these AAs for right
##  --exclude-aa = Remove these AAs from both left and right
##  --exclude-aa-left = Remove only from left
##  --exclude-aa-right = Remove onyl from right
#  --n-min = Min for XYn n
#  --n-max = Max for n...
#
#  --patterns-file = Supply patterns manually
#  --regex-patterns = FLAG: Instead of XYn patterns treat the supplied patterns as regular expressions
#
#  --min-support = min support for association rules
#  --min-confidence = min confidence for association rules
#  --algorithm = algorithm used: eclat (default) or apriori
#
#  --explore = FLAG: creates visualizations and launches interactive data sheets to explore the crated rules
#  --outfile = Save the created association rules in CSV format to this file
#
#  --config-file : If this file exists, the options of it are read out. Any option given here manually overwrites what is in the file.

library("optparse")
option_list <- list(
  make_option("--aa", default="GPAVLIMCFYWHKRQNEDST",
              help="By default, biopeter creates associations between patterns of the form XYn,
              where X and Y are two amino acids and n is the distance between them. With this
              option the amino acids used to create these patterns can be limited to the ones
              supplied. Example: %prog --aa=\"AVCT\" . If not otherwise specified, the following
              amino acids are used to create the patterns: \"%default\""),
  make_option("--aa-left",
              help="Similar to the --aa option, but only limits the amino acids on the left of
              the pattern – the X of XYn. Ignored if empty. [default: %default]"),
  make_option("--aa-right",
              help="Similar to the --aa option, but only limits the amino acids on the right of
              the pattern – the Y of XYn. Ignored if empty. [default: %default]"),
#  make_option("--exclude-aa", default="",
#              help="Use all amino acids BUT the ones supplied. If you are, for example, not interested
#              in the role of Leucin, you can exclude it from the patterns: %prog --exclude-aa=\"L\".
#              [default: \"%default\"]. If both --aa limits and --exclude-aa limits are given,
#              the --exclude-aa amino acids are removed from the given --aa list."),
#  make_option("--exclude-aa-left", default="",
#              help="Exclude these amino acids from the left side of patterns – X of XYn."),
#  make_option("--exclude-aa-right", default="",
#              help="Exclude these amino acids from the right side of patterns – Y of XYn."),
  make_option("--n-min", default=3, type="integer",
              help="Patterns are generated for a range of n values. This is the minimum value.
              [default: %default]"),
  make_option("--n-max", default=9, type="integer",
              help="Patterns are generated for a range of n values. This is the maximum value.
              [default: %default]"),

  make_option("--patterns-file", type="character",
              help="Instead of letting the patterns be generated automatically, you can also
              provide them yourself, if you are interested in only a select list of patterns.
              For that provide a file here that contains the patterns in XYn form, one per line."),
  make_option("--regex-patterns", action="store_true", default=F,
              help="Instead of using only XYn patterns you can also provide any kind of other pattern
              in regex form, eg. [AV]{2,3}.{1,3}G
              Use this flag if the lines in your pattern-file should be treated as regular expressions
              instead of XYn patterns.")
)

arguments <- parse_args(OptionParser(option_list=option_list), positional_arguments = 1)
options <- arguments$options
file <- arguments$args[1]
rm(arguments)
