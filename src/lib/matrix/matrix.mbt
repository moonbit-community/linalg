///|
struct Matrix {
  rows : Int
  cols : Int
  data : Array[Array[Double]]
}

///|
impl Show for Matrix with output(self : Matrix, logger : &Logger) -> Unit {
  Show::output(self.data, logger)
}

///|
impl ToJson for Matrix with to_json(self : Matrix) -> Json {
  self.data.to_json()
}

///|
suberror MatrixShapeError String derive(Show)

///|
suberror SliceError String derive(Show)

// 未来会实现的功能
// struct MatrixView {
//   matrix : Matrix
//   start : Int
//   end : Int
//   rows : Int
//   cols : Int
// }

///|
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

///|
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

///|
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

///|
impl Mul for Matrix with op_mul(self : Matrix, other : Matrix) -> Matrix {
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

///|
/// Computes the dot product of two matrices. If the matrices have different
/// shapes, they will be flattened into 1D vectors before computation. The dot
/// product is calculated as the sum of element-wise products of the flattened
/// matrices.
///
/// Parameters:
///
/// * `self` : The first matrix operand.
/// * `other` : The second matrix operand to compute the dot product with.
///
/// Returns a scalar value representing the dot product of the two matrices.
///
/// Throws "MatrixShapeError" if the total number of elements in the two matrices
/// are different after flattening.
///
/// Examples:
///
/// ```moonbit
///   // Same shape vectors
///   let a = Matrix::new_matrix([[1.0, 2.0, 3.0]])
///   let b = Matrix::new_matrix([[2.0, 3.0, 4.0]])
///   a.dot(b) // 1*2 + 2*3 + 3*4 = 20
/// 
///   // Different shapes but same total elements
///   let a = Matrix::new_matrix([[1.0, 2.0], [3.0, 4.0]]) // 2x2 matrix
///   let b = Matrix::new_matrix([[1.0, 2.0, 3.0, 4.0]]) // 1x4 vector
///   a.dot(b) // 1*1 + 2*2 + 3*3 + 4*4 = 30
/// 
///   let a = Matrix::new_matrix([[1.0, 2.0, 3.0]])
///   let b = Matrix::new_matrix([[1.0, 2.0]])
///   a.dot(b) // Different total elements
/// ```
pub fn dot(self : Matrix, b : Matrix) -> Double raise MatrixShapeError {
  let self = self.flat()
  let b = b.flat()
  if self.shape() != b.shape() {
    raise MatrixShapeError(
      "Matrices must have the same dimensions for dot product",
    )
  }
  let mut ans = 0.0
  for i = 0; i < self.cols; i = i + 1 {
    ans += self.data[0][i] * b.data[0][i]
  }
  ans
}

///|
/// Computes the dot product of two matrices. If the matrices have different
/// shapes, they will be flattened into 1D vectors before computation. The dot
/// product is calculated as the sum of element-wise products of the flattened
/// matrices.
///
/// Parameters:
///
/// * `self` : The first matrix operand.
/// * `other` : The second matrix operand to compute the dot product with.
///
/// Returns a scalar value representing the dot product of the two matrices.
///
/// Throws "MatrixShapeError" if the total number of elements in the two matrices
/// are different after flattening.
///
/// Examples:
///
/// ```moonbit
/// let a = new_matrix([[1.0, 2.0], [3.0, 4.0]])
/// let b = new_matrix([[2.0, 3.0], [4.0, 5.0]])
/// // 1*2 + 2*3 + 3*4 + 4*5 = 40
/// inspect(a.vdot(b), content="40")
/// ```
pub fn vdot(self : Matrix, b : Matrix) -> Double raise MatrixShapeError {
  if self.shape() != b.shape() {
    raise MatrixShapeError(
      "Matrices must have the same dimensions for dot product",
    )
  }
  let mut ans = 0.0
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      ans += self.data[i][j] * b.data[i][j]
    }
  }
  ans
}

///|
test "vdot" {
  let a = new_matrix([[1.0, 2.0], [3.0, 4.0]])
  let b = new_matrix([[2.0, 3.0], [4.0, 5.0]])
  // 1*2 + 2*3 + 3*4 + 4*5 = 40
  inspect(a.vdot(b), content="40")
}

///|
/// Computes the trace of the matrix, which is the sum of the elements on the main diagonal
/// or a diagonal offset from the main diagonal.
///
/// Parameters:
///
/// * `self` : The matrix to compute the trace of.
/// * `offset` : The offset from the main diagonal. A positive value refers to an upper diagonal,
///   and a negative value refers to a lower diagonal.
///
/// Returns a scalar value representing the trace of the matrix.
///
/// Examples:
///
/// ```moonbit
///   let a = Matrix::new_matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]])
///   a.trace(0) // 1 + 5 + 9 = 15
///   a.trace(1) // 2 + 6 = 8
///   a.trace(-1) // 4 + 8 = 12
/// ```
pub fn trace(self : Matrix, offset : Int) -> Double {
  let mut ans = 0.0
  for i = 0; i < self.rows; i = i + 1 {
    let j = i + offset
    if j >= 0 && j < self.cols {
      ans += self.data[i][j]
    }
  }
  ans
}

///|
test "trace" {
  let m = new_matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]])
  // Trace of the main diagonal
  inspect(m.trace(0), content="15")
  // Trace of the first superdiagonal
  inspect(m.trace(1), content="8")
  // Trace of the first subdiagonal
  inspect(m.trace(-1), content="12")
  // Trace of the second superdiagonal
  inspect(m.trace(2), content="3")
  // Trace of the second subdiagonal
  inspect(m.trace(-2), content="7")
}

///|
pub fn shape(self : Matrix) -> (Int, Int) {
  (self.rows, self.cols)
}

///| Computes the trace of a square matrix, which is the sum of elements on the
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
///   inspect(m.tr(), content="5.0")
/// }
/// ```
pub fn tr(self : Matrix) -> Double raise MatrixShapeError {
  if self.cols != self.rows {
    raise MatrixShapeError("Matrix must be square to compute trace")
  }
  let mut ans = 0.0
  for i = 0; i < self.cols; i = i + 1 {
    ans += self.data[i][i]
  }
  ans
}

///| Multiplies each element of a matrix by a scalar value, modifying the matrix
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
///   inspect(result.data, content="[[2.0, 4.0], [6.0, 8.0]]")
///   // The original matrix is modified
///   inspect(m.data, content="[[2.0, 4.0], [6.0, 8.0]]")
/// }
/// ```
pub fn k(self : Matrix, k : Double) -> Matrix {
  self.apply(fn(x : Double) { x * k })
}

///| Transposes a matrix by swapping its rows and columns.
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
///   inspect(mt.data, content="[[1, 3], [2, 4]]")
/// }
/// 
/// test "transpose/rectangular" {
///   let m = new_matrix([[1, 2, 3], [4, 5, 6]])
///   let mt = transpose(m)
///   inspect(mt.data, content="[[1, 4], [2, 5], [3, 6]]")
/// }
/// 
/// test "transpose/twice" {
///   // Transposing a matrix twice returns the original matrix
///   let m = new_matrix([[1, 2], [3, 4]])
///   let mtt = transpose(transpose(m))
///   inspect(mtt.data, content="[[1, 2], [3, 4]]")
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

///| Creates a new matrix of the specified size with all elements initialized to
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
///   inspect(m.rows(), content="2")
///   inspect(m.cols(), content="3")
///   inspect(m[0][0], content="0")
///   inspect(m[1][2], content="0")
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

///| Creates a square identity matrix of the specified size.
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
///   inspect(matrix[0][0], content="1.0")
///   inspect(matrix[0][1], content="0.0")
///   inspect(matrix[1][0], content="0.0")
///   inspect(matrix[1][1], content="1.0")
/// }
/// 
/// test "eye/3x3" {
///   let matrix = eye(3)
///   // Check diagonal elements
///   inspect(matrix[0][0], content="1.0")
///   inspect(matrix[1][1], content="1.0")
///   inspect(matrix[2][2], content="1.0")
///   // Check non-diagonal elements
///   inspect(matrix[0][1], content="0.0")
///   inspect(matrix[1][2], content="0.0")
///   inspect(matrix[2][0], content="0.0")
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

///| Creates a square diagonal matrix from a given array, where the diagonal
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
///   inspect(matrix.rows, content="3")
///   inspect(matrix.cols, content="3")
///   
///   // Check diagonal elements
///   inspect(matrix.data[0][0], content="1.0")
///   inspect(matrix.data[1][1], content="2.0")
///   inspect(matrix.data[2][2], content="3.0")
///   
///   // Check non-diagonal elements
///   inspect(matrix.data[0][1], content="0.0")
///   inspect(matrix.data[1][0], content="0.0")
///   inspect(matrix.data[1][2], content="0.0")
///   inspect(matrix.data[2][1], content="0.0")
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

///| Prints each element of the matrix to the standard output, with each element
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

///| Solves a system of linear equations represented by matrices A and B in the
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
///   inspect(x.rows, content="2")
///   inspect(x.cols, content="1")
///   inspect(x.data[0][0], content="1.0")
///   inspect(x.data[0][1], content="3.0")
/// }
/// ```
pub fn solve(a : Matrix, b : Matrix) -> Matrix raise Error {
  if a.rows != a.cols && b.rows != a.cols {
    raise MatrixShapeError(
      "Coefficient matrix must be square and constant matrix must have the same number of rows as the coefficient matrix",
    )
  }
  match (try? a.inv()) {
    Ok(inv) => inv * b
    Err(e) => raise e
  }
}

///| Retrieves the element at the specified row and column indices in a matrix.
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
///   inspect(matrix.get(0, 0), content="1.0")
///   inspect(matrix.get(0, 1), content="2.0")
///   inspect(matrix.get(1, 0), content="3.0")
///   inspect(matrix.get(1, 1), content="4.0")
/// }
/// ```
pub fn get(self : Matrix, i : Int, j : Int) -> Double {
  self.data[i][j]
}

///| Applies a function to every element in the matrix, modifying the matrix
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
///   inspect(result.data, content="[[1.0, 4.0], [9.0, 16.0]]")
/// }
/// 
/// test "matrix/apply_with_negative" {
///   let m = ew_matrix([[1.0, -2.0], [-3.0, 4.0]])
///   let abs = fn(x: Double) -> Double { 
///     if x < 0.0 { -x } else { x }
///   }
///   
///   let result = m.apply(abs)
///   inspect(result.data, content="[[1.0, 2.0], [3.0, 4.0]]")
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

///|
/// Calculates the rank of a matrix using Gaussian elimination method. The rank
/// is defined as the number of linearly independent rows or columns in the
/// matrix.
///
/// Parameters:
///
/// * `matrix`: A matrix whose rank needs to be calculated.
///
/// Returns an integer representing the rank of the matrix.
///
/// Examples:
///
/// ```moonbit
/// test "rank/full_rank" {
///   // Create a 2x2 matrix with full rank
///   let m = new_matrix([[1.0, 0.0], [0.0, 1.0]])
///   inspect(m.rank(), content="2")
/// }
/// 
/// test "rank/not_full_rank" {
///   // Create a 3x3 matrix with rank 2
///   let m = new_matrix(
///     [
///       [1.0, 2.0, 3.0],
///       [2.0, 4.0, 6.0], // This row is twice the first row
///       [0.0, 1.0, 0.0],
///     ],
///   )
///   inspect(m.rank(), content="2")
/// }
/// 
/// test "rank/zero_matrix" {
///   // Create a zero matrix
///   let m = zero(3, 3)
///   inspect(m.rank(), content="0")
/// }
/// 
/// test "rank/rectangular" {
///   // Create a 2x3 matrix
///   let m = new_matrix([[1.0, 0.0, 2.0], [0.0, 3.0, 4.0]])
///   inspect(m.rank(), content="2")
/// }
/// ```
pub fn rank(self : Matrix) -> Int {
  let matrix_copy = self.data.copy()
  let mut rank = 0
  let rows = self.rows
  let cols = self.cols
  for col = 0; col < cols; col = col + 1 {
    let mut pivot_row = -1
    for row = rank; row < rows; row = row + 1 {
      if matrix_copy[row][col] != 0.0 {
        pivot_row = row
        break
      }
    }
    if pivot_row == -1 {
      continue
    }
    if pivot_row != rank {
      let temp = matrix_copy[rank]
      matrix_copy[rank] = matrix_copy[pivot_row]
      matrix_copy[pivot_row] = temp
    }
    let pivot_value = matrix_copy[rank][col]
    if pivot_value == 0.0 {
      continue
    }
    for row = rank + 1; row < rows; row = row + 1 {
      let factor = matrix_copy[row][col] / pivot_value
      for k = col; k < cols; k = k + 1 {
        matrix_copy[row][k] -= factor * matrix_copy[rank][k]
      }
    }
    rank = rank + 1
  }
  rank
}

///|
/// Creates a submatrix by extracting a rectangular region from an existing
/// matrix using specified row and column ranges.
///
/// Parameters:
///
/// * `matrix`: The source matrix from which to extract the slice.
/// * `row_start`: The starting row index (inclusive) of the slice.
/// * `row_end`: The ending row index (exclusive) of the slice.
/// * `col_start`: The starting column index (inclusive) of the slice.
/// * `col_end`: The ending column index (exclusive) of the slice.
///
/// Returns a new matrix containing the specified slice of the original matrix.
///
/// Throws an error with message "SliceError: Invalid row indices" if:
///
/// * `row_start` is negative
/// * `row_end` exceeds the number of rows in the matrix
/// * `row_start` is greater than `row_end`
///
/// Throws an error with message "SliceError: Invalid column indices" if:
///
/// * `col_start` is negative
/// * `col_end` exceeds the number of columns in the matrix
/// * `col_start` is greater than `col_end`
///
/// Examples:
///
/// ```moonbit
/// test "slice/basic" {
///   let m = new_matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]])
/// 
///   // Extract 2x2 submatrix from the middle
///   let slice = m.slice(0, 2, 1, 3)
///   inspect(slice.rows, content="2")
///   inspect(slice.cols, content="2")
///   inspect(slice.data, content="[[2.0, 3.0], [5.0, 6.0]]")
/// }
/// ```
pub fn slice(
  self : Matrix,
  row_start : Int,
  row_end : Int,
  col_start : Int,
  col_end : Int
) -> Matrix raise SliceError {
  if row_start < 0 || row_end > self.rows || row_start > row_end {
    raise SliceError("Invalid row indices")
  }
  if col_start < 0 || col_end > self.cols || col_start > col_end {
    raise SliceError("Invalid column indices")
  }
  let new_rows = row_end - row_start
  let new_cols = col_end - col_start
  let new_data = Array::makei(new_rows, fn(i : Int) -> Array[Double] {
    Array::makei(new_cols, fn(j : Int) -> Double {
      self.data[row_start + i][col_start + j]
    })
  })
  new_matrix(new_data)
}

///| Flattens a matrix into a 1 x (m\*n) matrix by concatenating all rows
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
///   inspect(flattened.rows, content="1")
///   inspect(flattened.cols, content="6")
///   inspect(flattened.data[0], content="[1, 2, 3, 4, 5, 6]")
/// }
/// ```
pub fn flat(self : Matrix) -> Matrix {
  self.reshape(1, self.cols * self.rows)
}

///| Reshapes a matrix into a new matrix with specified dimensions, preserving the
/// elements in row-major order.
///
/// Parameters:
///
/// * `matrix` : The original matrix to be reshaped.
/// * `rows` : The number of rows in the new matrix.
/// * `cols` : The number of columns in the new matrix.
///
/// Returns a new matrix with the specified dimensions containing all elements
/// from the input matrix.
///
/// Example:
///
/// ```moonbit
/// test "reshape" {
///   // Create a 2x3 matrix
///   let m = new_matrix([[1, 2, 3], [4, 5, 6]])
///   
///   // Reshape to 3x2 matrix
///   let reshaped = m.reshape(3, 2)
///   
///   // The elements are preserved in row-major order
///   inspect(reshaped.data, content="[[1, 2], [3, 4], [5, 6]]")
/// }
/// 
/// test "reshape/identity" {
///   // Reshaping to same dimensions should return equivalent matrix
///   let m = new_matrix([[1, 2], [3, 4]])
///   let reshaped = m.reshape(2, 2)
///   inspect(reshaped.data, content="[[1, 2], [3, 4]]")
/// }
/// ```
pub fn reshape(self : Matrix, rows : Int, cols : Int) -> Matrix {
  let m = zero(rows, cols)
  for i = 0; i < self.rows * self.cols; i = i + 1 {
    let old_row = i / self.cols
    let old_col = i % self.cols
    let new_row = i / cols
    let new_col = i % cols
    m.data[new_row][new_col] = self.data[old_row][old_col]
  }
  m
}

///|
/// Creates a new matrix from a two-dimensional array of double-precision
/// floating-point numbers. If the dimensions are not explicitly specified, they
/// will be inferred from the input array.
///
/// Parameters:
///
/// * `data` : A two-dimensional array of type `Array[Array[Double]]` containing
/// the matrix elements.
/// * `rows` : Optional. The number of rows in the matrix. Defaults to the number
/// of arrays in `data`.
/// * `cols` : Optional. The number of columns in the matrix. Defaults to the
/// length of the first array in `data`.
///
/// Returns a new `Matrix` instance containing a deep copy of the input data.
///
/// Examples:
///
/// ```moonbit
/// test "new_matrix/default_dimensions" {
///   // Create a 2x2 matrix with default dimensions
///   let data = [[1.0, 2.0], [3.0, 4.0]]
///   let matrix = new_matrix(data)
///   inspect(matrix.shape(), content="(2, 2)")
///   inspect(matrix.data[0][0], content="1.0")
/// }
/// 
/// test "new_matrix/explicit_dimensions" {
///   // Create a matrix with explicit dimensions
///   let data = [[1.0, 2.0, 3.0]]
///   let matrix = new_matrix(data, rows=1, cols=3)
///   inspect(matrix.shape(), content="(1, 3)")
/// }
/// ```
pub fn copy(self : Matrix) -> Matrix {
  let data = self.data.copy()
  new_matrix(data)
}

///| Creates a new matrix from a 2D array of Double values. If rows and cols are
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
///   inspect(matrix.rows, content="2")
///   inspect(matrix.cols, content="2")
///   inspect(matrix.data[0][0], content="1")
///   inspect(matrix.data[1][1], content="4")
/// }
/// 
/// test "new_matrix/explicit_dimensions" {
///   let data = [[1.0, 2.0, 3.0]]
///   let matrix = new_matrix(data, rows=1, cols=3)
///   inspect(matrix.rows, content="1")
///   inspect(matrix.cols, content="3")
///   inspect(matrix.data[0][2], content="3")
/// }
/// ```
pub fn new_matrix(
  data_ : Array[Array[Double]],
  rows? : Int,
  cols? : Int
) -> Matrix {
  let rows = rows.or(data_.length())
  let cols = cols.or(data_[0].length())
  let ans = { rows, cols, data: data_.copy() }
  ans
}

///|
pub fn Matrix::new(rows : Int, cols : Int) -> Matrix {
  { rows, cols, data: make_matrix(rows, cols) }
}

///|
fn make_matrix(rows : Int, cols : Int) -> Array[Array[Double]] {
  if rows == 0 || cols == 0 {
    [[]]
  } else {
    Array::makei(rows, fn(row : Int) -> Array[Double] {
      Array::makei(cols, fn(col : Int) -> Double {
        (row * cols + col).to_double()
      })
    })
  }
}

///|
test {
  // let a = new_matrix([
  //   [3.0, 0.0],
  //   [0.0, 4.0]
  // ])
  // let (eigenvalues, eigenvectors) = a.eigen()
  // println(eigenvalues)
  // eigenvectors.print()
  let a = new_matrix([[3.0, 1.0], [1.0, 3.0]])
  let (u, s, v) = a.svd()
  @json.inspect(u, content=[
    [0.70710678118912, -0.707106781183975],
    [0.7071067811839754, 0.7071067811891202],
  ])
  @json.inspect(s, content=[[4, 0], [0, 2]])
  @json.inspect(v, content=[
    [0.70710678118912, -0.707106781183975],
    [0.7071067811839754, 0.7071067811891202],
  ])
  @json.inspect(u * s * v.transpose(), content=[
    [3.0000000000072755, 1.0000000000000007],
    [1.0000000000000007, 2.9999999999927267],
  ])
}
