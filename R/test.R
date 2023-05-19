# Install the required package
if (!require("yaml")) {
  install.packages("yaml")
}

# Import the required library
library(yaml)

# Define the path to the YAML file
yaml_file_path <- file.path("inst", "extdata", "metadata.yaml")

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

# Print the queries for the database with the code "dbn"
print_queries(dbn_queries)

# Function to generate a new query
generate_query <- function(database_queries) {

  # Function to replace references in query
  replace_references_in_query <- function(query_text) {
    # Use gsub with a function to dynamically replace the matches
    gsub("#\\w+", function(x) {
      ref_index <- substr(x, 2, nchar(x))  # Remove the '#'
      # Find the query with the corresponding index
      ref_query <- Filter(function(q) q$index == ref_index, database_queries)
      if (length(ref_query) > 0) {
        return(ref_query[[1]]$query)  # Return the query text
      } else {
        return(x)  # If no matching index is found, return the original text
      }
    }, query_text)
  }

  # Loop through each query in the database by index
  for (i in seq_along(database_queries)) {
    query <- database_queries[[i]]
    if (isTRUE(query$combine_queries)) {
      # Replace the references in the query
      database_queries[[i]]$query_replaced_text <- replace_references_in_query(query$query)
    }
  }

  return(database_queries)
}

# Generate a new query based on the queries with combine_queries: TRUE
dbn_queries <- generate_query(dbn_queries)

# Print the updated list of queries
print_queries(dbn_queries)
