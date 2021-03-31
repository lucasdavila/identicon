defmodule Identicon do
  def generate(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_even_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(image) do
    # with pattern match
    # %Identicon.Image{hex: hex_list} = image
    # [r, g, b | _tail ] = hex_list
    # [r, g, b]

    # with simpler pattern match (how was suggested on the course)
    # %Identicon.Image{hex: [r, g, b | _tail ]} = image
    # [r, g, b]


    # with enum (in case it would return the rgb list directly)
    # Enum.take(image.hex, 3)

    # with even simpler pattern match
    [r, g, b | _ ] = image.hex

    # creating a new image with the color included
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(image) do
    grid = image.hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    # creating a new image with the grid included
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _] = row

    row ++ [second, first]
  end

  def filter_even_squares(image) do
    grid = Enum.filter(image.grid, fn {code, _} -> Integer.mod(code, 2) == 0 end)

    # creating a new image with the filtered grid
    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(image) do
    pixel_map = Enum.map image.grid, fn {_, index} ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn {start, stop} ->
      # in this rare case, the passed image is being modified, instead of using the immutable pattern.
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save_image(egd_image, input) do
    File.write("images/#{input}.png", egd_image)
  end
end
