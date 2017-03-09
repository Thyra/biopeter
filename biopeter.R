#!/usr/bin/Rscript

# Load Command Line options and parse them into options
source("R/cli_options.R")

# Load lib
source("R/lib.R")

# Load libraries
library("arules")
library("methods")

aa <- strsplit(options$aa, "")[[1]]

# Generate patterns and read sequences
patterns <- xyn_patterns_to_regex(generate_xyn_patterns(aa, aa, options$`n-min`:options$`n-max`))
sequences <- parse_multifasta_file(file)

# Generate transactions from them
transactions <- create_transactions(sequences, patterns)
rm(patterns, sequences)

# Apply apriori algorithm and show results
rules <- apriori(transactions)
print(inspect(rules))

### NOTES/UNFINISHED/BLABLABLA ###
#if (options$read_transactions != "") {
#  # Read transactions from file
#} else {
#  # If not read transactions from file
#  if (options$read_patterns != "") {
#    # If read patterns from file
#    if(options$regex_patterns) {
#      # If patterns are already regex
#      patterns = readLines(options$read_patterns)
#    } else {
#      # If patterns are not already regex
#      patterns = xyn_patterns_to_regex(readLines(options$read_patterns))
#    }
#  } else {
#    # If not read patterns from file
#    X = options$aa
#    Y = options$aa
#    if (options$aa_left  != "") X = options$aa_left
#    if (options$aa_right != "") Y = options$aa_right
#    # @TODO: implement aa exclusion
#    patterns = xyn_patterns_to_regex(generate_xyn_patterns(X, Y, options$n_min:options$n_max))
#  }
#  # Read sequences
#  sequences = parse_multifasta_file(FILENAME) #@TODO: Get filepath from options
#
#  # Generate transactions
#  transactions = create_transactions(sequences, patterns)
#  rm(sequences, patterns)
#
#  if (options$save_transactions != "") {
#    # Save transactions to file
#  }
#}
## Apply algorithm
#rules = switch(options$algorithm,
#               apriori = apriori(transactions),
#               eclat   = ruleInduction(eclat(transactions))
#              )
#rm(transactions)
#if (is.null(rules)) {
#  print("Invalid algorithm given. See --help for help.")
#  quit(status = 1)
#}
#
## Print/Save/Explore
#print(inspect(rules))
## @TODO: Write and Explore rules
