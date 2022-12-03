
# Advent of Code 2022

- [Advent of Code 2022](#advent-of-code-2022)
  - [Setup](#setup)
  - [Running](#running)
  - [About](#about)

These are my solutions to Advent of Code[^aoc] 2022.

## Setup

The code uses `.ruby-version` to help manage the Ruby versioning through rbenv[^rbenv]. With rbenv installed and set up, all dependencies can be automaticall installed by running `bundle install`.

## Running

In order to get solutions for day XX, create the directory `data/inputs` and place a file called `dayXXinput.txt` in it. Then run `ruby bin/aoc solve XX`.

## About

All solutions are written in Ruby.

- Typechecking is done via Sorbet[^sorbet], handled through Tapioca[^tapioca].
- Testing is done via RSpec[^rspec].
- Style is kept by Rubocop[^rubocop].
- Docs are generated with YARD[^yard].

[^aoc]: https://adventofcode.com
[^sorbet]: https://sorbet.org
[^rbenv]: https://github.com/rbenv/rbenv
[^rspec]: https://rspec.info
[^rubocop]: https://rubocop.org
[^tapioca]: https://github.com/Shopify/tapioca
[^yard]: https://yardoc.org/
