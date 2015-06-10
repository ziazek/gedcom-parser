# GEDCOM Parser

## About

Best of Ruby Quiz, Chapter 3

Create a parser that takes a GEDCOM file as input and converts it to XML.

The GEDCOM file format is very straightforward.Each line represents a node in a tree. It looks something like this:
    
    0 @I1@ INDI
    1 NAME Jamis Gordon /Buck/ 2 SURN Buck
    2 GIVN Jamis Gordon
    1 SEX M
    ...

In general, each line is formatted like this:

    LEVEL TAG-OR-ID [DATA]

Mission: Convert [royal.ged](https://github.com/ziazek/gedcom-parser/blob/master/royal.ged) into [result.xml](https://github.com/ziazek/gedcom-parser/blob/master/result.xml)


## Requirements

Ruby 2.2.2

[GED file, European royalty](http://www.rubyquiz.com/royal.ged)


## Usage

    $ ./gedcom.rb royal.ged result

Outputs to `result.xml`

Remember to `chmod +x gedcom.rb`

## Observations

- Some tags have text AND children tags. 

## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT)


