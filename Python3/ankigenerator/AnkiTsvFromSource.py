from util.common import nvl2, nvl, to_html, array_to_string, to_html_li
from datetime import datetime

filepath = ""
chosen_module = ""
outputFilename = ""

filepath = nvl(filepath, '/Users/royce/Dropbox/Documents/Memorize/ruby/Ruby-Syntax.txt')
# filepath = nvl(filepath, '/Users/royce/Dropbox/Documents/Memorize/ruby/test.txt')

source_filename = filepath[filepath.rfind('/') + 1: filepath.rfind('.')]
simple_name = nvl(outputFilename, nvl2(chosen_module, source_filename, source_filename + '-' + chosen_module))
today = datetime.now()

outputFilename = '/Users/royce/Desktop/Anki Generated Sources/{} {}{}{}_{}{}' \
                     .format(simple_name,
                             today.year % 1000,
                             str(today.month).zfill(2),
                             str(today.day).zfill(2),
                             str(today.time().hour).zfill(2),
                             str(today.time().minute).zfill(2)) \
                 + '.tsv'

module_filename = nvl(chosen_module, 'beauty') + '.txt'


with open(filepath, 'r') as f, \
        open(outputFilename, 'w', newline='') as output:

    import csv

    def write_question(p_question_count, p_skipped_count):

        global untagged_count
        l_question_count = p_question_count
        l_skipped_count = p_skipped_count

        is_module_selected = len(chosen_module) > 0 and chosen_module in set(tags)

        if is_module_selected or len(chosen_module) == 0:
            l_question_count = p_question_count + 1

            answer_only_html = """<span style="font-weight: bold; background-color: #D9534F;
color: white; border-radius: 5px; padding: 5px;">Answer Only</span>"""

            if len(tags) > 0:
                tag_html = """<div style="text-align: left;">{}</div>""".format(array_to_string(tags))
            else:
                tag_html = ''

            front_only_tags = ['FB Only', 'Enum', 'Practical', 'Bool', 'Code', 'Abbr', 'Syntax', 'EnumU', 'EnumO']
            is_front_only = len([val for val in tags if val in front_only_tags]) > 0

            if is_front_only:
                if is_unordered_list:
                    lst = [tag_html + to_html(front), answer_only_html + """<div style="text-align: left;
                    font-family: 'Courier New';">
                    <ul>
                    """ + to_html_li(back) + '</ul></div>']
                elif is_ordered_list:
                    lst = [tag_html + to_html(front), answer_only_html + """<div style="text-align: left;
                    font-family: 'Courier New';">
                    <ol>
                    """ + to_html_li(back) + '</ol></div>']
                else:
                    lst = [tag_html + to_html(front), answer_only_html + to_html(back)]

            elif 'BF Only' in tags:
                lst = [answer_only_html + to_html(front), tag_html + to_html(back)]
            else:
                lst = [tag_html + to_html(front),  to_html(back)]

            # tags w/o control tags like BF Only, and FB Only
            real_tags = [tag for tag in tags if tag not in ['FB Only', 'BF Only', 'Syntax']]

            if len(real_tags) > 0:
                lst.append(','.join(tags))
            else:
                lst.append('untagged')
                untagged_count += 1

            print("Front: " + lst[0],end='\n\n')
            print("Back: " + lst[1],end='\n\n')
            print("Tag: " + lst[2],end='\n\n')

            tsv_writer.writerow(lst)

        else:
            l_skipped_count = p_skipped_count + 1

        return l_question_count, l_skipped_count

    tsv_writer = csv.writer(output, delimiter='\t')
    create_module = True
    space_counter = 0
    is_question = True

    is_unordered_list = False  # Marks if tagged as EnumU, will use <ol> or <ul> HTML tags.
    is_ordered_list = False  # Marks if tagged as EnumO, will use <ol> HTML tag.

    front, back, tags = [[], [], []]
    front_count, ignored_count, untagged_count = 0, 0, 0

    card_began = False  # Marks the start of the first card.

    for line in f:

        line = line.rstrip()

        if not card_began:
            if line[0:1] == '#' or line.strip(' ') == '':
                continue
            else:
                card_began = True

        if line.strip() == '':
            space_counter += 1

        if space_counter >= 2:
            is_question = True

        elif space_counter == 1 and is_question:
            is_question = False
            space_counter = 0

        if is_question:

            if space_counter >= 2:  # write to file

                if 'EnumU' in tags or 'EnumO' in tags:
                    multi_tag = 'Multi:{}'.format(len(back))
                    if multi_tag not in tags:
                        tags.append(multi_tag)

                if back[-1] == '':
                    back.pop()

                front_count, ignored_count = write_question(front_count, ignored_count)

                # reset variables
                space_counter = 0
                is_unordered_list = False
                is_ordered_list = False

                front, back, tags = [], [], []
            else:

                if line[0:7] == '@Tags: ':
                    tags = [x.strip(' ') for x in line.rstrip()[7:].split(',')]
                    is_unordered_list = 'EnumU' in tags
                    is_ordered_list = 'EnumO' in tags
                elif 'Abbr' in tags:
                    front.append(to_html(line.rstrip(' ') + ' abbreviation\n'))
                else:
                    front.append(line)

        else:

            if line != '' or len(back) > 0:

                sentence_count = line.replace("e.g.", "").replace('...', '').replace('..', '').count(".")
                if sentence_count > 1:
                    multi_tag = 'Multi:{}'.format(sentence_count)
                    if multi_tag not in tags:
                        tags.append(multi_tag)

                # if is_unordered_list or is_ordered_list:
                #     back.append('<li>' + line + '</li>')
                # else:
                back.append(line)

                if line != '':
                    space_counter = 0
    else:
        front_count, ignored_count = write_question(front_count, ignored_count)

    print("Total questions: {}".format(front_count))
    print("Skipped questions: {}".format(ignored_count))
    print("Untagged Count: {}\n\n".format(untagged_count))
    print("Output File: {}\n\n".format(outputFilename))

    print("{}".format(outputFilename[outputFilename.rfind('/') + 1:outputFilename.find('.')]))
