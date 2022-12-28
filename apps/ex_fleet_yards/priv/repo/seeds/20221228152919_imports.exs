defmodule ExFleetYards.Repo.Seeds.Imports do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Import, [:version], [
    %{
      aasm_state: :finished,
      finished_at: ~N[2022-11-18 21:35:48],
      started_at: ~N[2022-11-18 21:31:32],
      version: "3.17.4-LIVE.8288902",
      type: :sc_data_import,
      created_at: ~N[2022-11-18 21:35:48]
    },
    %{
      aasm_state: :finished,
      created_at: ~N[2022-11-18 21:30:25],
      failed_at: nil,
      finished_at: ~N[2022-11-18 21:34:40],
      started_at: ~N[2022-11-18 21:30:25],
      type: :sc_data_import,
      updated_at: ~N[2022-11-18 21:34:40],
      version: "3.17.4-LIVE.8288901"
    }
  ]
end
