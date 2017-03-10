library("testthat")
source("R/lib.R")

test_that("generate_xyn_patterns", {
  patterns <- generate_xyn_patterns(c("A", "B"), c("D", "E"), 1:3)
  expect_equal(sort(patterns), sort(c("AD1", "AD2", "AD3",
                                      "AE1", "AE2", "AE3",
                                      "BD1", "BD2", "BD3",
                                      "BE1", "BE2", "BE3")))
})

test_that("xyn_patterns_to_regex", {
  xyn_patterns = c("AB3", "DE1", "FA4")
  expect_equal(xyn_patterns_to_regex(xyn_patterns), c("A.{3}B", "D.{1}E", "F.{4}A"))
})

test_that("parse_multifasta_file", {
  sequences <- parse_multifasta_file("tests/testfile.fasta")
  expect_equal(sequences, c("MIKLIEGKWPHGYNHECDEH",
                            "GKRQEYVCEEEMFVAPCTPS",
                            "QKNKLEWRRAKMTTIFVSDL"))
})

#@TODO for transactions function
