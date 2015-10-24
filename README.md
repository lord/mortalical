# mortalical

![Screenshot of mortalical](https://raw.githubusercontent.com/lord/img/master/screenshot-mortalical.png)

A calendar of your entire life

To install:

    bundle install

To generate:

    ruby generate.rb <your birth year> [--letter] [--nofill]

The `--letter` option generates normal letter sized sheets of paper, if you don't have a printer that can do 11"x17". Normally, Mortalical automatically crosses off days up to the current day, `--nofill` disables this.
