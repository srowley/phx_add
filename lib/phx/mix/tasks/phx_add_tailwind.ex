defmodule Mix.Tasks.Phx.Add.Tailwind do
  use Mix.Task
  import Phx.Add
  alias Mix.{Generator, Shell}

  @postcss_config_js """
  module.exports = {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    }
  }
  """

  @purge_patterns """
  purge: [
      '../lib/my_app_web/live/**/*.ex',
      '../lib/my_app_web/live/**/*.leex',
      '../lib/my_app_web/templates/**/*.eex',
      '../lib/my_app_web/templates/**/*.leex',
      '../lib/my_app_web/views/**/*.ex',
      './js/**/*.js'
    ],
  """

  @tailwind_imports """
  @tailwind base;
  @tailwind components;
  @tailwind utilities;
  """

  def run(_argv) do
    install_npm_packages()
    add_tailwind_config()
    add_postcss_config()
    insert_postcss_loader()
    update_package_json()
    insert_tailwind_css_directives()
  end

  defp install_npm_packages do
    Shell.IO.cmd(
      "npm --prefix assets install -D tailwindcss postcss@^8 autoprefixer@^10 postcss-loader"
    )
  end

  defp add_tailwind_config do
    Shell.IO.cmd("npx --cache assets/node_modules tailwindcss init assets/tailwind.config.js")
    replace_in_file(assets_file("tailwind.config.js"), "purge: [],", @purge_patterns)
  end

  defp add_postcss_config do
    Generator.create_file(assets_file("postcss.config.js"), @postcss_config_js)
  end

  defp insert_postcss_loader do
    insert_into_file(assets_file("webpack.config.js"), indent("'postcss-loader',\n", 12),
      after: "'css-loader',\n"
    )
  end

  defp update_package_json do
    replace_in_file(
      assets_file("package.json"),
      ~s|"deploy": "webpack|,
      ~s|"deploy": "NODE_ENV=production webpack|
    )
  end

  defp insert_tailwind_css_directives do
    replace_in_file(
      Path.join(["assets", "css", "app.scss"]),
      ~s|@import "./phoenix.css";|,
      @tailwind_imports
    )
  end
end
