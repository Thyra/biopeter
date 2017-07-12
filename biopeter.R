#!/usr/bin/Rscript

# Load Command Line options and parse them into options
source("R/cli_options.R")

# Load lib
source("R/lib.R")
source("R/rules2df.R")

# Load libraries
library("arules")
library("methods")

# If patterns are specified manually via file
if(!is.null(options$`patterns-file`)) {
  # If the file already contains regexp patterns
  if(options$`regex-patterns`)
    patterns <- readLines(file(options$`patterns-file`, "r"))
  else
    patterns <- xyn_patterns_to_regex(readLines(file(options$`patterns-file`, "r")))
} else {
  # XYn patterns should be generated.
  # Select amino acids
  ## Set left and right to options$aa
  aa_left  <- strsplit(options$aa, "")[[1]]
  aa_right <- strsplit(options$aa, "")[[1]]

  ## If specific right or left aas are given, overwrite
  if(!is.null(options$`aa-left`)) {
    aa_left  <- strsplit(options$`aa-left`, "")[[1]]
  }
  if(!is.null(options$`aa-right`)) {
    aa_right  <- strsplit(options$`aa-right`, "")[[1]]
  }

  # Generate patterns
  patterns <- xyn_patterns_to_regex(generate_xyn_patterns(aa_left, aa_right, options$`n-min`:options$`n-max`))
}

# Generate transactions
transactions <- create_transactions(parse_multifasta_file(file), patterns)
rm(patterns)

if(options$`explore`) {
  source("R/explorer.R")
  launchExplorer(transactions, supp=options$support, conf=options$confidence)
} else {
  # Apply apriori algorithm and output results
  rules <- apriori(transactions,
                   parameter = list(supp = options$support,
                                    conf = options$confidence,
                                    maxlen = options$maxlen))
   quality(rules)$conviction <- interestMeasure(rules, measure='conviction', transactions=transactions)
   quality(rules)$hyperConfidence <- interestMeasure(rules, measure='hyperConfidence', transactions=transactions)
   quality(rules)$cosine <- interestMeasure(rules, measure='cosine', transactions=transactions)
   quality(rules)$chiSqurulese <- interestMeasure(rules, measure='chiSquare', transactions=transactions)
   quality(rules)$coverage <- interestMeasure(rules, measure='coverage', transactions=transactions)
   quality(rules)$doc <- interestMeasure(rules, measure='doc', transactions=transactions)
   quality(rules)$gini <- interestMeasure(rules, measure='gini', transactions=transactions)
   quality(rules)$hyperLift <- interestMeasure(rules, measure='hyperLift', transactions=transactions)
  rulesdf <- rules2df(rules)
  rm(transactions, rules)
  if(!is.null(options$`outfile`)) {
    write.csv(rulesdf, file=options$`outfile`, quote=T)
  } else {
    print(rulesdf)
  }
}

### NOTES/UNFINISHED/BLABLABLA ###
#rules = switch(options$algorithm,
#               apriori = apriori(transactions),
#               eclat   = ruleInduction(eclat(transactions))
#              )
