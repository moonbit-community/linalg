///|
/// In this fn, we swap two rows (row_1 and row_2) or swap two columns (col_1 and col_2)
/// 
/// Parameters:
///
/// * 'matrix': The matrix you want to swap two columns or two rows.
/// * 'row_1' or 'col_1': The first row or column you want to swap.
/// * 'row_2' or 'col_2': The second row or column you want to swap.
///
/// Returns a new Matrix after swaping the two rows or columns.
///
/// Examples:
/// matrix = [
/// [1, 2, 3, 4]
/// [2, 3, 4, 5]
/// [3, 4, 5, 6]
/// ]
///
/// ```moonbit nocheck
/// let test_matrix = new_matrix([[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]])
/// inspect(
///   test_matrix.exchange_column(1, 2),
///   content="[[1, 3, 2, 4], [2, 4, 3, 5], [3, 5, 4, 6]]",
/// )
/// inspect(
///   test_matrix.exchange_row(1, 2),
///   content="[[1, 2, 3, 4], [3, 4, 5, 6], [2, 3, 4, 5]]",
/// )
/// ```
pub fn Matrix::exchange_row(self : Matrix, row_1 : Int, row_2 : Int) -> Matrix {
  let rows = self.rows
  let final_matrix = new_matrix(self.data)
  if row_1 > rows || row_2 > rows {
    println("These two rows are not within the matrix range!")
    panic()
  } else if row_1 == row_2 {
    println("row_1 == row_2")
    panic()
  }
  let temp = final_matrix.data[row_1]
  final_matrix.data[row_1] = self.data[row_2]
  final_matrix.data[row_2] = temp
  final_matrix
}

///|
pub fn Matrix::exchange_column(
  self : Matrix,
  col_1 : Int,
  col_2 : Int,
) -> Matrix {
  let cols = self.cols
  let final_matrix = new_matrix(self.data)
  let transpose_matrix = Matrix::transpose(final_matrix)
  if col_1 > cols || col_2 > cols {
    println("These two columns are not within the matrix range!")
    panic()
  } else if col_1 == col_2 {
    println("col_1 == col_2")
    panic()
  }
  let change_matrix = Matrix::exchange_row(transpose_matrix, col_1, col_2)
  let final_matrix = Matrix::transpose(change_matrix)
  final_matrix
}

///|
pub fn Matrix::reduced_row_echelon_form(self : Matrix) -> Matrix {
  let columns = self.cols
  let rows = self.rows
  let mut row = 0
  let final_matrix = new_matrix(self.data)
  for col = 0; col < columns; col = col + 1 {
    if row >= rows {
      break
    }
    let mut max_value : Int = row
    // get max rows
    for i = row; i < rows; i = i + 1 {
      if final_matrix.data[i][col].abs() >=
        final_matrix.data[max_value][col].abs() {
        max_value = i
      }
    }
    if final_matrix.data[max_value][col] == 0 {
      continue
    }
    // exchange max_rows with row
    if row != max_value {
      let temp = final_matrix.data[row]
      final_matrix.data[row] = final_matrix.data[max_value]
      final_matrix.data[max_value] = temp
    }
    final_matrix.data[row] = final_matrix.data[row].map(fn(x) {
      x / final_matrix.data[row][col]
    })
    for r = 0; r < rows; r = r + 1 {
      if r != row {
        let factor = final_matrix.data[r][col]
        for column = 0; column < columns; column = column + 1 {
          final_matrix.data[r][column] = final_matrix.data[r][column] -
            factor * final_matrix.data[row][column]
        }
      }
    }
    row += 1
  }
  final_matrix
}

///|
test "rref" {
  let test_matrix = new_matrix([[1.0, 1.0, 1.0, 1.0], [2.0, 3.0, 3.0, 3.0]])
  inspect(
    Matrix::reduced_row_echelon_form(test_matrix),
    content="[[1, 0, 0, 0], [0, 1, 1, 1]]",
  )
}
