from util.common import nvl2, nvl, to_html, from_html

filepath = '/Users/royce/Dropbox/Documents/Memorize/javascript/Blank.txt'


with open(filepath, 'r') as f:

    card_count = 0
    add_tag = False

    for line in f:

        if line.strip(' ') != "\n" and not 'deprecated' in line.lower():

            tabs = line.rstrip().split("\t")
            back = "{}{}".format(tabs[1][0:1].lower(), tabs[1][1:])

            if "/Triggers" in back:
                back = back.replace("/Triggers", "/triggers")

            print("{}\n\nThis method {}.\n\n".format(tabs[0], back))
            # print("{}\n\nThis method of the jQuery element {}.\n\n".format(tabs[0], back))
            card_count += 1

    print("Total cards: {}".format(card_count))