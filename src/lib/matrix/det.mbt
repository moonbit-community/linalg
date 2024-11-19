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

fn subMatrix(self : Matrix, exclude_row : Int, exclude_col : Int) -> Matrix {
  let sub_data = Array::makei(
    self.rows - 1,
    fn(row : Int) -> Array[Double] {
      let actual_row = if row < exclude_row { row } else { row + 1 }
      Array::makei(
        self.cols - 1,
        fn(col : Int) -> Double {
          let actual_col = if col < exclude_col { col } else { col + 1 }
          self.data[actual_row][actual_col]
        },
      )
    },
  )
  new_matrix(sub_data)
}


// fn main {
//   let n = new_matrix([[0 , 1], [1, 2]])
//   println(det(n))
// }
