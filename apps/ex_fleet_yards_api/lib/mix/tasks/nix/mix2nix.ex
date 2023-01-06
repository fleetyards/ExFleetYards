defmodule Mix.Tasks.Nix.Mix2nix do
  @moduledoc """
  Create a mix.nix lock file from the mix.lock file used by nix
  """
  @shortdoc "Generate Appsignal lock file"

  use Mix.Task

  @impl Mix.Task
  def run([]) do
    lock =
      run_mix2nix
      |> nixfmt

    Mix.Generator.overwrite?("nix/mix.nix", lock)
  end

  def run_mix2nix do
    {nix, 0} = System.cmd("mix2nix", [])
    nix
  end

  def nixfmt(nixexpr) do
    file = write_tmp_file("mix.nix", nixexpr)
    {_, 0} = System.cmd("nixfmt", [file])
    nixexpr = File.read!(file)
  end

  def write_tmp_file(name, content) do
    file = get_temp_file_path(name)
    File.write!(file, content)
    file
  end

  def get_temp_file_path(name) do
    build =
      Mix.Project.build_path()
      |> Path.join("nix")

    Mix.Generator.create_directory(build, quiet: true)

    Path.join(build, name)
  end
end
