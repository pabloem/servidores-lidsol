# Servidor

Scripts y configuraciones para servidores del laboratorio

## Otras utilidades

El programa 'saturador' sirve para medir capacidad de red en los servidores.
Para correrlo:

```bash
go run saturador.go
```

Para probar la capacidad entre un cliente y este servidor, correr el siguiente comando en el cliente:

```bash
cat /dev/urandom | telnet <ip_servidor> 8080 > /dev/null
```

El programa saturador reportara la cantidad de bytes por segundo que se estan procesando.