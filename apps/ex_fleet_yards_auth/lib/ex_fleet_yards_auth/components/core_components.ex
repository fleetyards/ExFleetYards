defmodule ExFleetYardsAuth.CoreComponents do
  @moduledoc """
  Core Components for Auth module
  """

  use Phoenix.Component

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :role, :string, default: "primary"
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(%{role: "cancel"} = assigns) do
    class_list = [
      "bg-red-500 hover:bg-red-600 active:bg-red-700 focus:border-red-600 ring-red-300 text-white",
      assigns["class"]
    ]

    assigns
    |> assign(role: nil)
    |> assign(class: Enum.join(class_list, ","))
    |> button
  end

  def button(%{role: "primary"} = assigns) do
    class_list = [
      "bg-indigo-400 hover:bg-indigo-500 active:bg-indigo-600",
      "focus:border-indigo-500 ring-indigo-300 text-white",
      assigns["class"]
    ]

    assigns
    |> assign(role: nil)
    |> assign(class: Enum.join(class_list, ","))
    |> button
  end

  def button(%{role: nil} = assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "inline-flex items-center px-4 py-2 border border-transparent rounded-md font-semibold text-xs uppercase",
        "tracking-widest focus:outline-none focus:ring disabled:opacity-25 transition ease-in-out duration-150",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """

  attr :id, :any, default: nil
  attr :name, :any, default: nil
  attr :label, :string, default: nil
  attr :value, :any, default: nil

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
    range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(autocomplete cols disabled form list max maxlength min minlength
                pattern placeholder readonly required rows size step)

  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign(
      :name,
      assigns.name || if(assigns.multiple, do: field.name <> "[]", else: field.name)
    )
    |> assign(:value, assigns.value || field.value)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name} class="flex items-center mt-4">
      <label class="inline-flex items-center text-sm font-medium text-white">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded"
          {@rest}
        />
        <%= @label %>
      </label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # def input(%{type: "select"} = assigns) do
  #  ~H"""
  #  <div phx-feedback-for={@name}>
  #    <.label for={@id}><%= @label %></.label>
  #    <select
  #      id={@id}
  #      name={@name}
  #      class="mt-1 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
  #      multiple={@multiple}
  #      {@rest}
  #    >
  #      <option :if={@prompt} value=""><%= @prompt %></option>
  #      <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
  #    </select>
  #    <.error :for={msg <- @errors}><%= msg %></.error>
  #  </div>
  #  """
  # end

  # def input(%{type: "textarea"} = assigns) do
  #  ~H"""
  #  <div phx-feedback-for={@name}>
  #    <.label for={@id}><%= @label %></.label>
  #    <textarea
  #      id={@id}
  #      name={@name}
  #      class={[
  #        "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
  #        "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
  #        "min-h-[6rem] border-zinc-300 focus:border-zinc-400",
  #        @errors != [] && "border-rose-400 focus:border-rose-400"
  #      ]}
  #      {@rest}
  #    ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
  #    <.error :for={msg <- @errors}><%= msg %></.error>
  #  </div>
  #  """
  # end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm dark:border-gray-700 rounded-md dark:bg-gray-700 dark:text-white",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :value, :any

  def hidden_input(assigns) do
    ~H"""
    <input type="hidden" name={@name} id={@id} value={@value} />
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-medium dark:text-white">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Renders a [Hero Icon](https://heroicons.com).

  Hero icons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid an mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from your `assets/vendor/heroicons` directory and bundled
  within your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, _opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    # if count = opts[:count] do
    #  Gettext.dngettext(TestWeb.Gettext, "errors", msg, msg, count, opts)
    # else
    #  Gettext.dgettext(TestWeb.Gettext, "errors", msg, opts)
    # end
    msg
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
