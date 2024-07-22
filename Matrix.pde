class Matrix {
    int rows, cols;
    float[][] matrix;

    Matrix(int rows, int cols) {
        this.rows = rows;
        this.cols = cols;
        matrix = new float[rows][cols];
    }

    Matrix(float[][] matrix) {
        this.rows = matrix.length;
        this.cols = matrix[0].length;
        this.matrix = matrix;
    }

    void randomize() {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                matrix[i][j] = random(-1, 1);
            }
        }
    }

    void mutate(float mr) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (random(1) < mr) {
                    matrix[i][j] += randomGaussian() * 0.1;
                    if (matrix[i][j] > 1) {
                        matrix[i][j] = 1;
                    }
                    if (matrix[i][j] < -1) {
                        matrix[i][j] = -1;
                    }
                }
            }
        }
    }

    Matrix dot(Matrix n) {
        Matrix result = new Matrix(rows, n.cols);

        if (cols == n.rows) {
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < n.cols; j++) {
                    float sum = 0;
                    for (int k = 0; k < cols; k++) {
                        sum += matrix[i][k] * n.matrix[k][j];
                    }
                    result.matrix[i][j] = sum;
                }
            }
        }
        return result;
    }

    Matrix activate() {
        Matrix result = new Matrix(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                result.matrix[i][j] = relu(matrix[i][j]);
            }
        }
        return result;
    }

    Matrix singleColumnMatrixFromArray(float[] arr) {
        Matrix n = new Matrix(arr.length, 1);
        for (int i = 0; i < arr.length; i++) {
            n.matrix[i][0] = arr[i];
        }
        return n;
    }

    Matrix addBias() {
        Matrix n = new Matrix(rows + 1, 1);
        for (int i = 0; i < rows; i++) {
            n.matrix[i][0] = matrix[i][0];
        }
        n.matrix[rows][0] = 1;
        return n;
    }

    float[] toArray() {
        float[] arr = new float[rows * cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                arr[i * cols + j] = matrix[i][j];
            }
        }
        return arr;
    }

    Matrix crossover(Matrix partner) {
        Matrix child = new Matrix(rows, cols);
        int randC = (int) random(cols);
        int randR = (int) random(rows);

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if ((i < randR) || (i == randR && j <= randC)) {
                    child.matrix[i][j] = matrix[i][j];
                } else {
                    child.matrix[i][j] = partner.matrix[i][j];
                }
            }
        }
        return child;
    }

    Matrix clone() {
        Matrix clone = new Matrix(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                clone.matrix[i][j] = matrix[i][j];
            }
        }
        return clone;
    }

    float relu(float x) {
        return max(0, x);
    }
}
