from util.common import nvl2, nvl, to_html, from_html

filepath = '/Users/royce/Dropbox/Documents/Memorize/jQuery/Selector-Reference.txt'


with open(filepath, 'r') as f:

    card_count = 0

    group_count = 1

    template = """@Tags: Group{}
{}

{}


"""

    for line in f:

        if line.strip() == "":
            group_count += 1
        else:
            tabs = line.rstrip().split("\t")

            card = template.format(group_count, tabs[1], tabs[2])

            print(card, end="")
            card_count += 1

    print("Total groups: {}".format(group_count))
    print("Total cards: {}".format(card_count))