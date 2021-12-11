// Scope interface contract
// String getScopeName(); // THe name of the scope
// Scope getEnclosingScope(); // Where to look next for symbols
// void define(Symbol sym); // Define a symbol in the current scope 
// Symbol resolve(String name); // Look up name in this scope on in enclosing scope if not here

class Scope {
    constructor() {
        if (this.constructor == Scope) {
            throw new Error("Scope is abstract. Can't be instantiaded.");
        }
    }
    getScopeName() {
        throw new Error("Method 'getScopeName()' must be implemented.");
    }
    getEnclosingScope() {
        throw new Error("Method 'getEnclosingScope()' must be mplemented.");
    }
    define(sym) {
        throw new Error("Method 'define(sym)' must be implemented.");
    }
    resolve(name) {
        throw new Error("Method 'resolve(name)' must be implented.");
    }
}
class GlobalScope extends Scope {
    enclosingScope;
    symbols = {};
    constructor() {
        this.enclosingScope = null;
    }
    getScopeName() { return "global"; }
    getEnclosingScope() { return this.enclosingScope; }
    resolve(name) {
        sym = this.symbols[name];
        if (sym) {
            return sym;
        }
        // if not here, check enclosing scope
        if (this.enclosingScope) {
            return this.enclosingScope.resolve(name);
        }
        return null;
    }
    define(sym) {
        this.symbols[sym.name] = sym;
        sym.scope = this;
    }
}
class LocalScope extends Scope {
    enclosingScope;
    symbols = {};
    constructor(parent) {
        this.enclosingScope = parent;
    }
    getScopeName() { return "local"; }
    getEnclosingScope() { return this.enclosingScope; }
    resolve(name) {
        sym = this.symbols[name];
        if (sym) {
            return sym;
        }
        // if not here, check enclosing scope
        if (this.enclosingScope) {
            return this.enclosingScope.resolve(name);
        }
        return null;
    }
    define(sym) {
        this.symbols[sym.name] = sym;
        sym.scope = this;
    }
}

class Symbol {
    name;
    type;
    scope;
    constructor(...args) {
        if (args.length == 2) {
            this.name = args[0];
            this.type = args[1];
        } else if (args.length == 1) {
            this.name = args[0];
        }
    }

    getName() {
        return this.name;
    }

    toString() {
        if (this.type) {
            return "Symbol { Name: " + this.name + " ,Type: " + this.type + "}";
        }
        return "Symbol { Name: " + this.name + "}";
    }
}
class VariableSymbol extends Symbol {
    constructor(name, type) {
        super(name, type);
    }
}
class ArrayVariableSymbol extends Symbol {

}
class BuiltInTypeSymbol extends Symbol {
    constructor(name) {
        super(name)
    }
}

class SymbolTable {
    globals = new GlobalScope();
    constructor() {
        this.initTypeSystem();
    }
    initTypeSystem() {
        this.globals.define(new BuiltInTypeSymbol("int"));
        this.globals.define(new BuiltInTypeSymbol("float"));
        this.globals.define(new BuiltInTypeSymbol("void"));
    }
}

export { Symbol, BuiltInTypeSymbol };