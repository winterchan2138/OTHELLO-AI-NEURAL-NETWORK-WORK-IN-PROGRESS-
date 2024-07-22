class NeuralNetworkWindow extends PApplet {
    OthelloGame parent;
    AIPlayer aiPlayer;

    NeuralNetworkWindow(OthelloGame parent, AIPlayer aiPlayer) {
        this.parent = parent;
        this.aiPlayer = aiPlayer;
    }

    public void settings() {
        size(1200, 900);
    }

    public void setup() {
        background(255);
    }

    public void draw() {
        background(255);
        drawNeuralNetwork();
    }

    void drawNeuralNetwork() {
        float x = 50;
        float y = 50;
        float w = width - 100;
        float h = height - 100;
        float[] vision = new float[64]; // Example input data
        float[] decision = aiPlayer.brain.output(vision); // Example output data
        aiPlayer.brain.show(x, y, w, h, vision, decision);
    }

    void updateVisualization() {
        redraw();
    }
}
