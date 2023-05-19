library(rentrez)
library(yaml)
library(stringr)

# Load the YAML file
yaml_file_path <- file.path("inst", "extdata", "queries.yaml")
yaml_content <- yaml.load_file(yaml_file_path)

# Extract the databases
databases <- yaml_content$databases

# Define the list of databases to run
databases_to_run <- c("pubmed")

# Prepare the queries for the specified databases
for (database in databases) {
  if (database$code %in% databases_to_run) {
    dbn_queries <- prepare_database_queries(database)
    print_query_results(dbn_queries, database$code)
  }
}

# Function to replace index references in a string
replace_index_references <- function(query_string, queries) {
  str_replace_all(query_string, "\\#\\d+[a-z]?", function(index_ref) {
    index_ref <- str_remove(index_ref, "#")
    for(query in queries) {
      if(query$index == index_ref) {
        return(query$query)
      }
    }
  })
}

prepare_database_queries <- function(database) {
  for (i in 1:length(database$queries)) {
    # Check if the query needs to be combined
    if (!is.null(database$queries[[i]]$combine_queries) && database$queries[[i]]$combine_queries) {
      # Save the original query string to a new field
      database$queries[[i]]$query_original_text <- database$queries[[i]]$query

      # Get the replaced query string
      replaced_query_string <- replace_index_references(database$queries[[i]]$query, database$queries)

      # Replace the query string with the replaced string
      database$queries[[i]]$query <- replaced_query_string
    }
  }
  return(database$queries)
}

# Function to get the PubMed query results
get_pubmed_query_results <- function(query) {
  # Use the replaced query string
  query_string <- query$query

  # Get the results from PubMed
  results <- entrez_search(db = "pubmed", term = query_string)

  # Return the number of results
  results$count
}

# Function to print the query results
print_query_results <- function(queries) {
  # Create an empty data frame to store the results
  results_summary <- data.frame(
    "Query.Index" = character(),
    "Query.String" = character(),
    "Query.String.Replaced" = character(),
    "Number.of.Results" = integer(),
    stringsAsFactors = FALSE
  )

  # For each query...
  for (i in 1:length(queries)) {
    # Get the query info and results
    query_info <- queries[[i]]
    result <- get_pubmed_query_results(query_info)

    # Check if 'query_original_text' exists
    if (!"query_original_text" %in% names(query_info)) {
      query_info$query_original_text <- query_info$query
    }

    # Append to the summary data frame
    results_summary <- rbind(results_summary, data.frame(
      "Query.Index" = query_info$index,
      "Query.String" = query_info$query,
      "Query.String.Replaced" = ifelse(query_info$query_original_text == query_info$query, "", query_info$query_original_text),
      "Number.of.Results" = result,
      stringsAsFactors = FALSE
    ))
  }

  # Print the summary table
  print(results_summary, row.names = FALSE)
}

# Prepare the queries for each database
for (database in databases) {
  dbn_queries <- prepare_database_queries(database)
  cat("Database Code: ", database$code, "\n")
  print_query_results(dbn_queries)
  cat("\n")
}
