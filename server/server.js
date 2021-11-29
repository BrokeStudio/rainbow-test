'use strict';

/*
                                                                        
                                                                        
                                                                        
                                                                        
,adPPYba,   ,adPPYba,  8b,dPPYba,  8b       d8   ,adPPYba,  8b,dPPYba,  
I8[    ""  a8P_____88  88P'   "Y8  `8b     d8'  a8P_____88  88P'   "Y8  
 `"Y8ba,   8PP"""""""  88           `8b   d8'   8PP"""""""  88          
aa    ]8I  "8b,   ,aa  88            `8b,d8'    "8b,   ,aa  88          
`"YbbdP"'   `"Ybbd8"'  88              "8"       `"Ybbd8"'  88          
                                                                        
                                                                        
*/
const dgram = require("dgram");

const PORT = 1235;

const server = dgram.createSocket("udp4");
const client = dgram.createSocket("udp4");
let interval, id, value;

server.on("listening", function() {
  let address = server.address();
  console.log(
    "UDP Server listening on " + address.address + ":" + address.port
  );
});

server.on("message", (data, remote) => {
  let newID = `${remote.address}:${remote.port}`;
  if(id !== newID)
  {
    if(id !== undefined) console.log(`unregistering ${id}`);
    id = newID;
    console.log(`registering ${id}`);
    value = 0;
    if(interval !== undefined) clearInterval(interval);
    interval = setInterval(() => {
      let arr = [];
      for (let index = 1; index < 151; index++) {
        arr.push(index);
      }
      arr.push(value);
      const data = new Uint8Array(arr);
      client.send(data, 0, data.length, remote.port, remote.address);
      value++;
      value &= 0xff;
    }, 1);
  }
  else
  {
    console.log(`message from ${id}`);
  }
});

server.bind(PORT);
