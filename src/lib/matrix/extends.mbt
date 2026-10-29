///|
pub extend Matrix with Add::{add}

///|
pub extend Matrix with Eq::{not_equal, equal}

///|
pub extend Matrix with Mul::{mul}

///|
pub extend Matrix with Show::{to_string, output}

///|
pub extend Matrix with Sub::{sub}

///|
pub extend Matrix with ToJson::{to_json}

///|
pub extend MatrixShapeError with Show::{to_string, output}

///|
pub extend SliceError with Show::{to_string, output}
