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
    abort("MatrixShapeError: Matrices must have the same dimensions for addition")
  }
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] += other.data[i][j]
    }
  }
  self
}

fn op_sub(self : Matrix, other : Matrix) -> Matrix {
  if self.rows != other.rows || self.cols != other.cols {
    abort("MatrixShapeError: Matrices must have the same dimensions for subtraction")
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
  let result = make_matrix(self.rows, other.cols)
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < other.cols; j = j + 1 {
      let mut sum = 0.0
      for k = 0; k < self.cols; k = k + 1 {
        sum += self.data[i][k] * other.data[k][j]
      }
      result[i][j] = sum
    }
  }
  new_matrix(result)
}

pub fn dot(a : Matrix, b : Matrix) -> Double {
  if a.cols != b.cols || a.rows != b.rows {
    abort("MatrixShapeError: Matrices must have the same dimensions for dot product")
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

pub fn shape(self : Matrix) -> (Int, Int) {
  (self.rows, self.cols)
}

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

pub fn k(self : Matrix, k : Double) -> Matrix {
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] *= k
    }
  }
  self
}

pub fn transpose(self : Matrix) -> Matrix {
  let ans = make_matrix(self.cols, self.rows)
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      ans[j][i] = self.data[i][j]
    }
  }
  new_matrix(ans)
}

pub fn zero(rows : Int, cols : Int) -> Matrix {
  let matrix = make_matrix(rows, cols)
  for i = 0; i < rows; i = i + 1 {
    for j = 0; j < cols; j = j + 1 {
      matrix[i][j] = 0
    }
  }
  new_matrix(matrix)
}

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


pub fn print(self : Matrix) -> Unit {
  for item in self.data {
    println(item)
  }
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

pub fn new_matrix(
  data_ : Array[Array[Double]],
  rows~ : Int = data_.length(),
  cols~ : Int = data_[0].length()
) -> Matrix {
  let ans = { rows, cols, data: data_.copy() }
  ans
}

fn main {
  // let m = new_matrix([[1, 2], [2, 3]])
  // let m = new_matrix([[1, 3], [2, 3]])
  let d = diag([1, 2, 3, 4, 5])
  let f = diag([1, 2, 3])
  let s = dot(d, f)
  println(s)
}
