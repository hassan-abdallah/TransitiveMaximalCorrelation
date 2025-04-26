#' Compute Transitive Maximal Correlation Matrix
#'
#' This function takes as input a correlation matrix and returns a list containing the corresponding transitive maximal correlation matrix, a list of attractor pairs, and a list of attractor basin compositions.
#'
#' @param cor_mat A correlation matrix.
#'
#' @return A list containing:
#' \describe{
#'   \item{tmc_matrix}{The transitive maximal correlation matrix.}
#'   \item{attractors}{A list of attractor pairs.}
#'   \item{attractor_basins}{A list of attractor basin compositions.}
#' }
#'
#' @export


tmc <- function(cor_mat){

tmc_mat <- matrix(0, nrow = nrow(cor_mat), ncol = ncol(cor_mat))
cor_mat <- abs(cor_mat)

dgraph <- c()
for (i in 1:nrow(cor_mat)){
  cor_vals <- c()
  for (j in 1:nrow(cor_mat)){
  if (i != j) {
     cor_vals[j]=cor_mat[i,j]
      
    }
   }
  cor_max <- which.max(cor_vals)
  if(cor_max >0){
    dgraph <- rbind(dgraph,c(i,cor_max))
    
  }
  
}

segmentation <-  list()
for(i in 1:nrow(dgraph)){  
  path <- c() 
  end = 0 
  path[1] = dgraph[i,2]
  node = path[1] 
  while(end < 1){
    node = dgraph[node,2]
    if(node %in% path){
      path[length(path)+1] = node
      inds <- which(path == node)
      path = path[inds[1]:(inds[2]-1)]
      end = 1
    } else {
      path[length(path)+1] = node
    }
    
  }
  segmentation[[i]] = sort(path)
}
for(i in 1:ncol(cor_mat)){
  tmc_mat[i,segmentation[[i]][1]] = 1
  tmc_mat[i,segmentation[[i]][2]] = 1
  
}
attractors = list() 


for (i in 1:nrow(tmc_mat)){
	
	if (tmc_mat[i,i] == 1){
		attractors <- append(attractors, list(c(which(tmc_mat[i,] == 1))))
	}
}

attractors <- unique(attractors)

attractor_basins <- list() 
for (i in 1:length(attractors)){
	attractor_basins <- append(attractor_basins,list(which(tmc_mat[,attractors[[i]][1]] == 1)))
}


attractor_basins <- unique(attractor_basins)

tmc_data <- list(tmc_mat,attractors,attractor_basins)

names(tmc_data) <- c("tmc_matrix","attractors","attractor_basins")

return(tmc_data)

}

