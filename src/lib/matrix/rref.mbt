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
/// ```moonbit
/// test "name" {
///   let test_matrix = new_matrix([[1,2,3,4], [2,3,4,5], [3,4,5,6]])
///   inspect!(exchange_column(test_matrix, 1, 2), content="[[1, 2, 3, 4], [3, 4, 5, 6], [2, 3, 4, 5]]")
///   inspect!(exchange_row(test_matrix, 1, 2), content="[[1, 2, 3, 4], [3, 4, 5, 6], [2, 3, 4, 5]]")
/// }
/// 
/// ```

pub fn exchange_row(self : Matrix, row_1 : Int, row_2 : Int) -> Matrix {
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

pub fn exchange_column(self : Matrix, col_1 : Int, col_2 : Int) -> Matrix {
  let cols = self.cols
  let final_matrix = new_matrix(self.data)
  if col_1 > cols || col_2 > cols {
    println("These two columns are not within the matrix range!")
    panic()
  } else if col_1 == col_2 {
    println("col_1 == col_2")
    panic()
  }
  let temp = final_matrix.data[:][col_1]
  final_matrix.data[:][col_1] = self.data[:][col_2]
  final_matrix.data[:][col_2] = temp
  final_matrix
}
