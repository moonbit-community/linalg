struct Matrix {
  rows : Int
  cols : Int
  data : Array[Array[Double]]
}
// 未来会实现的功能
// struct MatrixView {
//   matrix : Matrix
//   start : Int
//   end : Int
//   rows : Int
//   cols : Int
// }

fn op_add(self : Matrix, other : Matrix) -> Matrix {
  if self.rows != other.rows || self.cols != other.cols {
    abort(
      "MatrixShapeError: Matrices must have the same dimensions for addition",
    )
  }
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] += other.data[i][j]
    }
  }
  self
}

fn op_eq(self : Matrix, other : Matrix) -> Bool {
  if self.rows != other.rows || self.cols != other.cols {
    false
  } else {
    for i = 0; i < self.rows; i = i + 1 {
      for j = 0; j < self.cols; j = j + 1 {
        if self.data[i][j] != other.data[i][j] {
          return false
        }
      }
    }
    true
  }
}

fn op_sub(self : Matrix, other : Matrix) -> Matrix {
  if self.rows != other.rows || self.cols != other.cols {
    abort(
      "MatrixShapeError: Matrices must have the same dimensions for subtraction",
    )
  }
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] -= other.data[i][j]
    }
  }
  self
}

fn op_mul(self : Matrix, other : Matrix) -> Matrix {
  if self.cols != other.rows {
    abort("MatrixShapeError: Incompatible dimensions for matrix multiplication")
  }
  let result_data = make_matrix(self.rows, other.cols)
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < other.cols; j = j + 1 {
      let mut sum = 0.0
      for k = 0; k < self.cols; k = k + 1 {
        sum += self.data[i][k] * other.data[k][j]
      }
      result_data[i][j] = sum
    }
  }
  new_matrix(result_data)
}

/// Calculates the dot product of two matrices of the same shape. Supports both
/// row vectors and column vectors.
///
/// Parameters:
///
/// * `first`: First matrix operand
/// * `second`: Second matrix operand
///
/// Returns the scalar dot product of the two matrices.
///
/// Throws an error if the matrices have different dimensions, with the message
/// "MatrixShapeError: Matrices must have the same dimensions for dot product".
///
/// Examples:
///
/// ```moonbit
/// test "dot/row_vectors" {
///   let a = Matrix::from([[1.0, 2.0, 3.0]])
///   let b = Matrix::from([[4.0, 5.0, 6.0]])
///   inspect!(dot(a, b), content="32.0")
/// }
/// 
/// test "dot/column_vectors" {
///   let a = Matrix::from([[1.0], [2.0], [3.0]])
///   let b = Matrix::from([[4.0], [5.0], [6.0]])
///   inspect!(dot(a, b), content="32.0")
/// }
/// 
/// test "panic/different_dimensions" {
///   let a = Matrix::from([[1.0, 2.0]])
///   let b = Matrix::from([[3.0], [4.0]])
///   // This will panic with "MatrixShapeError: Matrices must have the same dimensions for dot product"
///   dot(a, b)
/// }
/// ```
pub fn dot(a : Matrix, b : Matrix) -> Double {
  if a.cols != b.cols || a.rows != b.rows {
    abort(
      "MatrixShapeError: Matrices must have the same dimensions for dot product",
    )
  }
  let mut ans = 0.0
  if a.rows == 1 {
    for i = 0; i < a.cols; i = i + 1 {
      ans += a.data[0][i] * b.data[0][i]
    }
  } else {
    for i = 0; i < a.rows; i = i + 1 {
      ans += a.data[i][0] * b.data[i][0]
    }
  }
  ans
}

/// Returns the dimensions of a matrix as a tuple of (rows, columns).
///
/// Parameters:
///
/// * `matrix`: A Matrix instance whose dimensions are to be retrieved.
///
/// Returns a tuple `(Int, Int)` where the first element is the number of rows
/// and the second element is the number of columns in the matrix.
///
/// Example:
///
/// ```moonbit
/// test "matrix_shape" {
///   let m = Matrix::new(2, 3, 0) // Create a 2x3 matrix filled with zeros
///   inspect!(m.shape(), content="(2, 3)")
/// }
/// ```
pub fn shape(self : Matrix) -> (Int, Int) {
  (self.rows, self.cols)
}

/// Computes the trace of a square matrix, which is the sum of elements on the
/// main diagonal (from top-left to bottom-right).
///
/// Parameters:
///
/// * `matrix` : A square matrix represented as a `Matrix` instance. The number
/// of rows must equal the number of columns.
///
/// Returns the trace of the matrix as a `Double`.
///
/// Throws:
/// The function aborts with a "MatrixShapeError" message if the input matrix is
/// not square (i.e., number of rows != number of columns).
///
/// Examples:
///
/// ```moonbit
/// test "matrix_trace" {
///   let m = new_matrix(2, 2)
///   m.data[0][0] = 1.0
///   m.data[0][1] = 2.0
///   m.data[1][0] = 3.0
///   m.data[1][1] = 4.0
///   
///   // Trace should be 1.0 + 4.0 = 5.0
///   inspect!(m.tr(), content="5.0")
/// }
/// 
/// test "panic_non_square_matrix" {
///   let m = new_matrix(2, 3)
///   // Should panic when matrix is not square
///   inspect!(m.tr(), content="MatrixShapeError: Matrix must be square to compute trace")
/// }
/// ```
pub fn tr(self : Matrix) -> Double {
  if self.cols != self.rows {
    abort("MatrixShapeError: Matrix must be square to compute trace")
  }
  let mut ans = 0.0
  for i = 0; i < self.cols; i = i + 1 {
    ans += self.data[i][i]
  }
  ans
}

/// Multiplies each element of a matrix by a scalar value, modifying the matrix
/// in place.
///
/// Parameters:
///
/// * `matrix`: The matrix to be scaled. The operation will modify this matrix
/// directly.
/// * `scalar`: A floating-point number to multiply with each element of the
/// matrix.
///
/// Returns the modified matrix after scaling.
///
/// Example:
///
/// ```moonbit
/// test "matrix_scalar_multiplication" {
///   let m = new_matrix([[1.0, 2.0], [3.0, 4.0]])
///   let result = m.k(2.0)
///   inspect!(result.data, content="[[2.0, 4.0], [6.0, 8.0]]")
///   // The original matrix is modified
///   inspect!(m.data, content="[[2.0, 4.0], [6.0, 8.0]]")
/// }
/// ```
pub fn k(self : Matrix, k : Double) -> Matrix {
  self.apply(fn(x : Double) { x * k })
}

/// Transposes a matrix by swapping its rows and columns.
///
/// Parameters:
///
/// * `matrix`: A matrix to be transposed. The input matrix must be valid, i.e.,
/// all rows must have the same length.
///
/// Returns a new matrix where rows and columns are swapped from the input
/// matrix.
///
/// Examples:
///
/// ```moonbit
/// test "transpose/square" {
///   let m = new_matrix([[1, 2], [3, 4]])
///   let mt = transpose(m)
///   inspect!(mt.data, content="[[1, 3], [2, 4]]")
/// }
/// 
/// test "transpose/rectangular" {
///   let m = new_matrix([[1, 2, 3], [4, 5, 6]])
///   let mt = transpose(m)
///   inspect!(mt.data, content="[[1, 4], [2, 5], [3, 6]]")
/// }
/// 
/// test "transpose/twice" {
///   // Transposing a matrix twice returns the original matrix
///   let m = new_matrix([[1, 2], [3, 4]])
///   let mtt = transpose(transpose(m))
///   inspect!(mtt.data, content="[[1, 2], [3, 4]]")
/// }
/// ```
pub fn transpose(self : Matrix) -> Matrix {
  let ans = make_matrix(self.cols, self.rows)
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      ans[j][i] = self.data[i][j]
    }
  }
  new_matrix(ans)
}

/// Creates a new matrix of the specified size with all elements initialized to
/// zero.
///
/// Parameters:
///
/// * `rows`: The number of rows in the matrix.
/// * `cols`: The number of columns in the matrix.
///
/// Returns a new `Matrix` with all elements set to zero.
///
/// Example:
///
/// ```moonbit
/// test "zero matrix" {
///   let m = zero(2, 3)
///   inspect!(m.rows(), content="2")
///   inspect!(m.cols(), content="3")
///   inspect!(m[0][0], content="0")
///   inspect!(m[1][2], content="0")
/// }
/// ```
pub fn zero(rows : Int, cols : Int) -> Matrix {
  let matrix = make_matrix(rows, cols)
  for i = 0; i < rows; i = i + 1 {
    for j = 0; j < cols; j = j + 1 {
      matrix[i][j] = 0
    }
  }
  new_matrix(matrix)
}

/// Creates a square identity matrix of the specified size.
///
/// Parameters:
///
/// * `size`: The dimension of the square matrix. Must be a positive integer.
///
/// Returns a `Matrix` representing an identity matrix where all elements are 0.0
/// except for the diagonal elements which are 1.0.
///
/// Examples:
///
/// ```moonbit
/// test "eye/2x2" {
///   let matrix = eye(2)
///   inspect!(matrix[0][0], content="1.0")
///   inspect!(matrix[0][1], content="0.0")
///   inspect!(matrix[1][0], content="0.0")
///   inspect!(matrix[1][1], content="1.0")
/// }
/// 
/// test "eye/3x3" {
///   let matrix = eye(3)
///   // Check diagonal elements
///   inspect!(matrix[0][0], content="1.0")
///   inspect!(matrix[1][1], content="1.0")
///   inspect!(matrix[2][2], content="1.0")
///   // Check non-diagonal elements
///   inspect!(matrix[0][1], content="0.0")
///   inspect!(matrix[1][2], content="0.0")
///   inspect!(matrix[2][0], content="0.0")
/// }
/// ```
pub fn eye(size : Int) -> Matrix {
  let matrix = make_matrix(size, size)
  for i = 0; i < size; i = i + 1 {
    for j = 0; j < size; j = j + 1 {
      if i != j {
        matrix[i][j] = 0.0
      } else {
        matrix[i][j] = 1.0
      }
    }
  }
  new_matrix(matrix)
}

/// Creates a square diagonal matrix from a given array, where the diagonal
/// elements are taken from the array and all other elements are set to zero.
///
/// Parameters:
///
/// * `array` : An array of double-precision floating-point numbers that will
/// form the diagonal elements of the matrix.
///
/// Returns a `Matrix` structure where:
///
/// * The diagonal elements are filled with values from the input array
/// * All non-diagonal elements are set to 0.0
/// * The dimensions (rows and columns) are equal to the length of the input
/// array
///
/// Example:
///
/// ```moonbit
/// test "diagonal_matrix" {
///   let arr = [1.0, 2.0, 3.0]
///   let matrix = diag(arr)
///   
///   // Check dimensions
///   inspect!(matrix.rows, content="3")
///   inspect!(matrix.cols, content="3")
///   
///   // Check diagonal elements
///   inspect!(matrix.data[0][0], content="1.0")
///   inspect!(matrix.data[1][1], content="2.0")
///   inspect!(matrix.data[2][2], content="3.0")
///   
///   // Check non-diagonal elements
///   inspect!(matrix.data[0][1], content="0.0")
///   inspect!(matrix.data[1][0], content="0.0")
///   inspect!(matrix.data[1][2], content="0.0")
///   inspect!(matrix.data[2][1], content="0.0")
/// }
/// ```
pub fn diag(arr : Array[Double]) -> Matrix {
  let size = arr.length()
  let matrix = make_matrix(size, size)
  for i = 0; i < size; i = i + 1 {
    for j = 0; j < size; j = j + 1 {
      if i != j {
        matrix[i][j] = 0.0
      } else {
        matrix[i][j] = arr[i]
      }
    }
  }
  { rows: size, cols: size, data: matrix }
}

/// Prints each element of the matrix to the standard output, with each element
/// on a new line.
///
/// Parameters:
///
/// * `matrix`: A `Matrix` instance to be printed.
///
/// Example:
///
/// ```moonbit
/// test "print_matrix" {
///   let m = new_matrix(2, 2)
///   print(m)
/// }
/// ```
pub fn print(self : Matrix) -> Unit {
  for item in self.data {
    println(item)
  }
}

/// Solves a system of linear equations represented by matrices A and B in the
/// form AX = B, where X is the solution matrix.
/// Returns the solution matrix X by computing X = A^(-1)B.
///
/// Parameters:
///
/// * `coefficient_matrix`: A square matrix A containing the coefficients of the
/// system of linear equations.
/// * `constant_matrix`: A matrix B containing the constant terms of the system.
///
/// Returns the solution matrix X that satisfies AX = B.
///
/// Throws an error with message "MatrixShapeError: Incompatible dimensions for
/// solving the system of equations" if:
///
/// * The coefficient matrix is not square (rows ≠ columns)
/// * The dimensions of the constant matrix are incompatible with the coefficient
/// matrix
///
/// Example:
///
/// ```moonbit
/// test "solve/simple_system" {
///   // Solve the system:
///   // 2x + y = 5
///   // x + 3y = 10
///   let a = new_matrix([
///     [2.0, 1.0],
///     [1.0, 3.0]
///   ])
///   let b = new_matrix([
///     [5.0],
///     [10.0]
///   ])
///   let x = solve(a, b)
///   // Expected solution: x = 1, y = 3
///   inspect!(x.rows, content="2")
///   inspect!(x.cols, content="1")
///   inspect!(x.data[0][0], content="1.0")
///   inspect!(x.data[0][1], content="3.0")
/// }
/// ```
pub fn solve(a : Matrix, b : Matrix) -> Matrix {
  if a.rows != a.cols && b.rows != a.cols {
    abort(
      "MatrixShapeError: Incompatible dimensions for solving the system of equations",
    )
  }
  a.inv() * b
}

/// Retrieves the element at the specified row and column indices in a matrix.
///
/// Parameters:
///
/// * `matrix`: The matrix from which to retrieve the element.
/// * `row`: The row index of the element (zero-based).
/// * `column`: The column index of the element (zero-based).
///
/// Returns a `Double` value representing the element at the specified position
/// in the matrix.
///
/// Example:
///
/// ```moonbit
/// test "matrix/get" {
///   // Create a 2x2 matrix with elements [[1.0, 2.0], [3.0, 4.0]]
///   let matrix = new_matrix([[1.0, 2.0], [3.0, 4.0]])
///   
///   // Get elements at different positions
///   inspect!(matrix.get(0, 0), content="1.0")
///   inspect!(matrix.get(0, 1), content="2.0")
///   inspect!(matrix.get(1, 0), content="3.0")
///   inspect!(matrix.get(1, 1), content="4.0")
/// }
/// ```
pub fn get(self : Matrix, i : Int, j : Int) -> Double {
  self.data[i][j]
}

/// Applies a function to every element in the matrix, modifying the matrix
/// in-place.
///
/// Parameters:
///
/// * `matrix`: The matrix to be modified.
/// * `transform`: A function that takes a `Double` and returns a `Double`, which
/// will be applied to each element in the matrix.
///
/// Returns the modified matrix.
///
/// Example:
///
/// ```moonbit
/// test "matrix/apply" {
///   let m = new_matrix([[1.0, 2.0], [3.0, 4.0]])
///   let square = fn(x: Double) -> Double { x * x }
///   
///   let result = m.apply(square)
///   inspect!(result.data, content="[[1.0, 4.0], [9.0, 16.0]]")
/// }
/// 
/// test "matrix/apply_with_negative" {
///   let m = ew_matrix([[1.0, -2.0], [-3.0, 4.0]])
///   let abs = fn(x: Double) -> Double { 
///     if x < 0.0 { -x } else { x }
///   }
///   
///   let result = m.apply(abs)
///   inspect!(result.data, content="[[1.0, 2.0], [3.0, 4.0]]")
/// }
/// ```
pub fn apply(self : Matrix, f : (Double) -> Double) -> Matrix {
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] = f(self.data[i][j])
    }
  }
  self
}

/// Flattens a matrix into a 1 x (m\*n) matrix by concatenating all rows
/// horizontally.
///
/// Parameters:
///
/// * `matrix` : A Matrix object to be flattened.
///
/// Returns a new Matrix with dimensions 1 x (m\*n), where m and n are the number
/// of rows and columns of the input matrix respectively.
///
/// Example:
///
/// ```moonbit
/// test "matrix/flat" {
///   let m = Matrix::new(2, 3)
///   m.data[0][0] = 1
///   m.data[0][1] = 2
///   m.data[0][2] = 3
///   m.data[1][0] = 4
///   m.data[1][1] = 5
///   m.data[1][2] = 6
///   
///   let flattened = m.flat()
///   inspect!(flattened.rows, content="1")
///   inspect!(flattened.cols, content="6")
///   inspect!(flattened.data[0], content="[1, 2, 3, 4, 5, 6]")
/// }
/// ```
pub fn flat(self : Matrix) -> Matrix {
  let m = new(1, self.cols * self.rows)
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      m.data[0][i * self.cols + j] = self.data[i][j]
    }
  }
  m
}

/// Creates a new matrix from a 2D array of Double values. If rows and cols are
/// not specified, they will be inferred from the input array dimensions.
///
/// Parameters:
///
/// * `data`: A 2D array of Double values representing the matrix elements. The
/// array must be rectangular (all rows must have the same length).
/// * `rows`: (Optional) The number of rows in the matrix. Defaults to the length
/// of the input array.
/// * `cols`: (Optional) The number of columns in the matrix. Defaults to the
/// length of the first row in the input array.
///
/// Returns a new Matrix instance containing a copy of the input data.
///
/// Examples:
///
/// ```moonbit
/// test "new_matrix/default_dimensions" {
///   let data = [[1.0, 2.0], [3.0, 4.0]]
///   let matrix = new_matrix(data)
///   inspect!(matrix.rows, content="2")
///   inspect!(matrix.cols, content="2")
///   inspect!(matrix.data[0][0], content="1")
///   inspect!(matrix.data[1][1], content="4")
/// }
/// 
/// test "new_matrix/explicit_dimensions" {
///   let data = [[1.0, 2.0, 3.0]]
///   let matrix = new_matrix(data, rows=1, cols=3)
///   inspect!(matrix.rows, content="1")
///   inspect!(matrix.cols, content="3")
///   inspect!(matrix.data[0][2], content="3")
/// }
/// ```
pub fn new_matrix(
  data_ : Array[Array[Double]],
  rows~ : Int = data_.length(),
  cols~ : Int = data_[0].length()
) -> Matrix {
  let ans = { rows, cols, data: data_.copy() }
  ans
}

pub fn Matrix::new(rows : Int, cols : Int) -> Matrix {
  { rows, cols, data: make_matrix(rows, cols) }
}

fn make_matrix(rows : Int, cols : Int) -> Array[Array[Double]] {
  if rows == 0 || cols == 0 {
    [[]]
  } else {
    Array::makei(
      rows,
      fn(row : Int) -> Array[Double] {
        Array::makei(
          cols,
          fn(col : Int) -> Double { (row * cols + col).to_double() },
        )
      },
    )
  }
}

fn main {
  let a = new_matrix([[2.0, 1.0], [1.0, 3.0]]).k(2)
  let b = new_matrix([[5.0], [10.0]]).apply(fn(x) { x * 2.0 })
  let x = solve(a, b)
  println("\{x.get(0,0)}, \{x.get(1,0)}")
}
