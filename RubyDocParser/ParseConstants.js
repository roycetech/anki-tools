function buildConstants() {  
  var out = '';
  
  var count = 0;
  $('#constants-list dl').children().each(function() {    
    var $dtordd = $(this);
    var htmlText = $dtordd.html();

    var text = removeHtmlTags(newLineToSpace(htmlText));
    
    if ($dtordd.prop('tagName') === 'DT') {      
      out += "@Tags: Constant\n" + text + "\n\n";
    } else if ($dtordd.prop('tagName') === 'DD') {
      out += text + "\n\n\n";
    }
    
  });
    
  return out;
}


function buildHead($heading) {
  assert($heading != null);

  var head_text = '@Tags: Method\n';
  var retval = ''

  $heading.each(function () {
    head_text += $(this).html() + "\n";
  });

  $heading.nextAll().each(function () {
    var $this = $(this);
    if ($this.hasClass('method-args')) {
      if (head_text.endsWith("\n")) {
        head_text = head_text.substr(0, head_text.length - 1);
      }
      head_text += $this.html() + "\n";
    }
  });

  retval += head_text;
  return retval;
}

function buildBody($detail) {
  var $body;
  if ($detail.hasClass('method-alias')) {
    $body = $detail.find('.aliases');
  } else {
    $body = $detail.find('div > p');
  }

  var clean;
  if ($body.html() !== null) {
    clean = removeHtmlTags(newLineToSpace($body.html()));
    clean = clean.trimLeft();
    clean = buildMissingBody($body, clean);
  } else {
    clean = newLineToSpace($detail.find('div > pre').html());
    clean = clean.substring(0, clean.indexOf('.') + 1);
  }
  return clean + "\n\n\n";
}

function buildMissingBody($body, bodyText) {
  var retval = bodyText;
  var markers = ['Equivalent to:', 'Equivalent to'];

  if (markers.includes(bodyText)) {
    $body.nextAll('pre,p').each(function () {
      var $this = $(this);
      retval += ' ' + $this.html();
    });
  }

  return retval;
}

function removeHtmlTags(string) {
  var re = /<([a-z]+)(?: [a-z]+=(["'])[A-Za-z\/\d_\.\-#]+\2)*>([\d\D]+?)<\/\1>/g;
  return string.replace(re, '$3');
}

function newLineToSpace(string) {
  return string.replace(/\n/g, ' ');
}


function unescapeTags(string) {
  return string
    .replace(/&nbsp;/g, ' ')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&amp;/g, '&');
}

function assert(condition, message) {
  if (!condition) {
    message = message || "Assertion failed";
    if (typeof Error !== "undefined") {
      throw new Error(message);
    }
    throw message; // Fallback
  }
}


// Start of Execution ============================================
var out = '';
var count = 0;
"use strict"

var $details = $(".method-detail");
$details.each(function () {
  count++;

  var $detail = $(this);

  out += 
    buildHead($detail.find(".method-heading > span:first-child")) 
    + "\n" 
    + buildBody($detail);
});

//alert($('#constants-list dl dd p').eq(0).html());


/** MAIN */
alert(buildConstants());
alert(unescapeTags(out));
//buildConstants();

