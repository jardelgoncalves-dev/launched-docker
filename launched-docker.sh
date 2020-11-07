helpFunction() {
  printf "\n\
Usage: ${0} [OPTIONS] <string>

Options:
  -i <string>       Choose one of the image options below. These images define the container to be launched. (see Images)
  -n <string>       Define a new name for the container (option not required)
  -p <string>       If you want to change the default port mapping, use this option by passing as the parameter: <port>:<port container> (option not required)
  -c <string:       For any other option (from the docker command), use this option (option not required)
  -h                Show help


Images
  mongo             Initializes a mongo container
  mysql             Initializes a mysql:5.7 container
  dynamodb-local    Initializes a amazon/dynamodb-local container
  postgres          Initializes a postgres:latest container
"
}

declare ARRAY_IMAGES_ALLOWED

ARRAY_IMAGES_ALLOWED=([1]="mongo" [2]="mysql" [3]="dynamo" [4]="postgres")

COMMAND=${0}
PORT=
NAME=
IMAGE=
CONFIG=""

run_mysql() {
  CHANGED_NAME="mysql_db"
  CHANGED_PORT="3306:3306"

  if [ ! -z "${NAME}" ]; then
    CHANGED_NAME=${NAME}
  fi

  if [ ! -z "${PORT}" ]; then
    CHANGED_PORT=${PORT}
  fi


  MYSQL_ROOT_CREDENTIALS="root"

  echo -e "\n\e[1;32mID: \e[1;34m"
  docker run -d --name \
    ${CHANGED_NAME} -p ${CHANGED_PORT} \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_CREDENTIALS} \
    -e MYSQL_USER=${MYSQL_ROOT_CREDENTIALS} ${CONFIG} \
    mysql:5.7

  echo -e "\n\e[1;32mNAME CONTAINER \e[0m"
  echo -e "\e[1;34m${CHANGED_NAME} \e[0m\n"

  echo -e "\n\e[1;32mPORT \e[0m"
  echo -e "\e[1;34m${CHANGED_PORT} \e[0m\n"

  echo -e "\n\e[1;32mACCESS CREDENTIALS \e[0m"
  echo -e "\e[1;34mUSER = ${MYSQL_ROOT_CREDENTIALS} | PASSWORD = ${MYSQL_ROOT_CREDENTIALS} \e[0m\n"
}

run_mongo() {
  CHANGED_NAME="mongodb"
  CHANGED_PORT="27017:27017"

  if [ ! -z "${NAME}" ]; then
    CHANGED_NAME=${NAME}
  fi

  if [ ! -z "${PORT}" ]; then
    CHANGED_PORT=${PORT}
  fi

  echo -e "\n\e[1;32mID: \e[1;34m"
  docker run -d --name ${CHANGED_NAME} -p ${CHANGED_PORT} ${CONFIG} mongo

  echo -e "\n\e[1;32mNAME CONTAINER \e[0m"
  echo -e "\e[1;34m${CHANGED_NAME} \e[0m\n"

  echo -e "\n\e[1;32mPORT \e[0m"
  echo -e "\e[1;34m${CHANGED_PORT} \e[0m\n"
}

run_dynamo() {
  CHANGED_NAME="dynamodb"
  CHANGED_PORT="8000:8000"

  if [ ! -z "${NAME}" ]; then
    CHANGED_NAME=${NAME}
  fi

  if [ ! -z "${PORT}" ]; then
    CHANGED_PORT=${PORT}
  fi

  echo -e "\n\e[1;32mID: \e[1;34m"
  docker run -d --name ${CHANGED_NAME} -p ${CHANGED_PORT} ${CONFIG} amazon/dynamodb-local

  echo -e "\n\e[1;32mNAME CONTAINER \e[0m"
  echo -e "\e[1;34m${CHANGED_NAME} \e[0m\n"

  echo -e "\n\e[1;32mPORT \e[0m"
  echo -e "\e[1;34m${CHANGED_PORT} \e[0m\n"
}

run_postgres() {
  CHANGED_NAME="postgres_db"
  CHANGED_PORT="5432:5432"

  if [ ! -z "${NAME}" ]; then
    CHANGED_NAME=${NAME}
  fi

  if [ ! -z "${PORT}" ]; then
    CHANGED_PORT=${PORT}
  fi

  echo -e "\n\e[1;32mID: \e[1;34m"
  docker run -d --name \
    ${CHANGED_NAME} -p ${CHANGED_PORT} ${CONFIG} \
    postgres

  echo -e "\n\e[1;32mNAME CONTAINER \e[0m"
  echo -e "\e[1;34m${CHANGED_NAME} \e[0m\n"

  echo -e "\n\e[1;32mPORT \e[0m"
  echo -e "\e[1;34m${CHANGED_PORT} \e[0m\n"

  echo -e "\n\e[1;32mACCESS CREDENTIALS \e[0m"
  echo -e "\e[1;34mUSER = postgres | PASSWORD = postgres \e[0m\n"
}

while getopts "i:n:p:c:h" opt
do
  case "$opt" in
    i ) IMAGE="${OPTARG}"  ;;
    n ) NAME="${OPTARG}"   ;;
    p ) PORT="${OPTARG}"   ;;
    c ) CONFIG="${OPTARG}" ;;
    ? ) helpFunction       ;;
  esac
done


run() {
  if [ -z "${IMAGE}" ]; then
    echo -e "\n\e[1;31m It is necessary to inform one of the image options. Run \e[1;32m${COMMAND} -h\e[1;31m to see Images options \e[0m\n"
    exit 0
  fi

  IMAGE_FINDED=false
  for i in "${ARRAY_IMAGES_ALLOWED[@]}";
  do
    if [ "${i}" = "${IMAGE}" ]; then
      IMAGE_FINDED=true
    fi
  done


  if [ ${IMAGE_FINDED} = false ];then
    echo -e "\n\e[1;31m Image not found. Run \e[1;32m${COMMAND} -h\e[1;31m to see Images options \e[0m\n"
    exit 0
  fi

  case "${IMAGE}" in
    mongo    ) run_mongo        ;;
    mysql    ) run_mysql        ;;
    dynamo   ) run_dynamo       ;;
    postgres ) run_postgres     ;;
    ?        ) helpFunction     ;;
  esac
}

run
