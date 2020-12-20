defmodule Phx.Add do
  @moduledoc false

  def indent(text, spaces) do
    String.duplicate(" ", spaces) <> text
  end

  def replace_in_file(path, target, replacement) do
    new_file_contents =
      case File.read(path) do
        {:ok, file_contents} ->
          String.replace(file_contents, target, replacement)

        {:error, error_msg} ->
          {:error, error_msg}
      end

    case String.contains?(new_file_contents, replacement) do
      true ->
        File.write(path, new_file_contents)

      false ->
        {:error, :text_not_replaced}
    end
  end

  def insert_into_file(path, replacement, after: position) do
    replace_in_file(path, position, position <> replacement)
  end

  # This was used at one point, but isn't now
  # def insert_into_file(path, replacement, before: position) do
  #   replace_in_file(path, position, replacement <> position)
  # end

  def assets_file(file) when is_binary(file) do
    assets_file([file])
  end

  def assets_file(list) when is_list(list) do
    Path.join(["assets" | list])
  end
end
