while inotifywait -q -e create -e modify -e delete -e move app-in-development
  do
    docker build . -t nextjs
    docker rm -f nextjs
    docker run -d -p 3000:3000 --name nextjs nextjs
  done
