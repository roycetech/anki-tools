var out = '';
var bad = '';
count = 0;
var details = $(".method-detail");
details.each(function () {
  count++;
  var detail = $(this);
  var heading = detail.find(".method-heading > span:first-child");
  var head_text = ''
  heading.each(function () {
    head_text += $(this).html() + "\n";
  });
  out += head_text + "\n";

  var body = detail.find('div > p');
  var re = /<([a-z]+)(?: [a-z]+=(["'])[A-Za-z\.\-#]+\2)*>([\d\D]+?)<\/\1>/g
  if (body.html() != null) {
    var clean = body.html().replace(/\n/g, ' ').replace(re, '$3').replace(re, '$3');
  } else {
    clean = detail.find('div > pre').html().replace(/\n/g, ' ').replace(re, '$3').replace(re, '$3');
    clean = clean.substring(0, clean.indexOf('.') + 1);
    bad += head_text + "\n";
  }
  out += clean + "\n\n\n";
});
alert(out);
// alert(bad);
