enum NormType {
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
    ans += ((item != 0).to_int()).to_double()
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
      }
    }
    Some(_) => ()
    // Some((axis0, axis1)) => {

    // }
  }
  ans
}
