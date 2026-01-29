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
/// ```moonbit check
/// test {
///   let a = new_matrix([
///     [12.0, -51.0, 4.0],
///     [6.0, 167.0, -68.0],
///     [-4.0, 24.0, -41.0],
///   ])
///   let (q, r) = a.qr()
///   // // Verify Q is orthogonal (Q^T Q ≈ I)
///   let qt = q.transpose()
///   let qtq = qt * q
///   let i = eye(3)
///   inspect(qtq.approx_eq(i), content="true")
///   // // Verify R is upper triangular
///   for i = 1; i < 3; i = i + 1 {
///     for j = 0; j < i; j = j + 1 {
///       inspect(r[i][j].abs() < 1.0e-10, content="true")
///     }
///   }
///   // // Verify A = QR
///   let a2 = q * r
///   inspect(a2.approx_eq(a), content="true")
/// }
/// ```
pub fn Matrix::qr(self : Matrix) -> (Matrix, Matrix) raise Error {
  if self.rows < self.cols {
    abort(
      "MatrixShapeError: Cannot perform QR decomposition, rows must be >= cols",
    )
  }
  let m = self.rows
  let n = self.cols
  let q = zero(m, n)
  let r = zero(n, n)

  // Gram-Schmidt
  for j = 0; j < n; j = j + 1 {
    let v = zero(m, 1)
    for i = 0; i < m; i = i + 1 {
      v.data[i][0] = self.data[i][j]
    }
    for i = 0; i < j; i = i + 1 {
      let qi = zero(m, 1)
      for k = 0; k < m; k = k + 1 {
        qi.data[k][0] = q.data[k][i]
      }
      r.data[i][j] = qi.dot(v)
      for k = 0; k < m; k = k + 1 {
        v.data[k][0] -= r.data[i][j] * qi.data[k][0]
      }
    }

    // 列向量的范数
    r.data[j][j] = v.norm(ord=NormType::Two, axis=Vector)

    // 检查奇异性
    if r.data[j][j] < 0.0000000001 {
      abort("MatrixError: Matrix is rank deficient")
    }
    for i = 0; i < m; i = i + 1 {
      q.data[i][j] = v.data[i][0] / r.data[j][j]
    }
  }
  (q, r)
}
