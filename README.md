# plataforma-proyecto-smart-cities

# Simulador GPS

Es un script hecho en ruby que se encarga de imprimir datos de posición cada 5 segundos. El resto de la información es la 
requerida para el formato NGSI-LD.

## Para correr el simulador

En una consola hacer `ruby gps_simulator.rb`

### Notas:

- Por ahora sólo corre una línea (Bus 405)
- En el futuro además de imprimir va a hablar con el agente correspondiente para actualizar información
- La información de las coordenadas está en texto plano como un array. En el futuro vamos a tener dumps con datos para la simulación
para distintas líneas.
