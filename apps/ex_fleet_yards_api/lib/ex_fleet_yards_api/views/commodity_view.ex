defmodule ExFleetYardsApi.CommodityView do
  use ExFleetYardsApi, :view

  def render("show.json", %{commodity: _commodity}) do
    %{
      # # TODO: images
      # subCategory: commodity.commodity.commodity_type,
      # subCategoryLabel: Types.CommodityType.humanize(commodity.commodity.commodity_type),
      # description: commodity.commodity.description,
      # averageBuyPrice: commodity.average_buy_price,
      # rentalPrice1Day: commodity.rental_price_1_day,
      # averageRentalPrice1Day: commodity.average_rental_price_1_day,
      # rentalPrice3Days: commodity.rental_price_3_days,
      # averageRentalPrice3Days: commodity.average_rental_price_3_days,
      # rentalPrice7Days: commodity.rental_price_7_days,
      # averageRentalPrice7Days: commodity.average_rental_price_7_days,
      # rentalPrice30Days: commodity.rental_price_30_days,
      # averageRentalPrice30Days: commodity.average_rental_price_30_days,
      # commodityItemId: commodity.commodity.id
    }
  end
end
