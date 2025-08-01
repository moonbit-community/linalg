///| Calculates the determinant of a square matrix using the Laplace expansion
/// along the first row.
///
/// Parameters:
///
/// * `matrix`: A square matrix whose determinant needs to be calculated.
///
/// Returns a Double value representing the determinant of the matrix.
///
/// Example:
///
/// ```moonbit
/// test "determinant" {
///   let m1 = Matrix::new(1, 1)
///   m1.data[0][0] = 5.0
///   inspect(m1.det(), content="5.0")
/// 
///   let m2 = Matrix::new(2, 2)
///   m2.data[0][0] = 1.0
///   m2.data[0][1] = 2.0
///   m2.data[1][0] = 3.0
///   m2.data[1][1] = 4.0
///   inspect(m2.det(), content="-2.0") // 1*4 - 2*3 = -2
/// }
/// ```
pub fn det(self : Matrix) -> Double {
  if self.rows == 1 {
    return self.data[0][0]
  }
  if self.rows == 2 {
    return self.data[0][0] * self.data[1][1] - self.data[0][1] * self.data[1][0]
  }
  let mut det = 0.0
  for col = 0; col < self.cols; col = col + 1 {
    let sub_matrix = self.subMatrix(0, col)
    let sign = if col % 2 == 0 { 1.0 } else { -1.0 }
    det += sign * self.data[0][col] * sub_matrix.det()
  }
  det
}

///|
fn subMatrix(self : Matrix, exclude_row : Int, exclude_col : Int) -> Matrix {
  let sub_data = Array::makei(self.rows - 1, fn(row : Int) -> Array[Double] {
    let actual_row = if row < exclude_row { row } else { row + 1 }
    Array::makei(self.cols - 1, fn(col : Int) -> Double {
      let actual_col = if col < exclude_col { col } else { col + 1 }
      self.data[actual_row][actual_col]
    })
  })
  new_matrix(sub_data)
}

// fn main {
//   let m1 = Matrix::new(1, 1)
//   m1.data[0][0] = 5.0
//   println(m1.det())
//   // inspect(m1.det(), content="5.0")

//   let m2 = Matrix::new(2, 2)
//   m2.data[0][0] = 1.0
//   m2.data[0][1] = 2.0
//   m2.data[1][0] = 3.0
//   m2.data[1][1] = 4.0
//   // inspect(m2.det(), content="-2.0") // 1*4 - 2*3 = -2
//   println(m2.det())
// }
