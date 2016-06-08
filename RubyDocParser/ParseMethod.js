var out = '';
var bad = '';
count = 0;
var details = $(".method-detail");
details.each(function () {
  count++;
  var detail = $(this);
  var heading = detail.find(".method-heading > span:first-child");
  var head_text = '';
  heading.each(function () {
    head_text += $(this).html() + "\n";
  });
  heading.nextAll().each(function () {
    var $this = $(this);
    if ($this.hasClass('method-args')) {
      if (head_text.endsWith("\n")) {
        head_text = head_text.substr(0, head_text.length - 1);
      }
      head_text += $this.html() + "\n";
    }
  });
  out += head_text + "\n";

  var body;
  if (detail.hasClass('method-alias')) {
    body = detail.find('.aliases');
  } else {
    body = detail.find('div > p');
  }
  var re = /<([a-z]+)(?: [a-z]+=(["'])[A-Za-z\d_\.\-#]+\2)*>([\d\D]+?)<\/\1>/g
  if (body.html() != null) {
    var clean = body.html().replace(/\n/g, ' ').replace(re, '$3').replace(re, '$3');
    clean = clean.trimLeft();
    if (clean.endsWith('Equivalent to:') || clean.endsWith('Equivalent to')) {
      body.nextAll('pre,p').each(function () {
        sib = $(this);
        clean += ' ' + sib.html();
      });
    }
  } else {
    clean = detail.find('div > pre').html()
      .replace(/\n/g, ' ')
      .replace(re, '$3');
    clean = clean.substring(0, clean.indexOf('.') + 1);
    bad += head_text + "\n";
  }
  out += clean + "\n\n\n";
});
alert(out.replace(/&nbsp;/g, ' ').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&'));
