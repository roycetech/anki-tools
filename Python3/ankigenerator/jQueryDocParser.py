filepath = '/Users/royce/Dropbox/Documents/Memorize/jQuery/Blank.txt'


with open(filepath, 'r') as f:

    card_count = 0
    line_index = 0
    card = ""
    skip_count = 3
    has_tag = False

    # def fix_verb(line):
    #     first_word = line[0:1].lower() + line[1:line.index(' ')]
    #     second_word = line[0:1].lower() + line[1:line.index(' ')]
    #     third_word = line[0:1].lower() + line[1:line.index(' ')]
    #
    #     singular = first_word
    #     if first_word[-2:] == 'ss':
    #         singular = first_word + 'es'
    #     elif first_word[-1:] == 's':
    #         pass
    #     else:
    #         singular = first_word + 's'


    for line in f:

        if line.strip(' ') != "\n":

            line_index += 1

            if line_index == 1:

                if 'Also in' in line:
                    tags = line.replace("Also in:", "").split(' | ')
                    simple_tags = [tag if ' > ' not in tag else tag[tag.index(' > ') + 3:] for tag in tags]

                    card = "@Tags: "
                    for simple in simple_tags:
                        if len(card) > 7: card += ', '
                        card += simple

                    # card = "@Tags: {}".format(re.sub(".*>",""))
                    has_tag = True
                else:
                    has_tag = False
                    card = ""
                    if line[0:1] == ".":
                        card += line[1:] + "\n"
                    else:
                        card += line + "\n"
            elif line_index == 2:
                if has_tag:
                    if line[0:1] == ".":
                        card += line[1:] + "\n"
                    else:
                        card += line + "\n"
                else:
                    # WET
                    line_index = 0
                    has_tag = False

                    # print(line)
                    first_word = line[0:1].lower() + line[1:line.index(' ')]
                    singular = first_word
                    if first_word[-2:] == 'ss':
                        singular = first_word + 'es'
                    elif first_word[-1:] == 's':
                        pass
                    else:
                        singular = first_word + 's'

                    card += "This method " + singular + " " + line[len(first_word) + 1:] + "\n"

                    if 'deprecated' not in card.lower():
                        print(card)


            else:
                # WET
                line_index = 0
                has_tag = False

                first_word = line[0:1].lower() + line[1:line.index(' ')]
                singular = first_word
                if first_word[-2:] == 'ss':
                    singular = first_word + 'es'
                elif first_word[-1:] == 's':
                    pass
                else:
                    singular = first_word + 's'

                    card += "This method " + singular + " " + line[len(first_word) + 1:] + "\n"

                if 'deprecated' not in card.lower():
                    print(card)

                card_count += 1

    print("Total cards: {}".format(card_count))