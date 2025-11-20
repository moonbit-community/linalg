///|
/// Performs QR decomposition on a matrix using the Gram-Schmidt
/// orthogonalization process. Decomposes a matrix A into a product of an
/// orthogonal matrix Q and an upper triangular matrix R, such that A = QR.
///
/// Parameters:
///
/// * `matrix`: The input matrix to be decomposed. Must have at least as many
/// rows as columns.
///
/// Returns a tuple (Q, R) where:
///
/// * Q is an m×n orthogonal matrix (Q^T Q = I)
/// * R is an n×n upper triangular matrix
///
/// Throws:
///
/// * `MatrixShapeError` if the input matrix has fewer rows than columns
/// * `MatrixError` if the input matrix is rank deficient (i.e., not full column
/// rank)
///
/// Examples:
///
/// ```moonbit
