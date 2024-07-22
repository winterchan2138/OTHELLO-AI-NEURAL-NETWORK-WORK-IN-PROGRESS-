int[][] board;
int currentPlayer;
boolean gameEnded;
int geneticAIScore, greedAIScore;
Button startButton, graphButton, nnButton;
boolean aiVsAiMode;
ArrayList<Integer> evolution;
int generation = 0;

ArrayList<AIPlayer> population;
int populationSize = 20;
AIPlayer bestPlayer;

PFont boldFont;
PFont regularFont;
ArrayList<String> consoleMessages;

NeuralNetworkWindow nnWindow;

public void settings() {
    size(1200, 900);  // Increased width to accommodate the in-game console
}

public void setup() {
    initializeGame();
    evolution = new ArrayList<Integer>();

    startButton = new Button(150, 850, 100, 40, "Start AI vs AI");
    graphButton = new Button(350, 850, 100, 40, "Graph");
    nnButton = new Button(550, 850, 150, 40, "Neural Network");

    population = new ArrayList<AIPlayer>();
    for (int i = 0; i < populationSize; i++) {
        population.add(new AIPlayer());
    }
    bestPlayer = population.get(0);

    boldFont = loadFont("LevenimMT-Bold-21.vlw");
    regularFont = loadFont("LevenimMT-18.vlw");
    consoleMessages = new ArrayList<String>();
}

public void draw() {
    background(255);
    drawBoard();
    drawUI();
    drawConsole();

    if (aiVsAiMode && !gameEnded) {
        aiVsAiTurn();
    }

    if (gameEnded) {
        printScoresToConsole();
        evolvePopulation();
        restartGame();
    }
}

void initializeGame() {
    board = new int[8][8];
    currentPlayer = 1;
    gameEnded = false;
    geneticAIScore = 0;
    greedAIScore = 0;

    board[3][3] = board[4][4] = 1;
    board[3][4] = board[4][3] = 2;
}

void drawBoard() {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            fill(0, 100, 0);
            stroke(0);
            rect(i * 75, j * 75, 75, 75);
            if (board[i][j] == 1) {
                fill(0);
                ellipse(i * 75 + 37, j * 75 + 37, 60, 60);
            } else if (board[i][j] == 2) {
                fill(255);
                ellipse(i * 75 + 37, j * 75 + 37, 60, 60);
            }
        }
    }
}

void drawUI() {
    fill(0);
    textFont(boldFont, 21);  // Bold font for labels
    textAlign(CENTER, CENTER);
    text("Current Player:", width / 4, 700);  // Moved up and centered
    textFont(regularFont, 18);  // Regular font for values
    text(currentPlayer == 1 ? "Genetic AI" : "Greed AI", width / 4 + 150, 700);  // Display current player

    textFont(boldFont, 21);  // Bold font for labels
    text("Genetic AI Score:", width / 8, 730);  // Moved up and centered
    textFont(regularFont, 18);  // Regular font for values
    text(geneticAIScore, width / 8 + 150, 730);  // Display genetic AI score

    textFont(boldFont, 21);  // Bold font for labels
    text("Greed AI Score:", 3 * width / 8, 730); // Moved up and centered
    textFont(regularFont, 18);  // Regular font for values
    text(greedAIScore, 3 * width / 8 + 150, 730);  // Display greed AI score
    
    startButton.display();
    graphButton.display();
    nnButton.display();
}

void drawConsole() {
    fill(0);  // Black background for the console
    rect(600, 0, 600, 900);  // Adjusted to take the right half
    fill(255);  // White text
    textAlign(LEFT, TOP);
    textFont(boldFont, 21);
    text("Console:", 610, 10);
    int yPosition = 50;  // Starting y position for messages
    for (String message : consoleMessages) {
        if (message.startsWith("Generation:")) {
            textFont(boldFont, 21);  // Bold font for "Generation"
        } else {
            textFont(regularFont, 18);  // Regular font for other messages
        }
        text(message, 610, yPosition);
        yPosition += 40;  // Increased vertical space
    }
}

public void mousePressed() {
    if (startButton.isClicked(mouseX, mouseY)) {
        aiVsAiMode = true;
        initializeGame();
    } else if (graphButton.isClicked(mouseX, mouseY)) {
        GraphWindow graphWindow = new GraphWindow(this);
        String[] args = {"Graph Window"};
        PApplet.runSketch(args, graphWindow);
    } else if (nnButton.isClicked(mouseX, mouseY)) {
        if (nnWindow == null) {
            nnWindow = new NeuralNetworkWindow(this, bestPlayer);
            String[] args = {"Neural Network Window"};
            PApplet.runSketch(args, nnWindow);
        }
    }
}

void aiVsAiTurn() {
    int[] move = bestPlayer.minimaxDecision(currentPlayer, board, 5); // Depth 5 for the minimax algorithm
    if (move != null) {
        makeMove(board, move[0], move[1], currentPlayer);
        currentPlayer = 3 - currentPlayer;
        calculateScores();
        if (!hasValidMove(board, currentPlayer)) {
            if (!hasValidMove(board, 3 - currentPlayer)) {
                gameEnded = true;
                updateEvolution(); // Update evolution data at the end of each game
            } else {
                currentPlayer = 3 - currentPlayer;
            }
        }
    } else {
        gameEnded = true;
        updateEvolution(); // Update evolution data at the end of each game
    }
}

void restartGame() {
    generation++;
    initializeGame();
}

void updateEvolution() {
    evolution.add(geneticAIScore); // Assuming Genetic AI is the genetic algorithm
}

void printScoresToConsole() {
    consoleMessages.add("Generation: " + generation);
    consoleMessages.add("Genetic AI Score: " + geneticAIScore);
    consoleMessages.add("Greed AI Score: " + greedAIScore);
    if (consoleMessages.size() > 15) {
        consoleMessages.remove(0); // Keep the console to a manageable size
    }
}

void evolvePopulation() {
    // Sort the population based on scores
    population.sort((a, b) -> b.score - a.score);

    // Select the top half to be parents
    ArrayList<AIPlayer> parents = new ArrayList<AIPlayer>();
    for (int i = 0; i < populationSize / 2; i++) {
        parents.add(population.get(i));
    }

    // Create a new population by crossing over parents and mutating
    ArrayList<AIPlayer> newPopulation = new ArrayList<AIPlayer>();
    for (int i = 0; i < populationSize; i++) {
        AIPlayer parent1 = parents.get((int) random(parents.size()));
        AIPlayer parent2 = parents.get((int) random(parents.size()));
        AIPlayer child = parent1.crossover(parent2);
        child.mutate();
        newPopulation.add(child);
    }

    population = newPopulation;
    bestPlayer = population.get(0);
}

void calculateScores() {
    geneticAIScore = 0;
    greedAIScore = 0;
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (board[i][j] == 1) geneticAIScore++;
            if (board[i][j] == 2) greedAIScore++;
        }
    }
}

static int[][] copyBoard(int[][] original) {
    int[][] copy = new int[8][8];
    for (int i = 0; i < 8; i++) {
        System.arraycopy(original[i], 0, copy[i], 0, 8);
    }
    return copy;
}

static boolean isValidMove(int[][] board, int row, int col, int player) {
    if (board[row][col] != 0) return false;
    return checkDirection(board, row, col, player, -1, 0) ||
           checkDirection(board, row, col, player, 1, 0) ||
           checkDirection(board, row, col, player, 0, -1) ||
           checkDirection(board, row, col, player, 0, 1) ||
           checkDirection(board, row, col, player, -1, -1) ||
           checkDirection(board, row, col, player, 1, 1) ||
           checkDirection(board, row, col, player, -1, 1) ||
           checkDirection(board, row, col, player, 1, -1);
}

static boolean checkDirection(int[][] board, int row, int col, int player, int dRow, int dCol) {
    int opponent = 3 - player;
    int r = row + dRow, c = col + dCol;
    boolean foundOpponent = false;

    while (r >= 0 && r < 8 && c >= 0 && c < 8) {
        if (board[r][c] == opponent) {
            foundOpponent = true;
        } else if (board[r][c] == player) {
            return foundOpponent;
        } else {
            break;
        }
        r += dRow;
        c += dCol;
    }
    return false;
}

static void makeMove(int[][] board, int row, int col, int player) {
    board[row][col] = player;
    flipDirection(board, row, col, player, -1, 0);
    flipDirection(board, row, col, player, 1, 0);
    flipDirection(board, row, col, player, 0, -1);
    flipDirection(board, row, col, player, 0, 1);
    flipDirection(board, row, col, player, -1, -1);
    flipDirection(board, row, col, player, 1, 1);
    flipDirection(board, row, col, player, -1, 1);
    flipDirection(board, row, col, player, 1, -1);
}

static boolean hasValidMove(int[][] board, int player) {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (isValidMove(board, i, j, player)) return true;
        }
    }
    return false;
}

static void flipDirection(int[][] board, int row, int col, int player, int dRow, int dCol) {
    int opponent = 3 - player;
    int r = row + dRow, c = col + dCol;
    ArrayList<int[]> toFlip = new ArrayList<int[]>();

    while (r >= 0 && r < 8 && c >= 0 && c < 8) {
        if (board[r][c] == opponent) {
            toFlip.add(new int[]{r, c});
        } else if (board[r][c] == player) {
            for (int[] pos : toFlip) {
                board[pos[0]][pos[1]] = player;
            }
            break;
        } else {
            break;
        }
        r += dRow;
        c += dCol;
    }
}

static boolean gameEnded(int[][] board) {
    return !hasValidMove(board, 1) && !hasValidMove(board, 2);
}
