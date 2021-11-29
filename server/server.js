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
let intervals = [];

server.on("listening", function() {
  let address = server.address();
  console.log(
    "UDP Server listening on " + address.address + ":" + address.port
  );
});

server.on("message", (data, remote) => {
  let id = `${remote.address}:${remote.port}`;
  //console.log(data);
  if(intervals[id] === undefined)
  {
    console.log(`connection from ${id}`);
    intervals[id] = {};
    intervals[id].value = 0;
    intervals[id].interval = setInterval(() => {
        let arr = [];
        for (let index = 1; index < 151; index++) {
          arr.push(index);
        }
        arr.push(intervals[id].value);
        //console.log('send');
        const data = new Uint8Array(arr);
        client.send(data, 0, data.length, remote.port, remote.address);
        intervals[id].value++;
        //intervals[id].value &= 0xff;
        if(intervals[id].value > 255) {
          intervals[id].value = 0;
        }
        //clearInterval( intervals[id].interval ); //intervals[id].value = 0;
      }, 10);
  }
  else
  {
    console.log(`already connected : ${id}`)
  }
});

server.bind(PORT);
