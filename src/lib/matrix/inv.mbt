///| Computes the inverse of a square matrix using Gauss-Jordan elimination
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
/// test "matrix_inverse" {
///   // Create a 2x2 matrix
///   let mat = new_matrix([[4.0, 7.0], [2.0, 6.0]])
///   let inverse = mat.inv()
/// 
///   // Expected inverse matrix
///   let expected = new_matrix([[0.6, -0.7], [-0.2, 0.4]])
///   inspect(inverse.approx_eq(expected), content="true")
///   
///   // The product should be id
///   let product = mat * inverse
///   inspect(product.approx_eq(eye(2)), content="true")
/// }
/// 
/// test "panic_matrix_inverse_non_square" {
///   // Create a non-square matrix
///   let mat = new_matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
/// 
///   // Attempting to invert a non-square matrix should panic
///   mat.inv() |> ignore
/// }
/// 
/// test "panic_matrix_inverse_singular" {
///   // Create a singular matrix
///   let mat = new_matrix([[1.0, 2.0], [2.0, 4.0]])
/// 
///   // Attempting to invert a singular matrix should panic
///   mat.inv() |> ignore
/// }
/// ```
pub fn inv(self : Matrix) -> Matrix raise Error {
  if self.rows != self.cols {
    raise MatrixShapeError("The matrix must be square to compute its inverse")
  }
  let dimension = self.rows
  let matrix_copy = self.copy()
  let inv = eye(dimension).data
  for i = 0; i < dimension; i = i + 1 {
    let mut pivot = matrix_copy[i][i]
    if pivot == 0.0 {
      for j = i + 1; j < dimension; j = j + 1 {
        if matrix_copy[j][i] != 0.0 {
          let temp = matrix_copy[i]
          matrix_copy[i] = matrix_copy[j]
          matrix_copy[j] = temp
          let temp_inv = inv[i]
          inv[i] = inv[j]
          inv[j] = temp_inv
          pivot = matrix_copy[i][i]
          break
        }
      }
      if pivot == 0.0 {
        raise MatrixShapeError("The matrix is singular and cannot be inverted")
      }
    }
    for j = 0; j < dimension; j = j + 1 {
      matrix_copy[i][j] /= pivot
      inv[i][j] /= pivot
    }
    for j = 0; j < dimension; j = j + 1 {
      if i != j {
        let factor = matrix_copy[j][i]
        for k = 0; k < dimension; k = k + 1 {
          matrix_copy[j][k] -= factor * matrix_copy[i][k]
          inv[j][k] -= factor * inv[i][k]
        }
      }
    }
  }
  new_matrix(inv)
}
