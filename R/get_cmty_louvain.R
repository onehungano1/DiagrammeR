#' Get community membership by Louvain optimization
#' @description Through the use of multi-level
#' optimization of a modularity score, obtain the
#' group membership values for each of the nodes in
#' the graph.
#' @param graph a graph object of class
#' \code{dgr_graph}.
#' @return a data frame with group membership
#' assignments for each of the nodes.
#' @examples
#' # Create a random graph
#' graph <-
#'   create_random_graph(
#'     10, 22, set_seed = 23)
#'
#' # Get the group membership values for all nodes
#' # in the graph through the multi-level optimization
#' # of modularity algorithm
#' get_cmty_louvain(graph)
#' #>    id louvain_group
#' #> 1   1             2
#' #> 2   2             1
#' #> 3   3             1
#' #> 4   4             2
#' #> 5   5             2
#' #> 6   6             2
#' #> 7   7             1
#' #> 8   8             2
#' #> 9   9             1
#' #> 10 10             2
#'
#' # Add the group membership values to the graph
#' # as a node attribute
#' graph <-
#'   graph %>%
#'   join_node_attrs(get_cmty_louvain(.))
#' @importFrom igraph cluster_louvain membership
#' @export get_cmty_louvain

get_cmty_louvain <- function(graph) {

  # Validation: Graph object is valid
  if (graph_object_valid(graph) == FALSE) {
    stop("The graph object is not valid.")
  }

  # If graph is directed, transform to undirected
  graph <- set_graph_undirected(graph)

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  # Get the community object using the
  # `cluster_louvain()` function
  cmty_louvain_obj <-
    igraph::cluster_louvain(ig_graph)

  # Create df with node memberships
  cmty_louvain_df <-
    data.frame(
      id = as.integer(names(igraph::membership(cmty_louvain_obj))),
      louvain_group = as.vector(igraph::membership(cmty_louvain_obj)),
      stringsAsFactors = FALSE)

  return(cmty_louvain_df)
}
