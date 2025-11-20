///|
/// Computes eigenvalues and eigenvectors of a square matrix using QR algorithm
/// with implicit shifts. The QR algorithm iteratively decomposes the matrix into
/// a product of an orthogonal matrix Q and an upper triangular matrix R,
/// converging to a diagonal matrix containing eigenvalues.
///
/// Parameters:
///
/// * `matrix` : A square matrix whose eigenvalues and eigenvectors are to be
/// computed.
/// * `max_iterations` : Maximum number of iterations for the QR algorithm.
/// Defaults to 1000.
/// * `tolerance` : Convergence tolerance for off-diagonal elements. The
/// algorithm stops when the Frobenius norm of off-diagonal elements is less than
/// this value. Defaults to 1e-10.
///
/// Returns a tuple `(eigenvalues, eigenvectors)` where:
///
/// * `eigenvalues` : An array of Double values representing the eigenvalues of
/// the matrix
/// * `eigenvectors` : A matrix whose columns are the corresponding eigenvectors
///
/// Throws "MatrixShapeError" if the input matrix is not square.
///
/// Examples:
///
/// ```moonbit
