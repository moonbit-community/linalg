///|
/// Performs Singular Value Decomposition (SVD) of a matrix.
/// Decomposes a matrix A into the product U·Σ·V^T where:
/// - U is an orthogonal matrix
/// - Σ is a diagonal matrix with non-negative real numbers (singular values)
/// - V^T is the transpose of an orthogonal matrix V
///
/// Parameters:
/// * `matrix`: Input matrix to decompose
///
/// Returns a tuple (U, Σ, V) containing the three component matrices
///
/// Example:
/// ```moonbit
/// let a = new_matrix([[3.0, 1.0], [1.0, 3.0]])
/// let (u, s, v) = a.svd()
/// 
/// // Verify A = U·Σ·V^T
/// let vt = v.transpose()
/// let usv = u * (s * vt)
/// inspect(usv.approx_eq(a), content="true")
/// 
/// // Verify U and V are orthogonal
/// let ut = u.transpose()
/// let utu = ut * u
/// let i = eye(2)
/// inspect(utu.approx_eq(i), content="true")
/// 
/// let vt = v.transpose()
/// let vtv = vt * v 
/// inspect(vtv.approx_eq(i), content="true")
/// ```
pub fn Matrix::svd(self : Matrix) -> (Matrix, Matrix, Matrix) raise Error {
  // 计算A^T·A和A·A^T
  let at = self.transpose()
  let ata = at * self // A^T·A 
  let aat = self * at // A·A^T

  // 计算特征值和特征向量
  let (_, v) = ata.eigen() // 右奇异向量
  let (_, u) = aat.eigen() // 左奇异向量

  // 计算奇异值
  let s = zero(self.rows, self.cols)
  let (eigenvals, _) = ata.eigen()
  for i = 0; i < eigenvals.length(); i = i + 1 {
    s.data[i][i] = Double::sqrt(eigenvals[i])
  }

  // 校正U和V的符号,使它们满足A ≈ U·Σ·V^T
  let usv = u * (s * v.transpose())
  for j = 0; j < self.cols; j = j + 1 {
    if (usv.data[0][j] - self.data[0][j]).abs() > 0.0001 {
      // 反转这一列的符号
      for i = 0; i < self.rows; i = i + 1 {
        v.data[i][j] = -v.data[i][j]
      }
    }
  }
  (u, s, v)
}
