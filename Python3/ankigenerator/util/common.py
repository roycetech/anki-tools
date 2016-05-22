# common.py

comment_color = '#417E60'


def nvl2(arg1, when_null, when_not_null):
    return when_not_null if arg1 else when_null


def nvl(arg1, when_null):
    return arg1 if arg1 else when_null


def to_html(array):

    str_builder = ""
    for element in array:
        str_builder += to_html_raw(element) + "<br />\n"

    return """<div style="text-align: left; font-family: 'Courier New';">""" + str_builder + '</div>\n'


def to_html_raw(string):

    if '# ' in string:
        comment = string[string.index('# '):];
        non_comment = string[0:string.index('# ')]
    else:
        comment = ''
        non_comment = string

    return non_comment.replace('  ', '&nbsp;' * 2) \
        .replace('  ', '&nbsp;' * 2) \
        .replace('<', '&lt;') \
        .replace('>', '&gt;').replace('\n', '<br />') + "<span style='color: {}'>{}</span>"\
        .format(comment_color, comment)


def to_html_li(array):
    return_value = ""
    for element in array:
        return_value += "<li>" + to_html_raw(element) + "</li>\n"
    return return_value


def from_html(string):
    return string.replace('&nbsp;', ' ') \
        .replace('&gt;', '>') \
        .replace('&lt;', '<') \
        .replace('<br/>', '\n') \
        .replace("""<div style="text-align: left;font-family: 'Courier New';">""", '') \
        .replace('</div>', '')


template = """<small style="background-color: #5BC0DE; color: white; border-radius: 5px; padding: 5px;">{}</small>"""


def array_to_string(array):
    return_value = ''
    for element in array:
        if len(return_value) > 0:
            return_value += '<span>&nbsp;</span>'

        if element not in ['FB Only', 'BF Only', 'Syntax']:
            return_value += template.format(element)

    return return_value


