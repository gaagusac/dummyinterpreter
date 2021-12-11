// Simple ast 

class QNode {
    name = "";
    attrs = { };
    line = 0;
    col = 0;
    children = [];
    constructor(name, attrs, line, col, children) {
        this.name = name;
        this.attrs = attrs;
        this.line = line;
        this.col = col;
        this.children = children;
    }
    addChild(node) {
        this.children.push(node);
    }
}