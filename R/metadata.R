# Load required libraries
library(yaml)
library(rentrez)
library(glue)

# Define the path to the YAML file
yaml_file_path <- file.path("inst", "extdata", "queries.yaml")

# Load the YAML file
yaml_content <- yaml.load_file(yaml_file_path)

# Extract the databases
databases <- yaml_content$databases

# Function to get queries for a given database code
get_queries_for_database <- function(databases, database_code) {
  for (database in databases) {
    if (database$code == database_code) {
      return(database$queries)
    }
  }
  return(NULL)
}

# Function to replace referenced queries in a query string
replace_referenced_queries <- function(query, queries) {
  referenced_queries <- stringr::str_extract_all(query, "#\\d+[a-z]")[[1]]
  for (referenced_query in referenced_queries) {
    matched_index <- str_remove(referenced_query, "#")
    if (matched_index %in% names(queries)) {
      referenced_query_string <- queries[[matched_index]]$query
      query <- str_replace(query, referenced_query, referenced_query_string)
    }
  }
  return(query)
}

# Get PubMed queries
pubmed_queries <- get_queries_for_database(databases, "pubmed")

# Iterate over queries and replace referenced queries where required
for (i in 1:length(pubmed_queries)) {
  if (!is.null(pubmed_queries[[i]]$combine_queries) && pubmed_queries[[i]]$combine_queries == TRUE) {
    combined_query <- glue_collapse(pubmed_queries[[i]]$query, sep = " OR ")
    pubmed_queries[[i]]$query <- combined_query
  }
}

# Create an empty data frame to store the summary of results
results_summary <- data.frame(
  "Query.Index" = character(),
  "Query.String" = character(),
  "Number.of.Results" = integer(),
  stringsAsFactors = FALSE
)

# Execute each query
for (query_info in pubmed_queries) {
  # Extract the query
  query <- query_info$query

  # Replace referenced queries
  query <- replace_referenced_queries(query, pubmed_queries)

  # Print the query
  print(query)

  # Use the rentrez library to execute the query on PubMed
  result <- entrez_search(db = "pubmed", term = query, retmax = 1000)

  # Append to the summary data frame
  results_summary <- rbind(results_summary, data.frame(
    "Query.Index" = query_info$index,
    "Query.String" = query,
    "Number.of.Results" = result$count,
    stringsAsFactors = FALSE
  ))
}

# Print the summary table
print(results_summary)
