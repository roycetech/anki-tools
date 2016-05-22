filepath = '/Users/royce/Dropbox/Documents/Memorize/jQuery/Blank.txt'

with open(filepath, 'r') as f:

    card_count = 0
    line_index = 0
    card = ""
    is_selector = False

    for line in f:

        if line.strip(' ') != '\n':

            line_index += 1

            if line_index == 1:

                if 'Selectors' in line:
                    is_selector = True
                else:
                    is_selector = False

                    tags = line.split(' | ')
                    simple_tags = [tag if ' > ' not in tag else tag[tag.index(' > ') + 3:] for tag in tags]

                    card = "@Tags: "
                    for simple in simple_tags:
                        if len(card) > 7: card += ', '
                        card += simple

            elif line_index == 2 and not is_selector:

                if line[0:1] == ".":
                    card += line[1:] + "\n"
                else:
                    card += line + "\n"

            elif line_index == 3:

                line_index = 0
                if not is_selector:
                    card += line + '\n'

                    if 'deprecated' not in card.lower():
                        card_count += 1
                        print(card)
                is_selector = False

    print("Total cards: {}".format(card_count))