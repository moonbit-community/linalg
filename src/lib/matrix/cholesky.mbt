///|
/// Performs Cholesky decomposition of a positive-definite matrix.
/// Decomposes a matrix A into the product L·L^T where L is a lower triangular matrix.
///
/// Parameters:
/// * `matrix`: Input matrix to decompose. Must be positive-definite.
///
/// Returns a lower triangular matrix L such that A = L·L^T.
///
/// Throws:
/// * `MatrixShapeError` if the input matrix is not square.
/// * `MatrixError` if the input matrix is not positive-definite.
///
/// Example:
/// ```moonbit
/// let a = new_matrix([[4.0, 12.0, -16.0], [12.0, 37.0, -43.0], [-16.0, -43.0, 98.0]])
/// let l = a.cholesky()
/// 
/// // Verify L is lower triangular
/// for i = 0; i < l.rows; i = i + 1 {
///   for j = i + 1; j < l.cols; j = j + 1 {
///     inspect(l[i][j] == 0.0, content="true")
///   }
/// }
/// 
/// // Verify A = L·L^T
/// let lt = l.transpose()
/// let a2 = l * lt
/// inspect(a2.approx_eq(a), content="true")
/// ```
pub fn Matrix::cholesky(self : Matrix) -> Matrix {
  if self.rows != self.cols {
    abort("MatrixShapeError: Matrix must be square for Cholesky decomposition")
  }
  let n = self.rows
  let l = zero(n, n)
  for i = 0; i < n; i = i + 1 {
    for j = 0; j <= i; j = j + 1 {
      let mut sum = 0.0
      for k = 0; k < j; k = k + 1 {
        sum += l.data[i][k] * l.data[j][k]
      }
      if i == j {
        l.data[i][j] = Double::sqrt(self.data[i][i] - sum)
      } else {
        l.data[i][j] = (self.data[i][j] - sum) / l.data[j][j]
      }
    }
    if l.data[i][i] <= 0.0 {
      abort("MatrixError: Matrix is not positive-definite")
    }
  }
  l
}
