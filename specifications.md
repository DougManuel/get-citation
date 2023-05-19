# Query Refactoring Specification

## Overview

The Query Refactoring tool is an R package designed to process a YAML file containing a list of databases and their associated queries. It performs query replacements and generates a summary of query results using the rentrez library for PubMed search. The package aims to be compliant with CRAN (Comprehensive R Archive Network) guidelines and will be submitted to CRAN for wider distribution and usage.

## Features

- **Input:** The tool accepts a YAML file containing the metadata, database information, and query details for multiple databases.
- **Query Refactoring:** The tool performs query refactoring by replacing index references (#n) with their corresponding query strings defined in the YAML file.
- **Query Combination:** The tool supports combining queries using logical operators (OR and AND).
- **Parenthesis Handling:** The tool handles optional parenthesis in queries. If no explicit parenthesis are provided, the entire statement is assumed to be enclosed in parentheses.
- **Query Execution:** The tool executes the refactored queries using the rentrez library to retrieve the number of results from PubMed.
- **Results Summary:** The tool generates a summary table displaying the database code, query index, original query string, refactored query string, and the number of results.

## Dependencies

The Query Refactoring tool is developed using the R programming language and relies on the following dependencies:

- **rentrez:** The rentrez library is used to retrieve the number of results for each refactored query from the PubMed database. It provides an interface to the NCBI's E-utilities, allowing easy access to various NCBI databases.
- **yaml:** The yaml library is used to parse the YAML file containing the database and query information.
- **stringr:** The stringr library is used for string manipulation and replacement operations.

By including these dependencies, the Query Refactoring tool can effectively process the YAML file and perform the necessary query replacements and retrieval of query results from PubMed.

## File Structure

The file structure of the Query Refactoring package is as follows:

```
query_refactoring/
  R/
    refactoring_functions.R
    execution_functions.R
    printing_functions.R
  inst/
    extdata/
      metadata.yaml
  man/
    query_refactoring-package.Rd
    refactoring_functions.Rd
    execution_functions.Rd
    printing_functions.Rd
  tests/
    test_refactoring_functions.R
    test_execution_functions.R
    test_printing_functions.R
  DESCRIPTION
  NAMESPACE
  LICENSE
  README.md
  renv/
    activate.R
    settings.json
  renv.lock
  .gitignore
```

## Metadata

The package supports the inclusion of YAML metadata in the following format:

```yaml
metadata:
  project_name: "PHES-EF"
  authors: ["Author1", "Author2"]
  version: "1.0"
  date: "2023-05-18"
```

The metadata section can be included in the `metadata.yaml` file located in the `inst/extdata/` directory.

## Testing

The package includes separate test files for each function category to ensure comprehensive testing coverage. The test files are located in the `tests/` directory.

## Package Management

The Query Refactoring package utilizes renv for package dependency management. The `renv/` directory contains the necessary files for creating and managing the package's isolated environment.

## Version Control

The package includes a `.gitignore` file to specify which files and folders should be ignored by version control systems.

## Documentation

The package includes documentation files (`*.Rd`) for each function category in the `man/ directory. These files provide detailed information on the usage and arguments of the respective functions.

## License

The package is licensed under an appropriate open-source license, which should be specified in the LICENSE file.

## Readme

The package includes a README.md file that provides a brief overview and usage instructions for the Query Refactoring package.
