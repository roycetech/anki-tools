var assoc = {};
assoc['a'] = 'Aye';
assoc['b'] = 'Bye';

Object.keys(assoc).forEach(function(key, index) {
  console.log(key + ' => ' + this[key]);
}, assoc);


Object.defineProperty(global, '__stack', {
get: function() {
        var orig = Error.prepareStackTrace;
        Error.prepareStackTrace = function(_, stack) {
            return stack;
        };
        var err = new Error;
        Error.captureStackTrace(err, arguments.callee);
        printObject(arguments.callee);
        var stack = err.stack;
        Error.prepareStackTrace = orig;


        return stack;
    }
});

Object.defineProperty(global, '__line', {
get: function() {
        return __stack[1].getLineNumber();
    }
});

Object.defineProperty(global, '__function', {
get: function() {
        return __stack[1].getFunctionName();
    }
});

Object.defineProperty(global, '__file', {
get: function() {
  printObject(__stack[1]);

  for (var x in Object.keys(__stack[1])) console.log(x);
      return 'xxx';
  }
});

function printObject(o) {
  var out = '';
  for (var p in o) {
    out += p + ': ' + o[p] + '\n';
  }
  console.log(out);
}


function foo() {
    console.log(__line);
    console.log(__function);
    console.log(__file);
}

foo()
