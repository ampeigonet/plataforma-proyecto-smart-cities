# plataforma-proyecto-smart-cities

## Sensores GPS

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


## Sensores Playas

Para el simulador de las playas hay que crear un archivo `json` con estructura similar a la de `beaches_sample.json`.

Los campos de estos se describen a continuacion:

```json
[
    {
        "id": "id de la playa",
        "name": "nombre de la playa",
        "location": "[lat, long]",
        "people_sensors": "array de tipo sensor",
        "tide_sensors": "array de tipo sensor",
        "uv_sensors": "array de tipo sensor",
        "water_quality_sensors": "array de tipo sensor",
        "people_capacity": "capacidad de la playa en entero"
    }
]
```

A su vez un array de tipo sensor es un objeto con los siguientes campos:

```json
[
    {
        "id": "id del sensor como string",
        "location": "[lat, long]",
        "value_max_range": "valor maximo incial de lectura del sensor en formato entero",
        "value_min_range": "valor minimo incial de lectura del sensor en formato entero",
        "random_seed": "semilla para aleatoriedad de los datos en formato entero",
        "random_std_deviation": "desviacion estandar del azar de los datos en formato entero",
        "frozen": "si se desea que el sensor de siempre los mismos datos a lo largo del tiempo, formato booleano"
    }
],
```

Los sensores dan sus datos segun una distribucion normal, con media = promedio de los enteros del rango `[value_min_range..value_max_range]`.

Los sensores persona ademas tienen un ajuste gradual del minimo y maximo a medida que se evoluciona para simular "el paso del tiempo". En horas tempranas del dia, las personas que llegan a la playa van en aumento hasta que a partir de una hora las personas empiezan a irse. Estos cambios son acelerados, es decir que el incremento de personas aumenta a partir de un momento y lo mismo sucede con el egreso.
