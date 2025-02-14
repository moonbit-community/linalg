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

fn swap_array(arr1 : Array[Double], arr2 : Array[Double], lens : Int) -> Unit {
  for i = 0; i < lens; i = i + 1 {
    let temp = arr1[i];
    arr1[i] = arr2[i];
    arr2[i] = temp;
  }
}


pub fn det_Gauss(self : Matrix) -> Double {
  if self.cols == 1 {
    return self.data[0][0]
  }
  let now : Matrix = new_matrix(self.data);
  let mut res = 1.0;
  for i = 0; i < self.cols; i = i + 1 {
    if now.data[i][i] == 0 {
      let mut pos = i
      for j = i + 1; j < self.cols; j = j + 1 {
        if now.data[j][i] > now.data[pos][i] {
          pos = j
        }
      }
      if res == 1.0  {res = -1.0}
      else {res = 1.0}
      swap_array(now.data[i], now.data[pos], self.cols)
    }
    if now.data[i][i] == 0 {
      return 0
    }
    for j = i + 1; j < self.cols; j = j + 1 {
      let div = now.data[j][i] / now.data[i][i]
      // let div = now.data[i][i] / now.data[j][i]
      for k = i; k < self.cols; k = k + 1 {
        now.data[j][k] -= now.data[i][k] * div
      }
    }
  }
  for i = 0; i < self.cols; i = i + 1 {
    res = res * now.data[i][i]
  }
  res
}


// test "Gauss" {
//   let m1 = new_matrix([[1, 0, 4], [0, 5, 7], [7, 5, 0.2]])
//   // println(det(m1))
//   // println(det_Gauss(m1))
//   // println(det(m1))
//   assert_eq!(det_Gauss(m1), det(m1))
// }
///|
// fn main {
//   let m1 = Matrix::new(1, 1)
//   m1.data[0][0] = 5.0
//   println(m1.det_Gauss())
//   // inspect!(m1.det(), content="5.0")

//   let m2 = Matrix::new(2, 2)
//   m2.data[0][0] = 1.0
//   m2.data[0][1] = 2.0
//   m2.data[1][0] = 3.0
//   m2.data[1][1] = 4.0
//   // inspect!(m2.det(), content="-2.0") // 1*4 - 2*3 = -2
//   println(m2.det_Gauss())
// }
