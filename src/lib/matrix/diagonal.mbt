///|
pub fn diagonal(matrix : Matrix, offset~ : Int = 0) -> Array[Double] {
  // 计算对角线长度
  let diag_length = if offset >= 0 {
    @math.minimum(matrix.rows, matrix.cols - offset)
  } else {
    @math.minimum(matrix.rows + offset, matrix.cols)
  }

  // 创建数组存储对角线元素
  let result = Array::new(capacity=diag_length)

  // 提取对角线元素
  for i = 0; i < diag_length; i = i + 1 {
    if offset >= 0 {
      result.push(matrix.data[i][i + offset])
    } else {
      result.push(matrix.data[i - offset][i])
    }
  }
  result
}

///|
test "diagonal extraction" {
  let m = new_matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]])

  // 主对角线
  let d0 = diagonal(m)
  @json.inspect(d0, content=[1.0, 5.0, 9.0])

  // 上对角线
  let d1 = diagonal(m, offset=1)
  @json.inspect(d1, content=[2.0, 6.0])

  // 下对角线
  let d2 = diagonal(m, offset=-1)
  @json.inspect(d2, content=[4.0, 8.0])
}
