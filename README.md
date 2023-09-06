# Anki-Tools
Anki Card App Tools.

1. TSV Generator
2. Source Analyzer
3. Old TSV Generator


TSV Generator
=============

Written in [Ruby](https://www.ruby-lang.org) 2.x, it generates TSV file for upload to [Anki Nexus webapp](https://api.ankiapp.com/nexus/).

Features:
---------
- Syntax Highlighting via custom `HTML`
- TSV Generation


Source Analyzer
===============

This is a `GUI` written with `Java 8` `Swing`.  It allows you to easily set/remove tags, edit existing cards, filter cards, and export selected cards.


Old TSV Generator
=================
It is the original commandline script for generating TSV file from a source text file.  This is written in [Python3](https://www.python.org/download/releases/3.0/).


### Source Syntax

- Comments are preceded with hash `# this is a line comment.`
- Source comment and directives are placed on top of the source file.
- `# @lang=java` directive is used to indicate the source code formatting language for the entire source file.
- Cards are separated by double newline.
- Front and back are separated with a single line.
- Back card can have blank lines in between.
- Keywords can be wrapped by \` \`.
- Code blocks are wrapped by `<well> </well>`.
- Card can be tagged by preceding it with a line with `@Tag: ` followed by comma separated tags.
- Card with multiple sentences will be automatically tagged with `Multi:#`
- Enumeration cards will be automatically tagged with `Multi:#`

### Tags: With special meanings

- `FB Only` card is valid only if `Front` is shown first.
- `BF Only` card is valid only if `Back` is shown first.
- `EnumO` `Back` card will be an ordered list, implicitly `FB Only`
- `EnumU` `Back` card will be an unordered list, implicitly `FB Only`
- `Syntax` `Back` card will be highlighted as a code.
- `Code(Front)` `Front` card will be highlighted as a code
- `Abbr` `Front` card will be appended with `'Abbreviation'`, implicitly `FB Only`
- `Command` `Front` card will be rendered as a command line, black background, white text, `Courier New` font.


### Pending enhancement
- [ ] well using pair of triple backticks.  `Syntax` tag should no longer be necessary



