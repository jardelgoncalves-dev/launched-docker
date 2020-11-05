
<div align="center">
  <h1>Launched Docker</h1>
</div>

## Motivation
Usually I am always launching docker containers and sometimes the commands are similar, changing only a few settings, such as the container port, the same happens when I change machines or operating systems. I could use the docker-compose, but, most projects do not use and it is always a database that needs to run, in this case I prefer to use the docker CLI. So I decided to create a simple CLI to avoid rewriting the command and in many cases saving time in creating new containers.

## Running
First, add execute permission to the `launched-docker.sh` file
```bash
chmod +x ./launched-docker.sh
```

To the run launched-docker:
```
./launched-docker.sh -i <name>
```

## Parameters
| Parameters      | Description |
| --------------- | ----------- |
| -i <string>     | Choose one of the image options below. These images define the container to be launched. See [Images](#Images)      |
| -n <string>     | Define a new name for the container (option not required)        |
| -p <string>     | If you want to change the default port mapping, use this option by passing as the parameter: <port>:<port container> (option not required)        |
| -c <string>     | For any other option (from the docker command), use this option (option not required)        |
| -h              | Show help        |

<br />

## Images
| Name            | Default Name Container | Description |
| --------------- | ---------------------- | ----------- |
| mongo           | mongodb                | Initializes a mongo container |
| mysql           | mysql_db               | Initializes a mysql:5.7 container |
| dynamo          | dynamodb               | Initializes a amazon/dynamodb-local container |

<br />
<br />
<br />

### Example 1: launched a container
To launch a container, you must enter the name of the image (see [Images](#Images)) in the `-i` option (required)
```
./launched-docker.sh -i mongo
```

### Example 2: Change the default name container to be launched
To launch a container by changing the default name
```
./launched-docker.sh -i mongo -n my_mongo
```

### Example 3: Change the default port mapping
To launch a container by changing the default port
```
./launched-docker.sh -i mongo -p 27018:27017
```

### Example 4: How to inform any options of the docker in launched-docker
To launch a container by adding other settings used in the docker CLI
```
./launched-docker.sh -i mongo -c \ 
  "-e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=admin"
```