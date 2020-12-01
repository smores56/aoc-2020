# Advent of Code 2020

My entry for the [Advent of Code][aoc] for 2020, written entirely in [Crystal][crystal].


## Installation

You only need [Crystal installed][install crystal] to run these solutions.


## Setup

This solution takes inspiration from the [cargo-aoc][cargo-aoc] Rust plugin
that I used for the 2018 Advent of Code and automatically downloads and provides
the input to the solution implementations using the AoC API.

To setup, make sure that you are logged in to the [Advent of Code][aoc] website,
and then copy your `session` cookie by opening the Network Inspector of your web
browser and looking at the "Cookies" tab of the inspector. Then write the session
token to a file in this repo named `.session` however you like; something like
this should work:

```console
$ cd aoc-2020/ && xsel > .session
```

Once this is done, this application will automatically download input data to the
`.data` folder (which it will create automatically) if it is missing.


## Usage

Once you have setup by installing [Crystal][crystal] and saving your session token
to the `.session` file, you can run any solution from the repo with

```
$ crystal run src/aoc-2020.cr [--day <DAY>] [--release]
```

By default, this application will use the current day of the month (e.g. if it is
December 8th, day will default to 8). Crystal assumes debug mode for faster compilation,
but if you need to run a solution faster because it is computationally expensive, you
can add the `--release` flag to improve runtime speeds at the cost of compilation time.


## Development

All of the days are already templated out, so you just have to pick the one you are
working on and start writing!


## Contributors

- [Sam Mohr](https://github.com/smores56) - creator and maintainer


[aoc]: https://adventofcode.com/
[crystal]: https://crystal-lang.org/
[install crystal]: https://crystal-lang.org/install/
[cargo-aoc]: https://crates.io/crates/cargo-aoc/

