
# Advent of Code 2022

[![CI](https://github.com/freddyabrahamsson/aoc-2022/actions/workflows/ci.yml/badge.svg)](https://github.com/freddyabrahamsson/aoc-2022/actions/workflows/ci.yml)

- [Advent of Code 2022](#advent-of-code-2022)
  - [Setup](#setup)
  - [Running](#running)
  - [About](#about)
  - [Dependencies](#dependencies)

Solutions to Advent of Code[^aoc] 2022.

## Setup

The code uses `.ruby-version` to help manage the Ruby versioning through rbenv[^rbenv]. With rbenv installed and set up, all dependencies can be automatically installed by running `bundle install`.

## Running

In order to get solutions for day XX, create the directory `data/inputs` and place a file called `dayXXinput.txt` in it. Then run `ruby bin/aoc solve XX`.

## About

The code focuses on using different aspects of Ruby and the toolchain. Some code is certainly more explicit than it has to be in order to use a wide range of concepts and tools.

## Dependencies

The solutions makes use of the following third party libraries and tools.

- Docs: YARD[^yard].
- Linting: Rubocop[^rubocop].
- Terminal IO: TTY[^tty]
- Testing: Minitest[^minitest].
- Typechecking: Sorbet[^sorbet], handled through Tapioca[^tapioca].

[^aoc]: https://adventofcode.com
[^sorbet]: https://sorbet.org
[^rbenv]: https://github.com/rbenv/rbenv
[^minitest]: https://github.com/minitest/minitest
[^rubocop]: https://rubocop.org
[^tapioca]: https://github.com/Shopify/tapioca
[^tty]: https://ttytoolkit.org/
[^yard]: https://yardoc.org/
