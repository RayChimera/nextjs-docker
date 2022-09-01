export DOCKER_BUILDKIT=1

while inotifywait -q -e create -e modify -e delete -e move app-in-development app-in-development/pages app-in-development/pages/api app-in-development/public app-in-development/styles
  do
    docker build . -t nextjs --target dev
    docker rm -f nextjs
    docker run -d -p 3000:3000 --name nextjs nextjs
  done
