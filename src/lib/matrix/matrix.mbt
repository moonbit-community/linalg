type! MatrixShapeError String

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

fn op_add!(self : Matrix, other : Matrix) -> Matrix {
  if self.rows != other.rows || self.cols != other.cols {
    raise MatrixShapeError("MatrixShapeError")
  }
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] += other.data[i][j]
    }
  }
  self
}

fn op_sub!(self : Matrix, other : Matrix) -> Matrix {
  if self.rows != other.rows || self.cols != other.cols {
    raise MatrixShapeError("MatrixShapeError")
  }
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] -= other.data[i][j]
    }
  }
  self
}

fn op_mul!(self : Matrix, other : Matrix) -> Matrix {
  if self.cols != other.rows {
    raise MatrixShapeError(
      "MatrixShapeError: Incompatible dimensions for matrix multiplication",
    )
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

pub fn dot!(a : Matrix, b : Matrix) -> Double {
  if (a.rows != b.rows && a.cols != b.cols) || (a.rows != 1 && a.cols != 1) {
    raise MatrixShapeError("MatrixShapeError")
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

pub fn k(self : Matrix, k : Double) -> Matrix {
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      self.data[i][j] *= k
    }
  }
  self
}

pub fn pow(self : Matrix, k : Double) -> Matrix {
  for i = 0; i < self.rows; i = i + 1 {
    for j = 0; j < self.cols; j = j + 1 {
      
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

fn new_matrix(
  data_ : Array[Array[Double]],
  rows~ : Int = data_.length(),
  cols~ : Int = data_[0].length()
) -> Matrix {
  let ans = { rows: rows, cols: cols, data: data_.copy() }
  ans
}

pub fn zero(rows : Int, cols : Int) -> Matrix {
  {rows : rows, cols : cols, data : make_matrix(rows, cols)}
}

pub fn make_matrix(rows : Int, cols : Int) -> Array[Array[Double]] {
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
  let m = new_matrix([[1, 2], [2, 3]])
  println(m.k(4).shape())
}


