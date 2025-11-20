///|
/// Computes the inverse of a square matrix using Gauss-Jordan elimination
/// method.
///
/// Parameters:
///
/// * `matrix` : A square matrix to be inverted. Must be a non-singular matrix
/// with equal number of rows and columns.
///
/// Returns a new matrix that is the inverse of the input matrix.
///
/// Throws a runtime error if:
///
/// * The input matrix is not square (rows ≠ columns)
/// * The input matrix is singular (determinant = 0)
///
/// Examples:
///
/// ```moonbit
