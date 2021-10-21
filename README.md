# Simple UDP Feedback Server

A Lazarus UDP server that send a feedback message to client after requisition.

## Parameters:
The parameters are stored in the ```conf.config``` file and they are loaded by the software. Description below:

- **Host IP Address (Server)**: server IP address, i.e. address where this server is running. This is the address to request the feedback message;
- **Host IP Port (Server)**: server IP port. This is the port to request the feedback message;
- **Publish at IP Address (Client)**: destination IP address. This is the address to send the feedback message;
- **Publish at IP Port (Client)**: destination port address. This is the port to send the feedback message;
- **Feedback Message**: feedback message to send back.
