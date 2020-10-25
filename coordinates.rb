module Coordinates
  def get_coordinates(filename, linea, sublinea, sentido)
    file = File.open("#{file_for_coordinates}.geojson")
    file_hash = JSON.parse(file.read)

    feature = file_hash["features"].find { |feature| bus?(feature["properties"], linea, sublinea, sentido) }

    feature.dig("geometry", "coordinates", 0)
  end

  def get_desvio(linea)
    file = File.open("desvio#{linea}.geojson")
    file_hash = JSON.parse(file.read)

    file_hash["features"].map { |point| point["geometry"]["coordinates"] }
  end

  private

  def bus?(feature, linea, sublinea, sentido)
    feature["DESC_LINEA"] == linea and feature["COD_SUBLIN"] == sublinea.to_i and feature["DESC_VARIA"] == sentido
  end
end
