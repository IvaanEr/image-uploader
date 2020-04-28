defmodule ImageUploader.Buffer do
  use GenServer

  # Client
  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def push(element) do
    GenServer.cast(__MODULE__, {:push, element})
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    schedule_pop()
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  def handle_info(:schedule_pop, state) do
    state
  end

  defp schedule_pop() do
    Process.send_after(self(), :schedule_pop, 5000)
  end

end
