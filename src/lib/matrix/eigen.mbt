pub fn eigen(self : Matrix, max_iterations~ : Int = 1000, tol~ : Double = 0.0000000001) -> (Array[Double], Matrix) {
    if self.rows != self.cols {
        abort("MatrixShapeError: Matrix must be square to compute eigenvalues")
    }

    let n = self.rows
    let mut a = self.copy()
    let mut v = eye(n)

    for iter = 0; iter < max_iterations; iter = iter + 1 {
        let (q, r) = a.qr()

        a = r * q
        v = v * q

        let mut off_diag_norm = 0.0
        for i = 0; i < n; i = i + 1 {
            for j = 0; j < n; j = j + 1 {
                if i != j {
                    off_diag_norm += a.data[i][j] * a.data[i][j]
                }
            }
        }
        off_diag_norm = Double::sqrt(off_diag_norm)
        if off_diag_norm < tol {
            break
        }
    }

    let eigenvalues = Array::makei(n, fn(i : Int) -> Double {
        a.data[i][i]
    })

    let eigenvectors = v

    (eigenvalues, eigenvectors)
}