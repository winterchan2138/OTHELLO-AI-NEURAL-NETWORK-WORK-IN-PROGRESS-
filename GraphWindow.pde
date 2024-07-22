class GraphWindow extends PApplet {
    OthelloGame parent;

    GraphWindow(OthelloGame parent) {
        this.parent = parent;
    }

    public void settings() {
        size(800, 600);
    }

    public void setup() {
        background(255);
        fill(0);
        textSize(20);
        text("Score Evolution Graph", 20, 20);
    }

    public void draw() {
        background(255);
        drawGraph();
    }

    void drawGraph() {
        stroke(0);
        line(50, height - 50, width - 50, height - 50);
        line(50, height - 50, 50, 50);

        if (parent.evolution.size() < 2) return;

        for (int i = 0; i < parent.evolution.size() - 1; i++) {
            float x1 = map(i, 0, parent.evolution.size() - 1, 50, width - 50);
            float y1 = map(parent.evolution.get(i), 0, 64, height - 50, 50);
            float x2 = map(i + 1, 0, parent.evolution.size() - 1, 50, width - 50);
            float y2 = map(parent.evolution.get(i + 1), 0, 64, height - 50, 50);
            line(x1, y1, x2, y2);
        }
    }
}
