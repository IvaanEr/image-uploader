defmodule ImageUploader.Buffer do
  @moduledoc """
  Handle stack state to queueing images before saving
  """
  use GenServer

  @wait_time 1000
  @upload_delay 2000

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
    Process.send_after(self(), :schedule_pop, @wait_time)
  end

  defp upload_images([]), do: :ok
  defp upload_images([{id, image}|tail]) do
    %DateTime{microsecond: {now, _}} = DateTime.utc_now()
    # Replace to AwsUtils when needed
    FileUtils.upload_binary(image, "img:#{id}:#{now}")

    # - Local network upload speed is 200mbps.
    # - Image file size is an average of 4mb.
    # So every image take ~2seg to upload
    :timer.sleep(@upload_delay)

    upload_images(tail)
  end
end
