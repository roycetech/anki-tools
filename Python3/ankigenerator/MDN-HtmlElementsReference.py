filepath = '/Users/royce/Dropbox/Documents/Memorize/web/html.txt'


with open(filepath, 'r') as f:

    card_count = 0
    card = ""
    do_skip = False

    template = """@Tags: {}
{}

{}

"""

    for line in f:

        in_html5 = 'Not supported in HTML5' not in line
        if line.strip(' ') != "\n":

            if not in_html5:
                do_skip = True
                continue

            if do_skip or 'Tag\tDescription' in line:
                do_skip = False
                continue

            if line.count("\t") == 0:
                tag = line
                is_table_header = True
            else:
                array = [val.strip() for val in line.split("\t")]
                card = template.format(tag.strip('\n').strip(), array[0], array[1].strip())

                print(card)

                card_count += 1

    print("Total cards: {}".format(card_count))