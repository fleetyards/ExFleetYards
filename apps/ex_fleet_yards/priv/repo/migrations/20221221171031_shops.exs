defmodule FleetYards.Repo.Migrations.Shops do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:shops, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :slug, :string, null: false
      add :store_image, :string
      add :station_id, references(:stations, type: :uuid)
      add :shop_type, :integer
      add :hidden, :boolean, default: false
      add :rental, :boolean, default: false
      add :buying, :boolean, default: false
      add :selling, :boolean, default: false
      add :refinery_terminal, :boolean
      add :description, :text
      add :location, :string

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists index(:shops, [:station_id])
  end
end

# create table public.shops
# (
#    id                uuid    default public.gen_random_uuid() not null
#        primary key,
#    name              varchar,
#    slug              varchar,
#    created_at        timestamp                                not null,
#    updated_at        timestamp                                not null,
#    store_image       varchar,
#    station_id        uuid,
#    shop_type         integer,
#    hidden            boolean default true,
#    rental            boolean default false,
#    buying            boolean default false,
#    selling           boolean default false,
#    refinery_terminal boolean,
#    description       text,
#    location          varchar
# );
#
# alter table public.shops
#    owner to fleet_yards_dev;
#
# create index index_shops_on_station_id
#    on public.shops (station_id);
