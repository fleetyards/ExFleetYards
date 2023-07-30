defmodule ExFleetYardsAuth.Api.TotpSchema do
  @moduledoc """
  Schema definitions for TOTP
  """
  use ExFleetYards.Schemas, :schema

  defmodule UserHasTotp do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User has totp",
      type: :object,
      properties: %{
        has_totp: %Schema{type: :boolean}
      },
      required: [:has_totp],
      example: %{has_totp: true}
    })
  end

  ExFleetYards.Schemas.result(
    TotpSecret,
    "Totp secret",
    %{
      secret: %OpenApiSpex.Schema{type: :string}
    },
    [:secret]
  )

  result(
    TotpRecovery,
    "Totp Recovery",
    %{
      recovery_codes: %OpenApiSpex.Schema{type: :array, items: %OpenApiSpex.Schema{type: :string}}
    },
    [:recovery_codes]
  )
end
