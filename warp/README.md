```sh
docker build --no-cache -t warp .

docker run -d \
  -v $PWD/data:/var/lib/cloudflare-warp \
  --restart unless-stopped \
  --name warp \
  warp

docker inspect warp | grep IPAddress

curl https://httpbin.org/ip
curl -x "socks://172.17.0.5:1080" https://httpbin.org/ip

curl https://1.1.1.1/cdn-cgi/trace
curl -x "socks://172.17.0.5:1080" https://1.1.1.1/cdn-cgi/trace
```