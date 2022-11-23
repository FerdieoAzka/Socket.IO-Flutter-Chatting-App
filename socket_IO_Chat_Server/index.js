const express = require("express");
const { createServer } = require("http");
const { Server } = require("socket.io");

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

app.route("/").get((req, res) => {
    res.json("Hello World")
})

io.on("connection", (socket) => {

    socket.join("socketIO");

    socket.on("unsendMsg", (uuidMsg) => {
        console.log("msguuid", uuidMsg)
        io.to("socketIO").emit("deleteMsg", uuidMsg);

    })

    socket.on("sendMsg", (msg) => {
        console.log("msg", msg);
        io.to("socketIO").emit("sendMsgFromServer", { ...msg, type: "otherMsg" });
        console.log("msg", msg);
    })

})


httpServer.listen(3000)
