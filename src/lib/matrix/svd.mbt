///|
/// Performs Singular Value Decomposition (SVD) of a matrix.
/// Decomposes a matrix A into the product U·Σ·V^T where:
/// - U is an orthogonal matrix
/// - Σ is a diagonal matrix with non-negative real numbers (singular values)
/// - V^T is the transpose of an orthogonal matrix V
///
/// Parameters:
/// * `matrix`: Input matrix to decompose
///
/// Returns a tuple (U, Σ, V) containing the three component matrices
///
/// Example:
/// ```moonbit
