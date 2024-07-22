class Button {
    float x, y, w, h;
    String label;

    Button(float x, float y, float w, float h, String label) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.label = label; // Assign the label separately
    }

    void display() {
        fill(200);
        rect(x, y, w, h);
        fill(0);
        textSize(12);
        textAlign(CENTER, CENTER);
        text(label, x + w / 2, y + h / 2);
    }

    boolean isClicked(float mx, float my) {
        return mx > x && mx < x + w && my > y && my < y + h;
    }
}
