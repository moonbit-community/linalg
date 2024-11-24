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

pub fn norm(self : Matrix, ord~ : String = "2", axis~ : String = "None") -> Double {
  let mut ans = 0.0
  if axis == "None" {
    let tmp = self.flat()
    if ord == "0" {
      ans = norm_vector_0(tmp.data[0])
    }
    if ord == "1" {
      ans = norm_vector_1(tmp.data[0])
    }
    if ord == "2" {
      ans = norm_vector_2(tmp.data[0])
    }
  } else {

  }
  ans
} 