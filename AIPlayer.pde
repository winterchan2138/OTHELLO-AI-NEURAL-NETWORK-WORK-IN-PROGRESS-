class AIPlayer {
    int score;
    NeuralNet brain;

    AIPlayer() {
        brain = new NeuralNet(64, 16, 1, 2); // Adjust parameters as needed
    }

    int[] minimaxDecision(int player, int[][] board, int depth) {
        int[] bestMove = null;
        int bestValue = (player == 1) ? Integer.MIN_VALUE : Integer.MAX_VALUE;

        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                if (OthelloGame.isValidMove(board, i, j, player)) {
                    int[][] tempBoard = OthelloGame.copyBoard(board);
                    OthelloGame.makeMove(tempBoard, i, j, player);
                    int value = minimax(tempBoard, 3 - player, depth - 1, Integer.MIN_VALUE, Integer.MAX_VALUE);
                    if (player == 1 && value > bestValue || player == 2 && value < bestValue) {
                        bestValue = value;
                        bestMove = new int[]{i, j};
                    }
                }
            }
        }
        return bestMove;
    }

    int minimax(int[][] board, int player, int depth, int alpha, int beta) {
        if (depth == 0 || OthelloGame.gameEnded(board)) {
            return evaluateBoard(board, player);
        }

        if (player == 1) {
            int maxEval = Integer.MIN_VALUE;
            for (int i = 0; i < 8; i++) {
                for (int j = 0; j < 8; j++) {
                    if (OthelloGame.isValidMove(board, i, j, player)) {
                        int[][] tempBoard = OthelloGame.copyBoard(board);
                        OthelloGame.makeMove(tempBoard, i, j, player);
                        int eval = minimax(tempBoard, 3 - player, depth - 1, alpha, beta);
                        maxEval = max(maxEval, eval);
                        alpha = max(alpha, eval);
                        if (beta <= alpha) {
                            break;
                        }
                    }
                }
            }
            return maxEval;
        } else {
            int minEval = Integer.MAX_VALUE;
            for (int i = 0; i < 8; i++) {
                for (int j = 0; j < 8; j++) {
                    if (OthelloGame.isValidMove(board, i, j, player)) {
                        int[][] tempBoard = OthelloGame.copyBoard(board);
                        OthelloGame.makeMove(tempBoard, i, j, player);
                        int eval = minimax(tempBoard, 3 - player, depth - 1, alpha, beta);
                        minEval = min(minEval, eval);
                        beta = min(beta, eval);
                        if (beta <= alpha) {
                            break;
                        }
                    }
                }
            }
            return minEval;
        }
    }

    int evaluateBoard(int[][] board, int player) {
        float[] inputs = new float[64];
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                inputs[i * 8 + j] = board[i][j] == player ? 1 : board[i][j] == 3 - player ? -1 : 0;
            }
        }
        float[] output = brain.output(inputs);
        return (int) (output[0] * 1000); // Scale output for evaluation
    }

    AIPlayer crossover(AIPlayer partner) {
        AIPlayer child = new AIPlayer();
        child.brain = brain.crossover(partner.brain);
        return child;
    }

    void mutate() {
        brain.mutate(0.1); // Mutation rate
    }
}
