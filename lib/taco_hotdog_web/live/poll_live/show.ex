defmodule TacoHotdogWeb.PollLive.Show do
  use TacoHotdogWeb, :live_view

  def mount(%{"id" => id}, session, socket) do
    poll = ConCache.get(:polls, id)

    socket
    if !ensure_poll(socket, poll) do
      {:error, socket}
    else
      |> gen_choices(poll)
      |> ok()
    end
  end

  def gen_choices(socket, poll) do
    choice_forms =
      Map.get(poll, "choices")
      |> Enum.map(fn choice ->
        to_form(choice, as: "choice", id: "taco")
      end)

    stream(socket, :choice_forms, choice_forms)
  end

  defp to_change_form(todo_or_changeset, params, action \\ nil) do
    changeset =
      todo_or_changeset
      |> Todos.change_todo(params)
      |> Map.put(:action, action)

    to_form(changeset, as: "todo", id: "form-#{changeset.data.list_id}-#{changeset.data.id}")
  end

  def ensure_poll(socket, poll) do
    if !poll do
      socket
      |> put_flash(:error, "We couldn't find your poll")
      |> redirect(to: ~p"/")
    else
      raise "blah"
    end
  end

  def render(assigns) do
    ~H"""
    What are we eating?
    <div :for={choice <- @poll.choices}>
      <.input
        type="text"
      />
    </div>

    <.link href={~p"/"}>
      back to main
    </.link>
    """
  end

    # <.input
    #   type="text"
    #   field={form[:title]}
    #   border={false}
    #   strike_through={form[:status].value == :completed}
    #   placeholder="New todo..."
    #   phx-mounted={!form.data.id && JS.focus()}
    #   phx-keydown={!form.data.id && JS.push("discard", target: @myself)}
    #   phx-key="escape"
    #   phx-blur={form.data.id && JS.dispatch("submit", to: "##{form.id}")}
    #   phx-target={@myself}
    # />

  # <.input
  #   type="text"
  #   field={form[:title]}
  #   border={false}
  #   strike_through={form[:status].value == :completed}
  #   placeholder="New todo..."
  #   phx-mounted={!form.data.id && JS.focus()}
  #   phx-keydown={!form.data.id && JS.push("discard", target: @myself)}
  #   phx-key="escape"
  #   phx-blur={form.data.id && JS.dispatch("submit", to: "##{form.id}")}
  #   phx-target={@myself}
  # />
  # <.link href="google.com">
  #   HIO
  # </.link>
  #
  # <.link patch={~p"/lists/#{list}/edit"} alt="Edit list">
  #   <.icon name="hero-pencil-square" />
  # </.link>
  # <.link phx-click="delete-list" phx-value-id={list.id} alt="delete list" data-confirm="Are you sure?">
  #   <.icon name="hero-x-mark" />
  # </.link>
  #
  # <.link
  #   href={~p"/users/log_in"}
  #   class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
  # >
  #   Log in
  # </.link>

  # <.form for={@form} phx-change="validate" phx-submit="save">
  #   <.input type="text" field={@form[:new_option]} />
  #   <button>Save</button>
  # </.form>

  def update(socket) do
    item_forms =
      Enum.map(socket.assigns.poll.choices, fn item ->
        build_item_form(item, socket.params)
      end)

    {:ok, socket, []}
  end
  def handle_call(msg, tuple, socket) do
    socket
    |> noreply()
  end

  defp build_item_form(poll_item, params) do
    changeset =
      poll_item
      |> SortableList.change_item(params)

    to_form(poll_item, id: "form-#{poll_item.data.list_id}-#{changeset.data.id}")
  end
end
