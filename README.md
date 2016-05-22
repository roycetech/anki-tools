# Anki-Tools
Anki Card App Tools.  


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


### Pending enhancement
- [ ] well using pair of triple backticks.



