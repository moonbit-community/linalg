pub fn qr(self : Matrix) -> (Matrix, Matrix) {
  if self.rows < self.cols {
      abort("MatrixShapeError: Cannot perform QR decomposition, rows must be >= cols")
  }
  
  let m = self.rows
  let n = self.cols
  let q = zero(m, n)
  let r = zero(n, n)
  
  // Gram-Schmidt
  for j = 0; j < n; j = j + 1 {
      let v = zero(m, 1)
      for i = 0; i < m; i = i + 1 {
          v.data[i][0] = self.data[i][j]
      }
      
      for i = 0; i < j; i = i + 1 {
          let qi = zero(m, 1)
          for k = 0; k < m; k = k + 1 {
              qi.data[k][0] = q.data[k][i]
          }
          
          r.data[i][j] = qi.dot(v)
          
          for k = 0; k < m; k = k + 1 {
              v.data[k][0] -= r.data[i][j] * qi.data[k][0]
          }
      }
      
      // 列向量的范数
      r.data[j][j] = v.norm(ord=NormType::Two, axis=Vector)
      
      // 检查奇异性
      if r.data[j][j] < 0.0000000001 {
          abort("MatrixError: Matrix is rank deficient")
      }
      
      for i = 0; i < m; i = i + 1 {
          q.data[i][j] = v.data[i][0] / r.data[j][j]
      }
  }
  
  (q, r)
}