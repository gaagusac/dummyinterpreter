/*

class JsonPrinter {
    root = null; // The root of the tree
    treeData = null; // nodes of the tree
    constructor(root) {
        this.root = root;
    }

    exec(node) {
        switch (node.operator) {
            case 'PROGRAM': this.program(node); break;
            case 'DOUBLE' : return { "name" : node.attrs.literal_value }; 
            case 'INT':  return { "name": node.attrs.literal_value }; 
            case 'ID':   return { "name": node.attrs.id_name };
            // keywords
            case 'int':  return { "name": "int" };
            case 'double':  return { "name": "double" };
            case 'boolean':  return { "name": "boolean" };
            case 'char':  return { "name": "char" };
            case 'String':  return { "name": "String" };
            case 'VAR_DEC': this.VAR_DEC(node); break;
            default:
                console.log(node.operator + " NOT IMPLEMENTED IN JISON PRINTER"); break;
        }
    }

    program(node) {
        var children = [];
        console.log("THe whole tree is :" + JSON.stringify(node.childNodes[0]));
        for (var i = 0; i < node.childNodes[0].length; i++) {
            console.log("OP is" + JSON.stringify(node.childNodes[0][i]));
            var result = this.exec(node.childNodes[0][i]);
            console.log("RES is " + result);
            children.push(result);
        }
        var astNode = { "name": "Program", "children": children };
        console.log("PROGRAM: " + JSON.stringify(astNode));
        return astNode;
    }

    VAR_DEC(node) {
        var children = [ ];
        for (var i = 0; i < node.childNodes.length; i++) {
            var result = this.exec(node.childNodes[i]);
            children.push(result);
        }
        var astNode = { "name": "declaration", "children": children };
        console.log("Node VarDec : " + JSON.stringify(astNode));
        return astNode;
    }

    toJison() {
        
        return result;
    }
}

*/