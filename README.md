# plataforma-proyecto-smart-cities

Crear gps sensor:

- `ruby gps_sensor_setup.rb <DEVICE_ID> <LINEA> <SUBLINEA> <SENTIDO>`

  - `DEVICE_ID`: puede ser cualquier id para caracterizar el sensor en sí. Se usa para obtener/escribir datos en el Context Broker.
  - `LINEA`: Número que identifica una línea. Por ejemplo, 405, 192, 300.
  - `SUBLINEA`: Número que identifica sublínea dentro de la línea cuando tienen más de un recorrido en ambos sentidos. Se puede ver el número y más información sobre el campo en [datos abiertos](https://catalogodatos.gub.uy/dataset/intendencia-montevideo-lineas-omnibus-origen-y-destino)
  - `SENTIDO`: A o B. Sentido en el que va el ómnibus, por más info consultar [datos abiertos](https://catalogodatos.gub.uy/dataset/intendencia-montevideo-lineas-omnibus-origen-y-destino)


Simular datos:
Recorridos sin desvío
- `ruby gps_simulator.rb <DEVICE_ID> <LINEA> <SUBLINEA> <SENTIDO>`

Mismos campos que los que se usen para crear el sensor.

Recorrido con desvío
- `ruby gps_simulator.rb <DEVICE_ID> <LINEA> d`

Busca el archivo `desvio<LINEA>.geojson`. Por ahora el único disponible es para el 405 (desvío para sublinea 3, sentido B)
