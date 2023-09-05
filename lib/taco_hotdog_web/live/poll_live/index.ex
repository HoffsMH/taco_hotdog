defmodule TacoHotdogWeb.PollLive.Index do
  use TacoHotdogWeb, :live_view

  def mount(params, session, socket) do
    socket
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <div class="h-screen w-screen bg-yellow-400 flex items-start justify-center">
      <div class="bg-themerose-100 px-10 py-10 my-10 rounded-xl">
        <.hero_button class="my-3" phx-click="new_poll">
          New Poll
        </.hero_button>
      </div>
    </div>
    """
  end

  def handle_event("new_poll", unsigned_params, socket) do
    # create a new poll
    # generate a new poll id ()
    with new_poll_name <- TacoHotdog.Polls.gen_slug() do
      ConCache.put(
        :polls,
        new_poll_name,
        gen_poll()
      )

      socket
      |> assign(:poll, new_poll_name)
      |> redirect(to: ~p"/#{new_poll_name}")
      |> noreply()
    end
  end

  def gen_poll() do
    %{
      choices: [
        %{
          name: ""
        }
      ],
    }
  end

  def show_debug_info(assigns) do
    ~H"""
    <pre>
     pid: <%= raw inspect(self()) %>
    </pre>
    <pre class="bg-slate-100 overflow-scroll w-full">
      <%= render_slot(@inner_block) %>
    </pre>
    """
  end
end
