///|
enum NormType {
  Frobenius
  Infinity
  Zero
  One
  Two
  P(Double)
}

///|
enum Type {
  Matrix
  Vector
}

///|
fn pow(a : Double, b : Double) -> Double {
  Double::exp(b * a.ln())
}

///|
fn norm_vector_0(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += (item != 0).to_int().to_double()
  }
  ans
}

///|
fn norm_vector_1(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += item.abs()
  }
  ans
}

///|
fn norm_vector_2(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += item * item
  }
  ans.sqrt()
}

///|
fn norm_vector_p(arr : Array[Double], p : Double) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += pow(item.abs(), p)
  }
  pow(ans, 1.0 / p)
}

///|
fn norm_vector_inf(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans = @math.maximum(ans, item.abs())
  }
  ans
}

///|
fn norm_matrix_inf(matrix : Matrix) -> Double {
  let mut ans = 0.0
  for i = 0; i < matrix.rows; i = i + 1 {
    let mut sum = 0.0
    for j = 0; j < matrix.cols; j = j + 1 {
      sum += matrix.data[i][j].abs()
    }
    ans = @math.maximum(ans, sum)
  }
  ans
}

///|
fn norm_matrix_1(matrix : Matrix) -> Double {
  let mut ans = 0.0
  for j = 0; j < matrix.cols; j = j + 1 {
    let mut sum = 0.0
    for i = 0; i < matrix.rows; i = i + 1 {
      sum += matrix.data[i][j].abs()
    }
    ans = @math.maximum(ans, sum)
  }
  ans
}

///|
fn norm_matrix_frobenius(matrix : Matrix) -> Double {
  let mut ans = 0.0
  for i = 0; i < matrix.rows; i = i + 1 {
    for j = 0; j < matrix.cols; j = j + 1 {
      ans += matrix.data[i][j] * matrix.data[i][j]
    }
  }
  ans.sqrt()
}

///|
fn power_iteration(a : Matrix, iterations : Int) -> Double {
  let n = a.rows
  let b_k = zero(n, 1)
  b_k.data[0][0] = 1.0 // 初始向量
  for i = 0; i < iterations; i = i + 1 {
    // b_k1 = A * b_k
    let b_k1 = a * b_k

    // 计算 ||b_k1||
    let norm = norm_vector_2(b_k1.data[0])

    // b_k = b_k1 / ||b_k1||
    for i = 0; i < n; i = i + 1 {
      b_k.data[i][0] = b_k1.data[i][0] / norm
    }
  }

  // Rayleigh商作为特征值的近似
  let ab = a * b_k
  let mut numerator = 0.0
  let mut denominator = 0.0
  for i = 0; i < a.rows; i = i + 1 {
    numerator += b_k.data[i][0] * ab.data[i][0]
    denominator += b_k.data[i][0] * b_k.data[i][0]
  }
  numerator / denominator
}

///|
fn norm_matrix_2(matrix : Matrix) -> Double {
  let ata = matrix.transpose() * matrix
  let max_eigen = power_iteration(ata, 100)
  max_eigen.sqrt()
}

///|
/// Calculates various types of norms for matrices and vectors. For vectors, the
/// matrix is first flattened into a 1D array. For matrices, different matrix
/// norms are computed based on the specified norm type.
///
/// Parameters:
///
/// * `matrix`: The input matrix for which to calculate the norm.
/// * `norm_type`: The type of norm to calculate (default: `NormType::Two`).
/// Available options:
///  * For vectors (when `axis` is `Vector`):
///  * `Zero`: Counts the number of non-zero elements
///  * `One`: Manhattan/Taxicab norm (sum of absolute values)
///  * `Two`: Euclidean norm (square root of sum of squares)
///  * `P(p)`: p-norm where p is a positive real number
///  * `Infinity`: Maximum absolute value
///  * For matrices (when `axis` is `Matrix`):
///  * `One`: Maximum absolute column sum
///  * `Two`: Spectral norm (square root of largest eigenvalue of A^T A)
///  * `Frobenius`: Square root of sum of squared elements
///  * `Infinity`: Maximum absolute row sum
///  * `axis`: Specifies whether to treat the input as a vector or matrix
/// (default: `Vector`)
///
/// Returns a `Double` value representing the calculated norm.
///
/// Throws an error with message "NormType: Invalid norm type" if an unsupported
/// norm type is specified for the chosen axis.
///
/// Examples:
///
/// ```moonbit
/// test "norm/vector" {
///   // Vector norms
///   let v = new_matrix([[1.0, -2.0, 3.0]])
/// 
///   // L1 norm (Manhattan)
///   inspect(v.norm(ord=NormType::One), content="6.0")
/// 
///   // L2 norm (Euclidean)
///   inspect(v.norm(ord=NormType::Two), content="3.7416573867739413")
/// 
///   // L∞ norm (Maximum)
///   inspect(v.norm(ord=NormType::Infinity), content="3.0")
/// }
/// 
/// test "norm/matrix" {
///   // Matrix norms
///   let m = new_matrix([[1.0, 2.0], [-3.0, 4.0]])
/// 
///   // Frobenius norm
///   inspect(
///     m.norm(ord=NormType::Frobenius, axis=Matrix),
///     content="5.477225575051661",
///   )
/// 
///   // Maximum absolute row sum (infinity norm)
///   inspect(m.norm(ord=NormType::Infinity, axis=Matrix), content="7.0")
/// }
/// ```
pub fn norm(
  self : Matrix,
  ord~ : NormType = NormType::Two,
  axis~ : Type = Vector,
) -> Double {
  let mut ans = 0.0
  match axis {
    Vector => {
      let tmp = self.flat()
      match ord {
        NormType::Infinity => ans = norm_vector_inf(tmp.data[0])
        NormType::Zero => ans = norm_vector_0(tmp.data[0])
        NormType::One => ans = norm_vector_1(tmp.data[0])
        NormType::Two => ans = norm_vector_2(tmp.data[0])
        NormType::P(p) => ans = norm_vector_p(tmp.data[0], p)
        _ => abort("NormType: Invalid norm type")
      }
    }
    Matrix =>
      match ord {
        NormType::One => ans = norm_matrix_1(self)
        NormType::Two => ans = norm_matrix_2(self)
        NormType::Frobenius => ans = norm_matrix_frobenius(self)
        NormType::Infinity => ans = norm_matrix_inf(self)
        _ => abort("NormType: Invalid norm type")
      }
  }
  ans
}
