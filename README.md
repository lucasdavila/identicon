# Identicon generator

This is a simple Identicon generator, made with Elixir.

Identicon are generated "placeholder images" based on a given hash from an input string.

The generated images have 250px x 250px, with 5 x 5 squares of 50px each, it is like a 5 x 5 matrix, but the left and right side are mirrored.

## Usage

`$ iex -S mix`

`iex> Identicon.generate "bannana"`

Check the images folder, it will contain a bannana.png file.
