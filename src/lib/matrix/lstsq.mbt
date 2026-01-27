///|
/// Computes the least-squares solution to a linear matrix equation.
///
/// Parameters:
/// * `a`: (M, N) array - "Coefficient" matrix
/// * `b`: (M,) array - Ordinate ("dependent variable") values
///
/// Returns:
/// * The least-squares solution to the equation ax = b
///
/// Example:
/// ```moonbit nocheck
/// // Solve the overdetermined system:
/// // 1x + 1y = 2
/// // 2x + 1y = 3
/// // 1x + 2y = 4
/// let a = new_matrix([
///   [1.0, 1.0],
///   [2.0, 1.0],
///   [1.0, 2.0]
/// ])
/// let b = new_matrix([[2.0], [3.0], [4.0]])
///
/// let x = lstsq(a, b)
/// // Expected solution: x ≈ 1, y ≈ 1.5
/// // 我 debug 半天发现是算错了，最小二乘解明明是 {7/11, 18/11}
/// inspect(x.approx_eq(new_matrix([[7.0/11.0],[18.0/11.0]])), content="true")
/// ```
pub fn lstsq(a : Matrix, b : Matrix) -> Matrix raise Error {
  if a.rows < a.cols {
    abort("MatrixShapeError: System is underdetermined")
  }
  if a.rows != b.rows {
    abort("MatrixShapeError: Incompatible dimensions")
  }

  // 计算QR分解
  let (q, r) = a.qr()

  // 计算 Q^T * b
  let qtb = q.transpose() * b

  // 解上三角系统 Rx = Q^T b
  // 只需要前n行,其中n是a的列数
  let n = a.cols
  let x = zero(n, 1)

  // Back substitution
  for i = n - 1; i >= 0; i = i - 1 {
    let mut sum = qtb.data[i][0]
    for j = i + 1; j < n; j = j + 1 {
      sum -= r.data[i][j] * x.data[j][0]
    }
    x.data[i][0] = sum / r.data[i][i]
  }
  x
}

///|
test {
  // 构造超定方程组:
  // 1x + 2y = 4
  // 2x + 1y = 5
  // 1x + 1y = 3
  let a = new_matrix([[1.0, 2.0], [2.0, 1.0], [1.0, 1.0]])
  let b = new_matrix([[4.0], [5.0], [3.0]])
  let x = lstsq(a, b)
  inspect(x.approx_eq(new_matrix([[2.0], [1.0]])), content="true")

  // 验证解的正确性: Ax ≈ b
  let ax = a * x
  inspect(ax.approx_eq(new_matrix([[4.0], [5.0], [3.0]])), content="true")
}
