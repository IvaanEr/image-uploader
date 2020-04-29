defmodule ImageUploader.Buffer do
  use GenServer

  # TODO change to AwsUtils if you want to save there
  alias ImageUploader.FileUtils

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

  @impl true
  def handle_info(:schedule_pop, state) do
    upload_images(state)
    schedule_pop()
    {:noreply, []}
  end

  defp schedule_pop() do
    Process.send_after(self(), :schedule_pop, 5000)
  end

  defp upload_images([]), do: :ok
  defp upload_images([{id, image}|tail]) do
    %DateTime{microsecond: {now, _}} = DateTime.utc_now()
    FileUtils.upload_binary(image, "device_#{id}_#{now}")
    upload_images(tail)
  end
end
