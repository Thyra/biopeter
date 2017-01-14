# Expects a vector of X amino acids, a vector of Y amino acids, and a vector of numbers for n
# returns a character vector containing the generated patterns (like AV2, AV3...)
generate_xyn_patterns <- function(X, Y, N) {
  as.vector(
    sapply(X, function(x) {
      vapply(Y, function(y) {
             paste(x, y, N, sep="")
      }, FUN.VALUE=vector("character", length(N)))
    }) # @TODO vapply would be better, but I don't know what the correct FUN.VALUE is
  )
}

# Expects a character vector of XYn patterns and returns a
# character vector containing regex patterns matching these XYn patterns
xyn_patterns_to_regex <- function(P) {
  as.vector(
    vapply(P, function(a) {
      paste(substr(a, 1, 1),
            ".{",
            substr(a, 3, nchar(a)),
            "}",
            substr(a, 2, 2),
            sep="")
      },
    FUN.VALUE="")
  )
}

# Expects a file path to a multifasta file
# Returns character vector containing the sequences read (without comments)
parse_multifasta_file <- function(filepath) {  
  file = file(filepath, open="r")
  sequences=character()
  current_sequence = ""
  while(length(line <- readLines(file, n = 1)) > 0) {
    if(substr(line, 1, 1) == ">" || nchar(line) == 0) {
      if(nchar(current_sequence) > 0) {
        sequences = append(sequences, current_sequence)
        current_sequence = ""
      }
    } else {
      current_sequence = paste(current_sequence, line, sep="")
    }
  }
  # Final sequence also has to be appended
  sequences = append(sequences, current_sequence)
  return(sequences)
}

# Expects a character vector of sequences and one character vector of regex patterns
# Returns transactions: sequences are datasets, patterns are items
create_transactions <- function(sequences, patterns) {
  return(
    as(sapply(patterns, grepl, sequences, ignore.case=T),
      "transactions")
  )
}
