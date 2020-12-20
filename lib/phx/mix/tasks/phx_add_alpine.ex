defmodule Mix.Tasks.Phx.Add.Alpine do
  use Mix.Task
  import Phx.Add
  alias Mix.Shell

  @live_socket_import ~s|import {LiveSocket} from "phoenix_live_view"\n|

  @old_live_socket_declaration ~s|let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})|

  @new_live_socket_declaration """
  let liveSocket = new LiveSocket('/live', Socket, {
    dom: {
      onBeforeElUpdated(from, to) {
        if (from.__x) {
          window.Alpine.clone(from.__x, to)
        }
      }
    },
    params: {
      _csrf_token: csrfToken
    },
    hooks: Hooks
  })
  """

  def run(_argv) do
    install_npm_packages()
    insert_alpine_import()
    update_live_socket_params()
  end

  defp install_npm_packages do
    Shell.IO.cmd("npm --prefix assets install alpinejs")
  end

  defp insert_alpine_import do
    insert_into_file(
      assets_file(["js", "app.js"]),
      "import 'alpinejs'\n",
      after: @live_socket_import
    )
  end

  defp update_live_socket_params do
    replace_in_file(
      assets_file(["js", "app.js"]),
      @old_live_socket_declaration,
      @new_live_socket_declaration
    )
  end
end
