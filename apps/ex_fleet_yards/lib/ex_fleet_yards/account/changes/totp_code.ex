defmodule ExFleetYards.Account.Changes.TotpCode do
  @moduledoc """
  Validate a TOTP code.
  """
  use Ash.Resource.Change
  import Ash.Changeset

  def change(changeset, opts, _context) do
    code = get_argument(changeset, :totp_code)

    recovery = Keyword.get(opts, :recovery, true)

    code_valid?(code, changeset, recovery)
    |> case do
      {true, changeset} ->
        changeset
        |> update_last_used()

      {false, changeset} ->
        changeset
        |> add_error(:totp_code)
    end
  end

  defp code_valid?(code, changeset, false) do
    {NimbleTOTP.valid?(get_data(changeset, :totp_secret), code,
       since: get_data(changeset, :last_used)
     ), changeset}
  end

  defp code_valid?(code, changeset, true) do
    code_valid?(code, changeset, false)
    |> case do
      {true, changeset} ->
        {true, changeset}

      {false, changeset} ->
        recovery_codes = get_data(changeset, :recovery_codes)

        pop_code(recovery_codes, code)
        |> case do
          {:ok, recovery_codes} ->
            {true, change_attribute(changeset, :recovery_codes, recovery_codes)}

          {:error, recovery_codes} ->
            {false, change_attribute(changeset, :recovery_codes, recovery_codes)}
        end
    end
  end

  defp update_last_used(changeset) do
    change_attribute(changeset, :last_used, DateTime.utc_now())
  end

  defp pop_code(list, code) do
    code = String.upcase(code)

    case Enum.find_index(list, &(&1 == code)) do
      nil ->
        {:error, list}

      index ->
        {:ok, List.delete_at(list, index)}
    end
  end
end
