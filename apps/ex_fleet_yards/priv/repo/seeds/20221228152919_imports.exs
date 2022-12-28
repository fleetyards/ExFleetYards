defmodule ExFleetYards.Repo.Seeds.Imports do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Import, [:version], [
    %{
      aasm_state: :finished,
      finished_at: ~U[2022-11-18 21:35:48Z],
      started_at: ~U[2022-11-18 21:31:32Z],
      version: "3.17.4-LIVE.8288902",
      type: :sc_data_import,
      created_at: ~U[2022-11-18 21:35:48Z]
    },
    %{
      aasm_state: :finished,
      created_at: ~U[2022-11-18 21:30:25Z],
      failed_at: nil,
      finished_at: ~U[2022-11-18 21:34:40Z],
      started_at: ~U[2022-11-18 21:30:25Z],
      type: :sc_data_import,
      updated_at: ~U[2022-11-18 21:34:40Z],
      version: "3.17.4-LIVE.8288901"
    }
  ]
end
