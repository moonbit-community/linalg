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
/// test "eigen/symmetric" {
///   // Create a 2x2 symmetric matrix
///   let a = new_matrix([[3.0, 0.0], [0.0, 4.0]])
///   let (eigenvalues, eigenvectors) = a.eigen()
///   // Eigenvalues should be 3.0 and 4.0
///   inspect(eigenvalues, content="[3.0, 4.0]")
/// }
/// ```
pub fn Matrix::eigen(
  self : Matrix,
  max_iterations? : Int = 1000,
  tol? : Double = 0.0000000001,
) -> (Array[Double], Matrix) raise Error {
  if self.rows != self.cols {
    abort("MatrixShapeError: Matrix must be square to compute eigenvalues")
  }
  let n = self.rows
  let mut a = self.copy()
  let mut v = eye(n)
  for iter = 0; iter < max_iterations; iter = iter + 1 {
    let (q, r) = a.qr()
    a = r * q
    v = v * q
    let mut off_diag_norm = 0.0
    for i = 0; i < n; i = i + 1 {
      for j = 0; j < n; j = j + 1 {
        if i != j {
          off_diag_norm += a.data[i][j] * a.data[i][j]
        }
      }
    }
    off_diag_norm = Double::sqrt(off_diag_norm)
    if off_diag_norm < tol {
      break
    }
  }
  let eigenvalues = Array::makei(n, fn(i : Int) -> Double { a.data[i][i] })
  let eigenvectors = v
  (eigenvalues, eigenvectors)
}
