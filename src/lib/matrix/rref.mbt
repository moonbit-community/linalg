// pub fn rref(self: Matrix) -> Matrix{
//   ...
// }

///|
pub fn exchange_row(self : Matrix, row_1 : Int, row_2 : Int) -> Matrix {
  let copy_matrix : Matrix = self
  let rows : Int = self.rows
  let columns : Int = self.cols
  let final_matrix : Matrix = new_matrix(self.data)
  let mut judge : Bool = true
  if row_1 > rows || row_2 > rows {
    println("These two rows are not within the matrix range!")
    panic()
  }else if row_1 == row_2{
    println("row_1 == row_2")
    panic()
  }
  let temp = self.data[row_1]
  self.data[row_1]=self.data[row_2]
  self.data[row_2]=temp
  final_matrix
}

// pub fn exchange_column(self: Matrix) -> Matrix{

// }

///|
fn fib(x : Int) -> Int {
  if x == 1 || x == 2 {
    1
  } else {
    fib(x - 2) + fib(x - 1)
  }
}

///|
test "name" {
  inspect!(fib(5), content="5")
}
