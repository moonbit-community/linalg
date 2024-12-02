enum NormType {
  Frobenius
  Infinity
  Zero
  One
  Two
  P(Double)
}

fn pow(a : Double, b : Double) -> Double {
  Double::exp(b * a.ln())
}

fn norm_vector_0(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += (item != 0).to_int().to_double()
  }
  ans
}

fn norm_vector_1(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += item.abs()
  }
  ans
}

fn norm_vector_2(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += item * item
  }
  ans.sqrt()
}

fn norm_vector_p(arr : Array[Double], p : Double) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans += pow(item.abs(), p)
  }
  pow(ans, 1.0 / p)
}

fn norm_vector_inf(arr : Array[Double]) -> Double {
  let mut ans = 0.0
  for item in arr {
    ans = @math.maximum(ans, item.abs())
  }
  ans
}

fn norm_matrix_inf(matrix : Matrix, start : Int, end : Int) -> Double {
  let mut ans = 0.0
  for i = start ; i < end ; i = i + 1 {
    let mut sum = 0.0
    for j = 0 ; j < matrix.cols ; j = j + 1 {
      sum += matrix.data[i][j].abs()
    }
    ans = @math.maximum(ans, sum)
  }
  ans
}

fn norm_matrix_1(matrix : Matrix, start : Int, end : Int) -> Double {
  let mut ans = 0.0
  for j = start ; j < end ; j = j + 1 {
    let mut sum = 0.0
    for i = 0 ; i < matrix.rows ; i = i + 1 {
      sum += matrix.data[i][j].abs()
    }
    ans = @math.maximum(ans, sum)
  }
  ans
}

fn norm_matrix_frobenius(matrix : Matrix, start : Int, end : Int) -> Double {
  let mut ans = 0.0
  for i = start ; i < end ; i = i + 1 {
    for j = 0 ; j < matrix.cols ; j = j + 1 {
      ans += matrix.data[i][j] * matrix.data[i][j]
    }
  }
  ans.sqrt()
}

pub fn norm(self : Matrix, ord~ : NormType = NormType::Two, axis? : (Int, Int)) -> Double {
  let mut ans = 0.0
  match axis {
    None => {
      let tmp = self.flat()
      match ord {
        NormType::Infinity => {
          ans = norm_vector_inf(tmp.data[0])
        }
        NormType::Zero => {
          ans = norm_vector_0(tmp.data[0])
        }
        NormType::One => {
          ans = norm_vector_1(tmp.data[0])
        }
        NormType::Two => {
          ans = norm_vector_2(tmp.data[0])
        }
        NormType::P(p) => {
          ans = norm_vector_p(tmp.data[0], p)
        }
        _ => {
          abort("NormType: Invalid norm type")
        }
      }
    }
    Some((axis0, axis1)) => {
      match ord {
        NormType::Infinity => {
          ans = norm_matrix_inf(self, axis0, axis1)
        }
        NormType::One => {
          ans = norm_matrix_1(self, axis0, axis1)
        }
        NormType::Frobenius => {
          ans = norm_matrix_frobenius(self, axis0, axis1)
        }
        // NormType::Two => {
        //   ans = norm_matrix_2(self, axis0, axis1)
        // On Going...
        // }
        _ => {
          abort("NormType: Invalid norm type")
        }
      }
    }
  }
  ans
}
