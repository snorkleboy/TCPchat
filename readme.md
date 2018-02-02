
# TCPchat
### A Websocket and TCP instant chat service. chat.artemkharshan.com:80 is a aws server which impliments instant chat between using using Websockets. chat.artemkharshan.com:90 is a TCP server that impliments instant chat between users directly through TCP. You can use anything from telnet to netcat to connect to it and chat. The Two servers also send messages to eachother, so users on the TCP server seamlessly chat with browser clients and visa versa. 


## TCPclient
simply make a tcp connection to the server and you will be prompted for a username and can request a list of signed on users. 
once signed on you can type messages to send in the cli and messages recieved will be tagged by author.

## console commands of TCP server 

### 'see'
shows a list of users and running threads. Note that the server is always user[0].

### 'diss'
closes all connections in the User pool

### 'myip'
outputs your IP 

### 'msg your message here'
broadcasts any string that comes after msg to all users. Note that you do not need to wrap your message in quotes, and it
will be ouputed as 'serverName: your message.

## future 

- chatrooms
- better console commands
- make it respond to a http get request
- make a simple webapp as a gui for the server. 
